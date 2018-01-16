### Lab 2: Basics of Programming, Objects, and Data Structures in R.
### http://www.datacarpentry.org/R-ecology-lesson/01-intro-to-R.html#creating_objects
### http://swcarpentry.github.io/r-novice-inflammation/01-starting-with-data/
### http://swcarpentry.github.io/r-novice-inflammation/11-supp-read-write-csv/
### http://www.datacarpentry.org/semester-biology/assignments/r-intro/

### VECTORS AND DATA TYPES
### c is combine or concatenate
### we are creating a vector named length_maturity combining the Length at maturity of cichlids 
length_maturity <- c(11.7, 4.6, 16.0)
length_maturity

### c is combine or concatenate
### we are creating a vector named animals combining the common names of cichlids
common_names <- c("Mayan_Cichlid", "African_Jewelfish", "Blue_Tilapia")
common_names
### The quotes around the common names are essential here. Without the quotes R will assume there 
### is a variable called Mayan_Cichlid, African_Jewelfish, Blue_Tilapia, etc.

### VECTOR INSPECTION
### length tells us how many elements are in a vector
length(length_maturity)
length(common_names)

### str tells us the internal structure of an R object (and the elements it holds)
str(length_maturity)
### num
str(common_names)
### chr

### your advisor has decided to give you more work. they want you to add some more Length at 
### Maturity values to your vector length_maturity. they say the order doesn't matter

### Add elements using c() like before, but now add it straight into the vector! 
### First add to the beginning
ex1<-c(length_maturity, 30)
length(ex1)
str(ex1)
### And end
ex2<-c(30, length_maturity)
length(ex2)
str(ex2)

#################################################################################################
### CHA-CHA-CHA-CHALLENGEEE
### For 4 points each: tell me a) the two (or more) classes in each vector and b) 
### which data type supercedes the other in controlling the class of the vector 

#1
## Answer 1: numeric and character. Character supercedes the other.
num_char <- c(1, 2, 3, 'a')
str(num_char)

#2
## Answer 2: numeric and logical. Numeric supercedes the other.
num_logical <- c(1, 2, 3, TRUE)
str(num_logical)

#3
## Answer 3: character and logical. Character supercedes the other.
char_logical <- c('a', 'b', 'c', TRUE)
str(char_logical)

#4
## Answer 4: numeric and character. Character supercedes the other.
tricky <- c(1, 2, 3, '4')
str(tricky)

### We will do number 5 in class
#5 undergrad technician got a little sloppy with species presence/absence data entry
## Answer 5: numeric, logical and character. Character supercedes the others.
threemusketeers<-c(1,TRUE, 'Present', 0)
str(threemusketeers)

### Basic Math ### for five points each
### These functions are built right into R, no need to reinvent the wheel!
length_maturity <- c(11.7, 4.6, 16.0)
### Using your vector of Length at Maturity from before, report back the following:
#6 mean
## Answer 6 is below:
meanML<-mean(length_maturity)
meanML

#7 sum
## Answer 7 is below:
sumML<-sum(length_maturity)
sumML

#8 max
## Answer 8 is below:
maxML<-max(length_maturity)
maxML

#9 We will do minimum in class
### assign to object with meaningful name
minimumML<-min(length_maturity)
### you can print this using the print function
print(minimumML)
### or just type in the name and ctrl+r
minimumML

### Built-In Functions ### 4 points each
### A built-in function is one that you don't need to install and load a package to use. 
### To learn how to use any function that you don't know how to use appropriately, 
### use the help() function. help() takes only one parameter, 
### the name of the function that you want information about (e.g., help(abs)).
### For full points on your comments (later in the semester, not this lab), 
### I expect you to look up every function and summarize the description and arguments.

### Familiarize yourself with the built-in functions abs(), round(), sqrt(), 
### tolower(), and toupper(). Use these built-in functions to print the following items:

### sqrt example in class (ungraded)
dozen<-sqrt(144)
dozen
#10 The absolute value of -15.5.
## Answer 10:
abso_val<-abs(-15.5)
abso_val

#11 4.483847 rounded to two decimal places. ###HINT: Look at the arguments for round()
## Answer 11:
round_val<-round(4.483847,digits = 2)
round_val

#12 3.8 rounded to the nearest integer.
## Answer 12:
round_val2<-round(3.8)
round_val2

#13 "cichlid" in all capital letters.
# Answer 13:
capletters<-toupper("cichlid")
capletters

#14 "CICHLID" in all lower case letters.
## Answer 14:
lowerletters<-tolower("CICHLID")
lowerletters

### Vectors of Cactus Plot Data from Ordway-Swisher, we'll be looking at 
### NEON hyperspectral data from here later in the semester 
### FORTY POINTS TOTAL
length_Cactus <- c(2.2, 2.1, 2.7, 3.0, 3.1, 2.5, 1.9, 1.1, 3.5, 2.9)
width_Cactus <- c(1.3, 2.2, 1.5, 4.5, 3.1, 2.8, 1.8, 0.5, 2.0, 2.7)
height_Cactus <- c(9.6, 7.6, 2.2, 1.5, 4.0, 3.0, 4.5, 2.3, 7.5, 3.2)

### 15 Tell me the length() of each vector (1 point each)
## Answer 15: after changing the names of vectors, the length of all three vectors are 10
length(length_Cactus)
length(width_Cactus)
length(height_Cactus)

### 16 Because each vector has the same length, we can do basic math across these plots.
### Calculate the volume of each plot (10 total)
### HINT you should get a single vector of class numeric and length 10
## Answer 16 is below:
volume_Cactus<-(length_Cactus*width_Cactus*height_Cactus)
volume_Cactus

### 17 On this Vector of Cactus Plot Volumes you found in #16, tell me:

### minimum volume (2.5 points)
### maximum volume (2.5 points)
## Answer 17 is below:
minimumVL<-min(volume_Cactus)
minimumVL
maximumVL<-max(volume_Cactus)
maximumVL

### 18 Calculate the total volume of all the cactus plots
### HINT look at the other built-in functions we've gone through for this question. (7 points)
## Answer 18 is below:
totalVL<-sum(volume_Cactus)
totalVL

### 19 Take the square root of # 18 (5 points)
## Answer 19:
squarerootVL<-sqrt(totalVL)
squarerootVL

### 20 And round the result to the nearest 2 decimal places (5 points)
## Answer 20:
roundVL<-round(squarerootVL,digits = 2)
roundVL

### 21 Now do this but without creating the intermediate variable. Perform both the square root 
### and the round on a single line by putting the sqrt() call inside the round() call (5 points)
### HINT Remember the order of operations (mind your parentheses), we'll be using a lot of them
### throughout the semester. 
## Answer 21:
round_in1step<-round(sqrt(totalVL),digits = 2)
round_in1step
