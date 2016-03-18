#!/usr/bin/python

""" TODO.TXT Weekly Review
USAGE:
    weeklyreview.py [todo.txt] [done.txt] [projects.txt]

USAGE NOTES:
    Expects three text files as parameters:
    1 & 2. Properly-formatted todo.txt and done.txt files.
    3. A projects.txt file which lists one project per line, and any number of #goals associated with it.

    See more on todo.txt here:
    http://todotxt.com

OUTPUT:
    Displays a count of how many tasks were completed associated with a goal.

"""

import sys
import datetime

__version__ = "1.2"
__date__ = "2016/03/17"
__updated__ = "2016/03/17"
__author__ = "Gina Trapani (ginatrapani@gmail.com)"
__copyright__ = "Copyright 2016, Gina Trapani"
__license__ = "GPL"
__history__ = """
0.1 - WIP
"""

def usage():
    print("USAGE:  %s [todo.txt] [done.txt] [projects.txt]" % (sys.argv[0], ))

def separator(c, r=42):
    sep = ""
    sep = c * r
    print(sep)

def printTitle(text):
    print("")
    r = len(text)
    print(text)
    separator("=", r)

def printHeader(text):
    r = len(text)
    print("")
    print(text)
    separator("-", r)

def main(argv):
    # make sure you have all your args
    if len(argv) < 3:
       usage()
       sys.exit(2)

    goal_projects = getGoalProjects(argv)
    #print(goal_projects)

    last_7_days = getLast7Days()
    #print(last_7_days)

    last_7_days_of_completions = getLast7DaysOfCompletions(argv, last_7_days)
    #print(last_7_days_of_completions)

    project_completions = getProjectCompletions(argv, last_7_days_of_completions)
    #print(project_completions)

    goal_completions = getGoalCompletions(goal_projects, project_completions)
    # print(goal_completions)

    # Print report: For each item in goal_projects, print the goal, the number of tasks completed,
    #   then each project and the number of tasks completed
    printTitle("Weekly Review for the past 7 days")

    goals_not_moved = []
    goals_moved = []
    for goal in goal_projects:
        total_done = 0
        if goal in goal_completions:
            total_done = len(goal_completions[goal])
        goal_header = goal + " - " + str(total_done) + " done"
        if total_done > 0:
            printHeader(goal_header)
            for project in goal_projects[goal]:
                if project in project_completions:
                    print(project + " - " + str(len(project_completions[project])) + " done" )
                    for task in project_completions[project]:
                        print("    " + task.strip())
            goals_moved.append(goal)
        else:
            goals_not_moved.append(goal)

    # Print a list of goals that had no movement
    if len(goals_not_moved) > 0:
        printTitle("Goals with no progress")
        for goal in goals_not_moved:
            print(goal)

    # Print summary
    print("")
    summary = str(len(last_7_days_of_completions)) + " completed tasks moved " + str(len(goals_moved)) + " out of " + str(len(goal_projects)) + " goals forward."
    separator("-", len(summary))
    print(summary)
    separator("-", len(summary))


# Return an array of goals with total tasks completed.
def getGoalCompletions(goal_projects, project_completions):
    goal_completions = {}
    goals = goal_projects.keys()
    for goal in goal_projects:
        for project in project_completions:
            if project in goal_projects[goal]:
                if goal not in goal_completions:
                    goal_completions[goal] = project_completions[project]
                else:
                    goal_completions[goal] = goal_completions[goal] + project_completions[project]
    return goal_completions

# Return the goal/project list as an array of arrays goalProjects[goal] = projects[]
def getGoalProjects(argv):
    try:
        goal_projects = {}
        f = open (argv[2], "r")
        for line in f:
            words = line.split()
            for word in words:
                # Project
                if word[0:1] == "+":
                    current_project = word
                # Goal
                if word[0:1] == "#":
                    if word not in goal_projects:
                        goal_projects[word] = [current_project];
                    else:
                        goal_projects[word].append(current_project)
        f.close()
        return goal_projects
    except IOError:
        print("ERROR:  The file named %s could not be read."% (argv[1], ))
        usage()
        sys.exit(2)


# Get the last 7 days as an array of todo.txt-formatted dates.
def getLast7Days():
    today = datetime.date.today()
    last7Days = []
    for d in range(8):
        day_this_week = today - datetime.timedelta(days=d)
        last7Days.append(day_this_week.strftime('%Y-%m-%d'))
    return last7Days

# Return last 7 days of completed tasks from done.txt
def getLast7DaysOfCompletions(argv, last_7_days):
    try:
        last_7_days_of_completions = []
        f = open (argv[1], "r")
        for line in f:
            words = line.split()
            if len(words) > 2 and words[1] in last_7_days:
                last_7_days_of_completions.append(line)
        f.close()
        return last_7_days_of_completions
    except IOError:
        print("ERROR:  The file named %s could not be read."% (argv[1], ))
        usage()
        sys.exit(2)

# Return an array of projects with the total tasks completed.
def getProjectCompletions(argv, last_7_days_of_completions):
    project_completions = {}
    for task in last_7_days_of_completions:
        words = task.split()
        for word in words:
            if word[0:2] == "p:" or word[0:2] == "p-" or word[0:1] == "+":
                if word not in project_completions:
                    project_completions[word] = [task]
                else:
                    project_completions[word].append(task)
    return project_completions


if __name__ == "__main__":
    main(sys.argv[1:])
