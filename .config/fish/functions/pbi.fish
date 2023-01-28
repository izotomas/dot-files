# pbi - create, query, assign, complete pbis and pull-requests
# TODO: fish completions

function __pbi_pick_work_item
    argparse 't/team=' 'i/item-type=+' -- $argv
    set -l team $_flag_t
    if test -z "$team"
        echo "missing team name"
        return 1
    end

    set -l item_type $(for i in $_flag_i; echo $i; end | sed 's/.*/\'&\'/g' | string join ",")
    if test -z "$item_type"
        set item_type "'Product Backlog Item','Feature','Task'"
    end

    set -l query "\
    SELECT \
        [System.Id],\
        [System.Title],\
        [System.WorkItemType]\
    FROM workitems\
    WHERE\
        [System.AreaLevel3] = '$team'\
        AND [System.WorkItemType] IN ($item_type)\
        AND [System.State] NOT IN ('Done','Removed')\
    ORDER BY [System.ChangedDate] DESC"

    set -l work_items (az boards query --wiql "$query")

    set work_items (echo $work_items | jq -r '.[] | .fields | "\( .["System.Id"] ) | \( .["System.WorkItemType"] ) : \( .["System.Title"] )"' )
    set -l work_item (string split '\n' $work_items | sed "s/Product Backlog Item/PBI /g" | fzf-tmux -- --with-nth 2 -d"\|" --header "Select Work Item" | cut -d" " -f1)
    echo $work_item
end

function __pbi_get_current_iteration -a team
    if test (count $argv) -lt 1
        echo "missing team name"
        return 1
    end

    az boards iteration team list --team $team --timeframe current --query '[0].path' -o tsv
end

function __pbi_get_account
    az account show --query 'user.name' -o tsv
end

function __pbi_pick_branch -a repo
    if test -z "$repo"
        echo "missing repository"
        return 1
    end

    set -l branch $(az repos ref list -r $repo --query "[].name" -o tsv | sed "s/refs\/heads\///g" | string match -v -r "main|master" | fzf-tmux -- --header "Select Target Branch")
    echo $branch
end

function __pbi_create
    # TODO: Add relation after creation
    # TODO: Set Team

    set help_text "pbi create - create new work item

Interactive tool for creation of Tasks, PBIs and Features.
Unless creating a feature, a parent must be specified.

Usage:
    pbi create

Flags:
    -h, --help      prints help for pbi create utility"

    argparse -i 'h/help' 't/team=' -- $argv

    if test -n "$_flag_h"
        echo $help_text
        return 0
    end

    set -l team "$_flag_t"
    if test -z "$team"
        echo "missing team name"
        return 1
    end

    read --prompt-str "Title: " title
    test -z "$title" && return 1

    read --prompt-str "Description: " description

    printf "Type: "
    set -l item_type (printf "%s\n" { "Task", "Product Backlog Item", "Feature", "Bug" } | fzf-tmux --header "Select Work Item Type")
    test -z "$item_type" && return 1
    printf "$item_type\n"

    switch $item_type
        case "Task"
            printf "Parent: "
            set parent $(__pbi_pick_work_item -t $team -i"Product Backlog Item" )
            test -z "$parent" && return 1
            printf "$parent\n"
        case "Product Backlog Item"
            printf "Parent: "
            set parent $(__pbi_pick_work_item -t $team -i"Feature" )
            test -z "$parent" && return 1
            printf "$parent\n"
        case "*"
            set parent ""
    end

    # TODO: Set Work Area (i.e. TEAM)
    # TODO: Set parent
    az boards work-item create --title "$title" --type "$item_type" --description $description

end

function __pbi_commit
    set help_text "pbi commit - commit to a task or pbi in current sprint

Interactive tool for commiting to work items.
The work item will be immediately pulled into the current sprint.

Usage:
    pbi commit

Flags:
    -h, --help      prints help for pbi commit utility"
    argparse -i 'h/help' 't/team=' -- $argv

    if test -n "$_flag_h"
        echo $help_text
        return 0
    end

    set -l team "$_flag_t"
    if test -z "$team"
        echo "missing team name"
        return 1
    end

    set -l account (__pbi_get_account)
    set -l iteration $(__pbi_get_current_iteration $team)
    set -l work_item $(__pbi_pick_work_item -t $team)
    if contains "" { "$account", "$iteration", "$work_item" }
        return 1
    end

    # find type of work item
    set -l item_type $(az boards work-item show --id $work_item --query "fields.\"System.WorkItemType\"" -o tsv)

    # PBIs - 'Commited', Task/Feature - 'In Progress'
    set -l state "In Progress"
    if test "$item_type" = "Product Backlog Item"
        set state "Commited"
    end

    # set progress
    az boards work-item update --id $work_item --state $state --assigned-to $account --iteration $iteration 2>/dev/null
end

function __pbi_complete -a team
    if test (count $argv) -lt 1
        echo "missing team name"
        return 1
    end

    set -l account (__pbi_get_account)
    set -l iteration $(__pbi_get_current_iteration $team)
    set -l work_item $(__pbi_pick_work_item -t $team)
    if contains "" { "$account", "$iteration", "$work_item" }
        return 1
    end

    az boards work-item update --id $work_item --state 'Done' --assigned-to $account >/dev/null
