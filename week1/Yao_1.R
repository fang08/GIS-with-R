### Modified from http://adv-r.had.co.nz/Style.html, 
### http://www.datacarpentry.org/R-ecology-lesson/00-before-we-start.html, 
### and http://www.datacarpentry.org/R-ecology-lesson/01-intro-to-R.html

### Use # signs to comment. Anything to the right of a # is ignored by R, meaning it won't be 
### executed. Comments are a great way to describe what your code does within the code itself, 
### so comment liberally in your R scripts

### Assignment, big one for this class, please do not use = to assign stuff
### Use <-, not =, for assignment. It assigns values on the right to objects on the left. 
### So, after executing x <- 5, the value of x is 5. The arrow can be read as 5 goes into x.
### It is good practice to use always <- for assignments, except when specifying the values 
### of arguments in functions, when only = should be used.
# Good
x <- 5
# Bad
x = 5

### Creating objects
### You can get output from R simply by typing in math in the console. That's BORING though, 
### assigning values to objects (using <-) makes things much more interesting 
mass <- 47.5            # first time assigning mass
age  <- 122             # first time assigning age
mass <- mass * 2.0      # what? we're reassigning mass? what's the value of mass now, print it
mass
print(mass)             #this works too, longform
age  <- age - 20        # reassign age, different from age<- 122 when we started. 
mass_index <- mass/age  #Look at your values in the top right Global Environment

### Syntax
# Spacing
# Place spaces around all infix operators (=, +, -, <-, etc.). 
# The same rule applies when using = in function calls. Always put a space after a comma, and 
# never before (just like in regular English).
# Good
average <- mean(feet / 12 + inches, na.rm = TRUE)
# Bad
average<-mean(feet/12+inches,na.rm=TRUE)

### Notation and Naming
# File names
# File names should be meaningful and end in .R.

# Good
fit-models.R
utility-functions.R
# Bad
foo.r
stuff.r
myTAisaloser.r

### Object Names
# "There are only two hard things in Computer Science: cache invalidation and naming things."
# -Phil Karlton

# Variable and function names should be lowercase. Use an underscore (_) to separate words within
# a name. Generally, variable names should be nouns and function names should be verbs. Strive 
# for names that are concise and meaningful (this is not easy!). Make object names explicit
# but not too long. And remember, R is CaSe-SENsitIVe
# Good
day_one
day_1
# Bad
first_day_of_the_month
DayOne
dayone
djm1

# Where possible, avoid using names of existing functions and variables. This will cause 
# confusion for the readers of your code.

# Bad, as a rule of thumb, don't be naming FALSE the abbreviation for TRUE 
T <- FALSE
c <- 10
mean <- function(x) sum(x)

# just add some comments here
