Time tracker for Todo.txt
=========================

Donow add-on allows to keep track of the total time spent on an activity

## Keep track of current work

Donow writes on the stdout the **current activity and the time spent on it** since the last start. Each 10 minutes (configurable) a **desktop notification** will remind you the current running activity, to avoid to forget to stop the timer when not needed anymore.


## Donow item format

When the timer is stopped using CTRL-C, donow will append a substring *min:total-time-spent* (being **time** expressed in minutes) to the activity description.
When the pattern "min:number" already exists, Donow just updates the counter.

## Example of use

```
    $ todo.sh list                                                                                                                               
    1 design Python interface for Todo.txt
    2 write a basic description of donow addon min:5
    --
    TODO: 2 of 2 tasks shown
    $ todo.sh donow 1                                                                                                                            
    Working on: design Python interface for Todo.txt 
    [design Python interface for Todo.txt] 11 minute(s) passed^C
    1 design Python interface for Todo.txt min:11
    $ todo.sh donow 2                                                                                                                            
    Working on: write a basic description of donow addon min:5 
    [write a basic description of donow addon min:5] 12 minute(s) passed^C
    2 write a basic description of donow addon min:5
    TODO: Replaced task with:
    2 write a basic description of donow addon min:17
```
