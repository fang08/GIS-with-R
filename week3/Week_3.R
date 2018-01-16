#######################################################################################
### Lab 3: Basics of Programming, Objects, and Data Structures in R.

### http://www.r-tutor.com/r-introduction/vector
### http://www.r-tutor.com/r-introduction/data-frame
### http://www.datacarpentry.org/semester-biology/assignments/r-intro/
### http://www.datacarpentry.org/semester-biology/materials/Walkthrough-R/
### http://www.datacarpentry.org/R-ecology-lesson//02-starting-with-data.html
### http://swcarpentry.github.io/r-novice-inflammation/01-starting-with-data/
### http://www.datacarpentry.org/semester-biology/materials/data-structures-R/
### https://swcarpentry.github.io/r-novice-inflammation/11-supp-read-write-csv/
### http://www.datacarpentry.org/R-ecology-lesson/01-intro-to-R.html#creating_objects

##############################  FOLLOW ALONG WITH ME, SET YOUR PROJECT FOLDERS ####################################
### Last week we covered VECTORS AND DATA TYPES
### Remember that c means combine or concatenate
### In this example we created a vector named length_maturity 
### combining the Length at maturity of three species of cichlids 
length_maturity <- c(11.7, 4.6, 16.0)
length_maturity

### c is combine or concatenate
### You can also create a vector and fill it with characters. In this case,
### the common names of cichlids
common_names <- c("Mayan_Cichlid", "African_Jewelfish", "Blue_Tilapia")

### What if we got c-c-crazy and c-c-combined them? 
combo<-c(length_maturity, common_names)

### one of these data types will have to be coerced into the other type when 
### these two vectors are combined. 
### Raise your hands if you're #Team_Numeric
### Raise your hands if you're #Team_Character

### str is your friend. it tells us the internal structure of an R object 
### and the elements it holds
str(length_maturity)
### num
str(common_names)
### chr
str(combo)
#################################################################################################
### Vector Index, using the single square bracket "[]" operator

### Use "" for characters!
s <- c("aa", "bb", "cc", "dd", "ee") 
### In-Class example
### assign the third element to an object with a cool movie-sounding name
the_third_element <-s[3]
print(the_third_element)
the_third_element

### assign everything else to an object with an even cooler movie-sounding name
### Question 1, 2.5 POINTS
## Answer 1: return everything except for the third element: "aa" "bb" "dd" "ee"
s[-3]

### Question 2, 2.5 POINTS
### There are five elements in the string/object called 's'. 
### Using the single square bracket "[]" operator, what is the 6th value?
## Answer 2: run the code below, the result of s[6] is NA
s[6]

### Numeric Vector Index, slice a new vector from the given vector using the 
### member position of the original vector to be retrieved. 

### take out the second and third element 
s[c(2, 3)]
mid_vector<-s[c(2,3)]
mid_vector
### It handles duplicates just fine
s[c(2, 3, 3)]
### Even out of order
s[c(2, 1, 3)]
### Finally, the range index. This produces a vector slice 
### between two indexes using the colon ":" operator
s[2:4]
### Question 3, 5 POINTS
### Using your vector named s and a numeric vector index, return to me the string below:
### "ee" "dd" "cc" "bb" "aa"
## Answer 3: see the code below
s[c(5:1)]

#################################################################################################
### Scientific Commands
### Import data using the function read.csv, the principal means of reading tabular data into R

### Who has used read.csv? 
#
## Just like dataframes are the #workhorse of R, read.csv is the 
### #workhorse function to make these

### This is the basic line of code you run when reading a csv into R
# read.csv(file, header = TRUE, sep = ",")

### Question 4, 5 POINTS TOTAL
### 4a Define .csv
### 4b What is the default sep argument for a .csv format. Does it make sense? 
## Answer 4a: csv means comma-separated values, it's a simple file format stores tabular data. Each line 
## of csv file is a data record and each record contains multiple fields separated by commas.
## Answer 4b: the default sep argument for a .csv file is comma (because it called comma-separated)

### Question 5, 5 POINTS
### What does the header argument mean in read.csv? Run the line with header = FALSE and then 
### again with header= TRUE and describe the difference between the two
## Answer 5: the header argument is a logic value that indicates whether the .csv file contains the name
## of the variables at the first line. If the header = TRUE, it reads the first line of .csv file as
## variables' name for each column. If the header = FALSE, it creates each column's variable name as
## "V1","V2","V3" etc.

### If you recall, last week we looked at vectors of Cactus Plot Data from Ordway-Swisher
### Remember when you sent out your undergrad to collect the data below in the summer?
#length <- c(2.2, 2.1, 2.7, 3.0, 3.1, 2.5, 1.9, 1.1, 3.5, 2.9)
#width <- c(1.3, 2.2, 1.5, 4.5, 3.1, 2.8, 1.8, 0.5, 2.0, 2.7)
#height <- c(9.6, 7.6, 2.2, 1.5, 4.0, 3.0, 4.5, 2.3, 7.5, 3.2)
### It turns out you already had the data in a .csv file in your flashdrive

### For this lab, extract these values from the Lab 3 .csv using the "$" operator 
### Some of your answers will be the same ones from Lab 2, but you'll be writing more of your
### own lines of code to get there

### Start by reading in your csv
### If this line does not work, raise your hand in the next break so I can troubleshoot this with you
OSBS_Cactus_Plots<-read.csv(file = "osbs_plot.csv", header = TRUE )
### Check out what you imported with names(), head(), and str()
names(OSBS_Cactus_Plots)
head(OSBS_Cactus_Plots)
str(OSBS_Cactus_Plots)

