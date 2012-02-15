#!/usr/bin/python

""" TODO.TXT Bird's Eye View Reporter
USAGE:  
	birdseye.py [todo.txt] [done.txt]
	
USAGE NOTES:
	Expects two text files as parameters, each of which formatted as follows:
	- One todo per line, ie, "call Mom"
	- with an optional project association indicated as such: "+projectname"
	- with the context in which the tasks should be completed, indicated as such: "@context"
	- with the task priority optionally listed at the front of the line, in parens, ie, "(A)"
	
	For example, 4 lines of todo.txt might look like this:

	+garagesale @phone schedule Goodwill pickup
	(A) @phone Tell Mom I love her
	+writing draft Great American Novel
	(B) smell the roses
	
	The done.txt file is a list of completed todo's from todo.txt.
	
	See more on todo.txt here:
	http://todotxt.com
	
	
OUTPUT:
	Displays a list of:
	- working projects and their percentage complete
	- contexts in which open todo's exist
	- contexts and projects with tasks that have been prioritized
	- projects which are completely done (don't have any open todo's)

CHANGELOG:
	2006.07.29 - Now supports p:, p- and + project notation.  Tx, Pedro!
	2006.05.02 - Released
"""


import sys
#import datetime

__version__ = "1.1"
__date__ = "2006/05/02"
__updated__ = "2006/07/29"
__author__ = "Gina Trapani (ginatrapani@gmail.com)"
__copyright__ = "Copyright 2006, Gina Trapani"
__license__ = "GPL"
__history__ = """
1.0 - Released.
"""

def usage():
	print "USAGE:  %s [todo.txt] [done.txt]"% (sys.argv[0], )

def printTaskGroups(title, taskDict, priorityList, percentages):
	print ""	
	print "%s"% (title,)
	separator("-")
	if not taskDict:
		print "No items to list."
	else:
		# sort the dictionary by value
		# http://python.fyxm.net/peps/pep-0265.html
		items = [(v, k) for k, v in taskDict.items()]
		items.sort()
		items.reverse()             # so largest is first
		items = [(k, v) for v, k in items]

		for item in items:	
			if item[0] in priorityList:
				if item[0] not in percentages:
					printTaskGroup(item, -1, "*")
				else:
					printTaskGroup(item, percentages[item[0]], "*")

		for item in items:
			if item[0] not in priorityList:
				if item[0] not in percentages:
					printTaskGroup(item, -1, " ")
				else:
					printTaskGroup(item, percentages[item[0]], " ")
			
def printTaskGroup(p, pctage, star):
	if pctage > -1:
		progressBar = ""
		numStars = (pctage/10)
		progressBar = "=" * numStars
		numSpaces = 10 - numStars
		for n in range(numSpaces):
			progressBar += " "	

		if pctage > 9:	
			displayTotal = " %d%%"% (pctage, );
		else:
			displayTotal = "  %d%%"% (pctage, );
		print "%s %s [%s] %s (%d todo's)"% (star, displayTotal, progressBar,  p[0], p[1],)
	else:
		print "%s %s (%d todo's)"% (star, p[0], p[1], )
	
def separator(c):
	sep = ""
	sep = c * 42
	print sep


def main(argv):
	# make sure you have all your args
	if len(argv) < 2:
		usage()
		sys.exit(2)

	# process todo.txt
	try:
		f = open (argv[0], "r")
		projects = {}
		contexts = {}
		projectPriority = []
		contextPriority = []
		for line in f:
			prioritized = False
			words = line.split()
			if words and words[0].startswith("("):
				prioritized = True
			for word in words:
				if word[0:2] == "p:" or word[0:2] == "p-" or word[0:1] == "+":
					if word not in projects:
						projects[word] = 1
					else:
						projects[word] = projects.setdefault(word,0)  + 1
					if prioritized:
						projectPriority.append(word)
				if word[0:1] == "@":
					if word not in contexts:
						contexts[word] = 1
					else:
						contexts[word] = contexts.setdefault(word, 0)  + 1
					if prioritized:
						contextPriority.append(word)
		f.close()
	except IOError:
		print "ERROR:  The file named %s could not be read."% (argv[0], )
		usage()
		sys.exit(2)

	# process done.txt
	try:
		completedTasks = {}
		f = open (argv[1], "r")
		for line in f:
			words = line.split()
			for word in words:
				if word[0:2] == "p:" or word[0:2] == "p-" or word[0:1] == "+":
					if word not in completedTasks:
						completedTasks[word] = 1
					else:
						completedTasks[word] = completedTasks.setdefault(word, 0) + 1
		f.close()
	except IOError:
		print "ERROR:  The file named %s could not be read."% (argv[1], )
		usage()
		sys.exit(2)

	# calculate percentages
	projectPercentages = {}
	for project in projects:
		openTasks = projects[project]
		if project in completedTasks:
			closedTasks = completedTasks[project]
		else:
			closedTasks = 0
		totalTasks = openTasks + closedTasks
		projectPercentages[project] = (closedTasks*100) / totalTasks

	# get projects all done
	projectsWithNoIncompletes = {}
	for task in completedTasks:
		if task not in projects:
			projectsWithNoIncompletes[task] = 0
	
	# print out useful info
	#print "TODO.TXT Bird's Eye View Report %s"% ( datetime.date.today().isoformat(), )
	print ""
	print "TODO.TXT Bird's Eye View Report"

	separator("=")

	printTaskGroups("Projects with Open TODO's", projects, projectPriority, projectPercentages)
	printTaskGroups("Contexts with Open TODO's", contexts, contextPriority, projectPercentages)
	printTaskGroups("Completed Projects (No open TODO's)", projectsWithNoIncompletes, projectPriority, projectPercentages)
	print ""
	print "* Projects and contexts with an asterisk next to them denote prioritized tasks."
	print "Project with prioritized tasks are listed first, then sorted by number of open todo's."
	print ""




if __name__ == "__main__":
    main(sys.argv[1:])
