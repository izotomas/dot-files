# pbi - create, query, assign, complete pbis

TODO : fish autocomplete

## CLI

### attach

moves a work item to current sprint

### create

creates a new work item in the current sprint

todo:
    - [] set name
    - [] reference feature

### commit

sets the pbi to commited state

todo:
    - [] add current user to it
    - [] move to current iteration, if it isn't yet

### complete

sets the pbi to done state

todo:
    - []

### remove

sets the pbi to done state

### open

opens the work item in the web browser

### pr

manages pull requests

#### new (optional: --draft)
creates a pull request

List of things needed to implement:
 - [] find current sprint pbis
 - [] create pull request and assign:
        - title
        - repo + branch
        - pbi (lookup from current sprint)
        - add reviewer
        - (extra) flag as draft

#### publish

#### complete