### QUESTION 6 Tell me the length() of plot widths and heights (10 points TOTAL) 
### Using the following in-class example as a guide. $ is your friend!  
meaningful_name<-OSBS_Cactus_Plots$length
length(meaningful_name)
cactus_length<-OSBS_Cactus_Plots$length
length(cactus_length)

### Question 6a width
## Answer 6a: the length is 10
cactus_width<-OSBS_Cactus_Plots$width
length(cactus_width)
### Question 6b height
## Answer 6b: the length is 10
cactus_height<-OSBS_Cactus_Plots$height
length(cactus_height)

### Now do some basic math like last time!

### QUESTION 7, 5 POINTS
### Because each vector has the same length, we can do basic math across these plots.
### Calculate the volume of each plot
### HINT you should get a single vector of class numeric and length 10
## Answer 7:
cactus_volume<-(cactus_length*cactus_width*cactus_height)
cactus_volume

### QUESTION 8, 5 POINTS
### And collapse this vector of length 10 and class numeric into a single value, 
### the total volume of all the cactus plots
## Answer 8:
total_volume<-sum(cactus_volume)
total_volume

### QUESTION 9, 10 POINTS
### Using a numeric vector index, extract the volumes of the 
### fifth, sixth, seventh, eighth, first, second, third, tenth, and ninth plots. 
### and save it off as a new vector named new_vol
###HINT use the colon operator ":" and c for this. 
## Answer 9:
new_vol<-cactus_volume[c(5:8,1:3,10,9)]
new_vol

###############################################################################################
### Gainesville Precipitation Data from NOAA###
### Read in gainesville precipitation data provided to you in a .csv file from Canvas,
### assign it to an object with a meaningful dataframe name! 
### Pay special attention to the header argument, I have included this dataset in the 
### lab to trip you up!
### Always look through your data before manipulating it, look at the 
head()
tail()
str()
class()

### If you are having trouble reading in the csv, please tell me, 
### we'll call on someone to volunteer
Gainesville_precip<-read.csv(file = "gainesville-precip.csv", header = FALSE, sep = ",")
names(Gainesville_precip)  ## the variable names
head(Gainesville_precip)  ## the top part of the file
tail(Gainesville_precip)  ## the bottom part of the file
str(Gainesville_precip)  ## the list structure of the file
class(Gainesville_precip)  ## the class type of the file

### QUESTION 10, 5 points
### Each column is a month of the year. Find the number of columns in the dataframe using
ncol()
## Answer 10: the number of columns is 12 for 12 months
column_num<-ncol(Gainesville_precip)
column_num

### QUESTION 11, 5 points
### Each row is a year between 1961 and 2013. Find the number of rows in the dataframe using 
nrow()
## Answer 11: the number of row is 39 for 39 years
row_num<-nrow(Gainesville_precip)
row_num

### QUESTION 12, 10 points
### You want to plot monthly mean precipitation. 
### collapse the dataframe into a numeric dataframe [1:12] using the function colMeans. Assign
### it to an object with a meaninful name, for example: monthly_mean_precipitation
colMeans()
## Answer 12:
monthly_mean_precip<-colMeans(Gainesville_precip)
monthly_mean_precip

### QUESTION 13, 10 points
### You want to plot annual mean precipitation over the four decades you have data for it
### collapse the dataframe into a numeric dataframe [1:39] using the function rowMeans. Assign
## it to an object with a meaninful name, for example: annual_mean_precipitation
rowMeans()
## Answer 13:
annual_mean_precip<-rowMeans(Gainesville_precip)
annual_mean_precip
 
### Before you begin the next section, search for the plot function in help
### this is a basic introduction to plotting in R. Look at the arguments for 
### this generic function.

### For the next two problems, we will only be using 4 arguments in the following order:
# x is what you are plotting, in Question 14 it will be your dataframe of 
# monthly mean precipitation 
# in Question 15 it will be your dataframe of annual mean precipitation
# type='l'. What does 'l' mean? Tell me in the comments, you will use the same argument for BOTH
# Question 14 and 15. 

## Answer: "l" means the plot type is lines.
## "xlab" is the title for x-axis.
## "ylab" is the title for y-axis.
## Reference: https://stat.ethz.ch/R-manual/R-devel/library/graphics/html/plot.html

# Tell me what x and y lab stand for and what they do in your comments
# xlab= "Month" for Question 14 since we are plotting MONTHly mean precipitation
# xlab= "Year" for Question 15 since we are plotting ANNUAL mean precipitation
# ylab= "Mean Precipitation", same for both questions. 

### I have commented out x, fill it in with your dataframe of 
### monthly mean precipitation (values for colMeans)...
### QUESTION 14, 10 points PLOT MONTHLY MEAN PRECIPITATION
plot(monthly_mean_precip, type = "l", xlab = "Month", ylab = "Mean Precipitation")
### After this plot has run, mouse over to export, save as Image, 
### change the file name to something
### meaninful and save it in your .Rproj folder. 
###We will do this simply with a line of code next week,

  
### ... and monthly annual precipitation (rowMeans), respectively 
### QUESTION 15, 10 POINTS PLOT ANNUAL MEAN PRECIPITATION 
plot(annual_mean_precip, type="l", xlab = "Year", ylab = "Mean Precipitation")
### After this plot has run, mouse over to export, save as Image, 
### change the file name to something
### meaninful and save it in your .Rproj folder.
### We will do this simply with a line of code next week
### I just want you to have experience with the GUI
############################################################################################### 
