#################################################################################################
# Week 4 Lab: The Review Lab, Super Short, go home play with your dog edition
# Week 3 Review, 4 BEAUTIFUL Solutions, R is Fun! 
# If you're live-tweeting my lectures use #neRd
#
s[c(5:8, 1:3, 10:9)]
#
plotvol_subset<-plot_vol[c(5,6,7,8,1,2,3,10,9)]
plotvol_subset
#
new_vol <- c(volume[5:8],volume[1:3],volume[10:9])
#
vol1<-volume[5:8] 
vol2<-volume[1:3]
vol3<-volume[10:9]
new_vol<-c(vol1,vol2,vol3)

# Before you start follow along as I create a new project and set up our folder to start the lab
# Comment out the most important steps here (5 POINTS)
# Answer:
# Step 1: Click File - New Directory - Empty Project - set directory and its location
# - click create project (Ignore updates)
# Step 2: copy week_4.R file and paste it to the folder you have created
# Step 3: Edit week_4.R and zip it when finish editing

# Sources
# http://www.statmethods.net/management/subset.html
# http://www.statmethods.net/management/operators.html
# http://www.statmethods.net/management/typeconversion.html
# http://swcarpentry.github.io/r-novice-inflammation/reference/
# http://swcarpentry.github.io/r-novice-inflammation/01-starting-with-data/
# https://swcarpentry.github.io/r-novice-inflammation/11-supp-read-write-csv/
#
# Up until now we've used built-in functions in R, but that's only half the fun!
# Always keep the following chunk of code (installing and loading packages) 
# at the top of your script

install.packages("sp")
install.packages("rgdal")
install.packages("dplyr")
install.packages("stringr")
#
library(sp)
library(rgdal)
library(dplyr)
library(stringr)

# Once you have installed and loaded the packages, comment out a 
# paragraph on the package "dplyr". Summarize the description and details sections, 
# but most importantly, browse the vignette and comment on anything 
# interesting you found there. (5 POINTS)
# Answer: when installing dplyr, it also installing the dependencies ¡®R6¡¯, ¡®DBI¡¯, ¡®BH¡¯
# R will automatically trying URL to install packages
# After installation, the console will show package ¡®R6¡¯/ ¡®DBI¡¯/ ¡®BH¡¯/ ¡®dplyr¡¯ successfully unpacked and MD5 sums checked
# The downloaded binary packages are in C:\...\Temp\RtmpkXhjUV\downloaded_packages
# You could also check installed packages in 'Packages' panel near Files and Plots

#Lab 1 Review
#
weight<-55
weight<-2000
weight
# Tell me what happens to object "weight" after running the last three lines.
# Why did your TA add this to your lab?!? (2.5 POINTS)
# Answer: weight was first assigned with value, then replaced by new value 2000
#         finally it printed out 2000.

# Something we missed in Lab 1, when assigning names to objects, do not 
# start off with numbers, always letters
# 2x<-42
x2<-42

#
mass<-47.5
mass

age<- 122
age

age+mass
# Pay atttention to the following line of code. 
mass<- mass*2
mass
# What does mass equal now? What happened to mass being equal to 47.5? Why is it important
# to assign new and meaninful names to objects? (2.5 POINTS)
# Answer: mass now equals to 95 because we multipled previous value 47.5 by 2 and re-assigned it
#         to mass, so mass value changed to 95. We should avoid this situation happens and
#         assign new meaningful names to prevent messing up with variables.


# Lab 2 Creating vectors using concatenate/combine c()
# Make a vector of weights in kilograms of some really large butterfly: 
weight_kg<-c(2,5,8,1)
# Using any built-in function, tell me the class of weight_kg (2.5 Points)
# Answer: use code below, the class of weight_kg is numeric
str(weight_kg)

# You can put anything in a vector so long as it's all the same data type
animals<- c("mouse","cat", "dog")
counts<-c(15, 13, "21")
# Using any built-in function, tell me the class of counts (2.5 Points)
# Tell me what two data types were in counts (2.5 Points)
# Answer: the class of counts is character, it includes numeric and character data types
str(counts)