end

function __pbi_open -a team
    set -l work_item $(__pbi_pick_work_item -t $team)
    if test -z "$work_item"
        return 1
    end

    az boards work-item show --id $work_item --open >/dev/null
end

function __pbi_remove -a team
  set -l work_item $(__pbi_pick_work_item -t $team)
    if test -z "$work_item"
        return 1
    end

    az boards work-item update --id $work_item --state 'Removed' --assigned-to "" >/dev/null
end

function __pbi_pr_new -a team
    set -l current_repo $(git config --get remote.origin.url | rev | cut -d"/" -f1 | rev)

    set -l draft false
    if contains -- --draft $argv
        set draft true
        printf "[Draft] "
    end
    printf "Creating PR...\n"

    read --prompt-str "Title: " title
    test -z "$title" && return 1

    read --prompt-str "Description: " description
    test $status -eq 1 && return 1

    read -c "$current_repo" --prompt-str "Repository: " repo
    test -z "$repo" && return 1

    printf "Branch: "
    set -l branch $(__pbi_pick_branch $repo)
    printf "$branch\n"
    test -z "$branch" && return 1

    printf "Work Item: "
    set -l work_item $(__pbi_pick_work_item -t $team -i"Task" -i"Product Backlog Item" -i "Bug")
    test -z "$work_item" && return 1
    printf "#$work_item\n"

    az repos pr create --title "$title" --description "$description" --work-items "$work_item" --repository "$repo" --source-branch $branch --draft $draft >/dev/null
end

function __pbi_pr_publish
    set -l account (__pbi_get_account)
    test -z "$account" && return 1

    printf "Publish PR: "
    set -l prs_draft $(az repos pr list --project "Velocity" --creator $account | jq ".[] | select( .isDraft == true ) | { title: ( (.pullRequestId|tostring) + \" | \" + .repository.name + \" : \" + .title ) }" | jq -s '.')
    set -l pr_publish (echo $prs_draft | jq -r '.[] | .title' | fzf-tmux -- --with-nth 2 -d"\|" --header " Select Pull Request" | cut -d" " -f1)
    test -z "$pr_publish" && return 1
    printf "#$pr_publish\n"

    az repos pr update --id $pr_publish --draft false >/dev/null
end

function __pbi_pr_complete
    set -l account (__pbi_get_account)
    test -z "$account" && return 1


    # pick from any active PR by author that has been approved at least once
    printf "Complete PR: "
    set -l prs_approved $(az repos pr list --project "Velocity" --creator $account | jq ".[] | select(any(.reviewers[]; .vote != 0)) | { title: ( (.pullRequestId|tostring) + \" | \" + .repository.name + \" : \" + .title ) }" | jq -s '.')
    set -l pr_complete (echo $prs_approved | jq -r '.[] | .title' | fzf-tmux -- --with-nth 2 -d"\|" --header " Select Pull Request" | cut -d" " -f1)
    printf "$pr_complete\n"
    test -z "$pr_complete" && return 1

    # create commit message
    set -l commit_message "Merged PR $pr_complete: $(az repos pr show --id $pr_complete --query title -o tsv)"

    # complete the pull request
    az repos pr update --id $pr_complete --status completed --transition-work-items false --delete-source-branch true --squash true --merge-commit-message "$commit_message" >/dev/null
end

function pbi
    set -l TEAM "Team Track"
    set -l help_text "pbi - tool for managing work items (pbis) on azure boards

Usage:
    pbi [command]

Avaiable commands:
    commit      commit to a task or pbi in current sprint
    create      create new work item
    dragin      drag a taks or pbi to current sprint
    complete    complete one of your assigned work items in the current sprint
    open        open work item in the default web browser
    remove      set removed state to given work item
    pr          manage pull requests

Flags:
    -h, --help      prints help for pbi utility

Use \"pbi [command] --help\" for mor information about a command"

    set -l help_flags {"-h", "--help"}

    set -l mode $argv[1]
    if contains -- "$mode" $help_flags
        echo $help_text
        return 0
    end

    switch $mode
        case "dragin"
            echo "mode not implemented yet: $mode"
            return 1
        case "create"
            __pbi_create -t $TEAM $argv[2..]
            return 1
        case "commit"

            __pbi_commit -t $TEAM $argv[2..]
        case "complete"
            __pbi_complete $TEAM
        case "open"
            __pbi_open $TEAM
        case "remove"
            __pbi_remove $TEAM
        case "pr"
            set pr_mode $argv[2]

            set help_text "pbi pr - manage pull requests

Usage:
    pbi pr [command]

Available commands:
    new         create new pull request
    publish     publish your pull request draft
    complete    complete your pull request

Flags:
    -h, --help      prints help for pbi pr utility

Use \"pbi pr [command] --help\" for mor information about a command"

            if contains -- "$pr_mode" $help_flags
                echo $help_text
                return 0
            end

            switch $pr_mode
                case "new"
                    __pbi_pr_new $TEAM -- $argv[2..]
                case "publish"
                    __pbi_pr_publish
                case "complete"
                    __pbi_pr_complete
                case "*"
                    echo $help_text
                    return 1
            end
        case "*"
            echo $help_text
            return 1
    end
end

