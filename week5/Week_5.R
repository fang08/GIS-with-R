#################################################################################################
# Week 5 Lab: Use the money you'd use to buy a 
# subscription to ArcGIS on a 75-gallon aquarium 
# instead because you can do a lot of the same stuff in R

# Follow along with me as we set up a new project ###############################################

# Sources
# my forthcoming autobiography
# http://www.statmethods.net/management/subset.html
# http://www.statmethods.net/management/operators.html
# http://swcarpentry.github.io/r-novice-inflammation/reference/
# https://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html
# http://swcarpentry.github.io/r-novice-inflammation/01-starting-with-data/
# https://swcarpentry.github.io/r-novice-inflammation/11-supp-read-write-csv/

#
# Up until now we've used mostly built-in functions in R, but that's only half the fun!
# Always keep the following chunk of code (installing and loading packages) 
# at the top of your script. Read the warning messages that come up. Some aren't even "fatal"
# warning messages, they just let you know about the packages (their arguments and dependencies)
# 

install.packages("sp")
install.packages("dismo")
install.packages("rgdal")
install.packages("dplyr")
install.packages("stringr")
#
library(sp)
library(dismo)
library(rgdal)
library(dplyr)
library(stringr)

# Lab 3 Review Read in a .CSV (5 points Total)################################################
# I want four arguments in your read.csv line of code:
# 1) Name of the file. Remember to include .csv at the end of the file name, all within ""
# 2) Look at the raw data file and see if there's a header. Use the correct header argument.
# 3) Include the sep argument
# 4) stringsAsFactors. This is perhaps the most important argument in read.csv(), 
# particularly if you are working with categorical data. This is because 
# the default behavior of R is to convert character strings into factors, 
# which may make it difficult to do such things as replace values.
# Successful reading in of "non-natives.csv" 

# Explore the data using the usual built-in functions
NAS_Data<-read.csv("cichlids.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE)
colnames(NAS_Data)
head(NAS_Data)
str(NAS_Data)
class(NAS_Data)

# Lab 4 Dplyr single table verbs ### 65 Points Total ##########################################
# ("Look back to your comments on dplyr, Luke" -Yoda) 
# Define the following verbs: arrange, distinct, filter, sample_n, select
# Use the introduction to dplyr link above to define the verbs

# Arrange- definition here
# Answer: Arrange(dplyr) function sorts rows by variables default by ascending order.
#         Use "desc" to sort a variable in descending order.

# Let's get crazy and re(Arrange) the dataframe so that 
# the first records are the newest

NAS_Data<-arrange(NAS_Data, desc(Year))
head(NAS_Data)

# Tell me the latest year of data using a built-in function (NAS_Data$Year)
# Answer: use head function, the latest year is 2016
head(NAS_Data$Year)

# Tell me the earliest year of data using a built-in function (NAS_Data$Year)
# Answer: use tail function, the latest year is 1870
tail(NAS_Data$Year)

# What does $ do in the previous examples
# Answer: the $ sign operator refers to the specific columns you want to use

# Distinct- definition here
# Answer: Distinct(dplyr) function selects only unique or distinct rows from an input table.

# Save common names as a vector of length 12 using a meaningful name

cn<-distinct(NAS_Data, common_name)
cn$common_name

commons<-NAS_Data$common_name  # these two lines didn't work well because distinct only works with data
distinct(commons)

table(NAS_Data$common_name)  # another method

# Filter- definition here. More on this verb later
# Answer: Filter(dplyr) function returns rows with matching conditions.

# Rename- definition here.
# Answer: Rename(dplyr) function rename the variables by name, it keeps all variables.

# BACK-QUOTES, TOP LEFT OF YOUR KEYBOARD 
# https://csgillespie.github.io/efficientR/10-efficient-learning.html#fn16
NAS_Data<-rename(NAS_Data, 
       Species = `common_name`,
       Latitude = `GISLatDD`,
       Longitude = `GISLongDD`)

colnames(NAS_Data) # prints out new column names

# Select- definition here
# Answer: Select(dplyr) function select variables by name, it keeps only the variables you mention.

NAS_Data<-select_(NAS_Data, "Species", "Latitude", "Longitude")
NAS_Data
colnames(NAS_Data)

# Let's get SPATIAL 
# Now make this csv a spatial point dataframe for use in 
# species distribution modeling (SDM work) later in the semester
# (Five Points Total)
coordinates(NAS_Data)<-c("Longitude", "Latitude")
# Break down each part of the code above. Tell me what the function is, what package its from
# Tell me why there's a c, etc
# Answer: Coordinates(sp) function sets spatial coordinates to create a spatial object (or retrieve spatial coordinates).
#         inside " " are the column names, c means "copy" used to specify the columns.

# Note from my previous experience using coordinates:
# Setting coordinates cannot be done on Spatial Objects 
# where they have already been set, so if you get order wrong
# Rerun read.csv and flip the order of the coordinates line

# Plotting (20 Points Total)###############################################################
# Plots are a good [first] step in checking your work to see if you've made a mistake
# I showed you the "point and click" way of saving off plots. We can #codethatout right here
# in the script as so

# Break the following chunk of code apart, tell me what each argument does (10 points).
# Using spplot, make a map of point records for all species. 
# Answer: spplot is used to plot object spatially, NAS_Data is the data you want to plot and Species is the colomn
#         your plot based on (it will also show on your legend).
#         dev.print will copy your plot to your project folder with file type and name you assigned.
spplot(NAS_Data, "Species")
dev.print(pdf, 'allofthem.pdf')

# 10 Points Again
# Reach under your chair for the species you'll be working on for this lab!
# You get a non-native, you get a non-native, you get a non-native!
# Just kidding pick whichever one you like. 
# Don't all pick the same one, I want different species! 
# Sort it out in the week_5 discussion board post ASAP.
# I want 12 distinct (get it) fish chosen with only 3 repeats allowed

new_NAS_Data<-as.data.frame(NAS_Data)
Mayan_Cichlid<-filter(new_NAS_Data, Species == "Mayan Cichlid")
coordinates(Mayan_Cichlid)<-c("Longitude", "Latitude")
spplot(Mayan_Cichlid, "Species")
dev.print(pdf, 'Mayan_Cichlid_plot.pdf')

### CSV (10 Points Total)####################################################################
# Using write.csv, save a csv of all of the species of non-native fish (5 points)
# Using write.csv, save a csv of species of non-native fish of your choosing(5 points)
write.csv(NAS_Data,"All_species.csv",row.names = FALSE)
write.csv(Mayan_Cichlid,"Mayan_Cichlid.csv",row.names = FALSE)

# write.csv has a minimum of two arguments. the dataframe to be saved off
# and the file name, ending with .csv, within quotes. The basic skeleton is:
# write.csv(name_of_df_you_just_spent_your_heart_and_soul_on, "ihatethisclass.csv")
# Nothing is this simple however, 
# so we have a new argument to add after "ihatethisclass.csv". 
# Include row.names=FALSE. Execute the write.csv line of code successfully for (5 points). 
# Explain to me what the row.names argument does, and how it would be different if it 
# were set to TRUE (5 points)
# Answer: row.names is a logical value indicates whether the row names written along with all the records.
#         if it's TRUE, there will be an extra column ahead of all columns basically just keep the number of records you have.

# You have just learned the "other" kind of vector,
# brought in points from a csv into R, 
# "selected by attribute" as you would in ArcGIS, 
# made some basic plots as diagnostic tools, 
# saved those off within the script itself,
# and are well on your way to do point pattern analyses later 
# in the semester. But next week, to avoid a revolt on my hands, 
# we'll explore RASTER data
################################################################################################