# Coercion!
as.numeric(counts)
# What did the last line of code do to counts? (2.5 Points)
# Answer: it force counts to belong to class numeric, so it prints out 15 13 and 21.

# Reassign counts to counts (I know I told you not to earlier in the lab) and 
# tell me the class of the object using any built-in function (2.5 Points)
# Answer: use the codes below, now the class is numeric
counts <- as.numeric(counts)
str(counts)

# Extending a vector
# Add a new animal to vector "animals" following the next set of instructions:
# Using c, add new species "capybara" to the vector animals. Assign this to an object called
# new_animals (2.5 points)
# Answer: see the code below
new_animals <- c(animals, "capybara")
new_animals

# Logical Review
TRUE
FALSE
truths<-c(TRUE, FALSE, TRUE, TRUE)

# When coercing truths into class numeric, what values to True and False take on, respectively? 
# (5 Points)
# Answer: coercing TRUE and FALSE, the numeric value of TRUE is 1 and value of FALSE is 0
as.numeric(TRUE)
as.numeric(FALSE)

# Logical Operator- the building blocks of how we get programs to make choices on what to do 
# Some New Operators to learn. Using one of the links provided to you in the "Sources" 
# section of the script, define the following (15 Points Total)
# ==, !=, <, >, <=, >=
# Answer: they are all logical operators
#         ==    exactly equal to
#         !=    not equal to
#         <     less than
#         >     greater than
#         <=    less than or equal to
#         >=    greater than or equal to

# Run the following lines of code as practice 
# Is 10 greater than 5?
# Answer: TRUE
10 > 5
# Remember that R is case-sensitive
# Answer: FALSE
"aang" == "Aang"
# Is 3 not the same as 3?
# Answer: FALSE
3 != 3

# What the previous lines of code return is either true or false. 
# We can do this for numbers and for characters. 

# Create six variables for the next set of lab questions

w <- 10.2
x <- 1.3
y <- 2.8
z <- 17.5
dna1 <- "attattaggaccaca"
dna2 <- "attattaggaacaca"

# Using the logical operators you have learned, tell me if the following statements are 
# TRUE or FALSE (5 POINTS EACH)

# w is greater than 10 
# the sum of w and x is less than 15
# x is greater than y
# dna1 is the same as dna2
# dna1 is not the same as dna2

# Answers: see below
w > 10   # TRUE, 10.2 > 10
w + x < 15   # TRUE, w+x=11.5, which is <15
x > y  # FALSE, 1.3 < 2.8
dna1 == dna2  # FALSE, they have one character difference
dna1 != dna2  # TRUE

# FLOFLOFLOATING POINTS INTERMISSION
# A note on floating points. COmputers don't store numbers like we would. In order to save space
# they save them as floating points. Most of the time you're fine, but sometimes you can run 
# into some problems. Remove the # and run the next three lines of code/psuedocode:
num<-1/3
num
print(num,digits = 22)
num

# 2 times x plus 0.2 is equal to y (pseudocode, need to "code out" (Andreoli 2017) yourself)
2*x + 0.2 == y
# Using the logical operators you have learned, was the above statement True or False (5 points)
#Answer: the above statement is FALSE

# Using the logical operators you have learned, are the statements below True or False? (5 Points)
# Answer: the below statement is TRUE
round(x * 2 + 0.2, 1) == y

# summarize the built-in function round (2.5 Points)
# Answer: function round is used to get the number of digits we want for floating numbers.
#         it could be round up (ceiling) or down (floor) or truncation.

# all.equal(x * 2 + 0.2, y) (5 Points)
# Answer: the below statement is TRUE
all.equal(x * 2 + 0.2, y)
# summarize the built-in function all.equal (2.5 Points)
# Answer: all.equal is used to test whether the two objects are nearly equal to each other

################################################################################################