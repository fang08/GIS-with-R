### Lab 10 Processing Multiple Files, Basic Intro to Loops and Functions, F-I-NDVI-A-L-E

### Processing Multiple Files
### Explanation from 
### https://eharstad.github.io/r-novice-inflammation/03-loops-R.html
### We now have almost everything we need to process all our data files. 
### The only thing that's missing is a function that finds files whose names match a pattern. 
### We do not need to write it ourselves because R already has a function 
### to do this called list.files.
### If we run the function without any arguments, 
### list.files(), it returns every file in the current working directory.
list.files()
### We can understand this result by reading the help file (?list.files). 
### The first argument, path, is the path to the directory to be searched, 
### and it has the default value of "." ("." is shorthand for the current working directory). 
### The second argument, pattern, is the pattern being searched, 
### and it has the default value of NULL. 
### Since no pattern is specified to filter the files, all files are returned.

### Explanation from:
### http://www.datacarpentry.org/semester-biology/materials/for-loops-R/
### Using the pattern argument makes file structure clear and avoids errors
### full.names = TRUE retains directory information
### Now we can loop over the files to work with them

### You'll be graded on all Challenge Questions and the plots/comments/code required to answer them
### No need to export intermediate steps or every single plot like last time. 
### Comment, comment, comment! 

install.packages("raster")
install.packages("rgdal")
install.packages("rasterVis")
install.packages("ggplot2")
install.packages("sp")
install.packages("dismo")
install.packages("dplyr")
install.packages("stringr")
install.packages("ecoretriever")
install.packages("scales")

# load all libraries
library(sp)
library(rgdal)
library(ggplot2)
library(raster)
library(rasterVis)
library(dismo)
library(dplyr)
library(stringr)
library(ecoretriever)
library(scales)

# 25%
# http://neondataskills.org/R/Raster-Times-Series-Data-In-R/
########################### Raster 05: Raster Time Series Data in R ###################################
# Create list of NDVI file paths using the "list.files()" function.
# It produces a character vector of the names of files or directories.
# assign path to object = cleaner code
NDVI_HARV_path <- "NEON-DS-Landsat-NDVI/HARV/2011/NDVI" 
all_NDVI_HARV <- list.files(NDVI_HARV_path,
                            full.names = TRUE,
                            pattern = ".tif$")
# NDVI_HARV_path is a string of whole path of all the files.
# If we specify full.names=TRUE, the full path for each file will be added to the list.
# Using the syntax pattern=".tif$" to add files to our list with a .tif extension.

# view list - note the full path, relative to our working directory, is included
all_NDVI_HARV
# The result is we have a list of all GeoTIFF files in the NDVI directory for Harvard Forest.

# Create a raster stack (a RasterStack object) of the NDVI time series using "stack()" function.
# It stacks vectors concatenates multiple vectors into a single vector along with a factor
# indicating where each observation originated.
NDVI_HARV_stack <- stack(all_NDVI_HARV)

# view crs of rasters (coordinate reference system)
crs(NDVI_HARV_stack)

# view extent of rasters in stack
extent(NDVI_HARV_stack)

# view the y resolution of our rasters
yres(NDVI_HARV_stack)  # 30

# view the x resolution of our rasters
xres(NDVI_HARV_stack)  # 30

## Challenge: Raster Metadata
## Answer the following questions about our RasterStack.
## 1. What is the CRS?
# Answer: UTM zone 19 and WGS 84.
## 2. What is the x and y resolution of the data?
# Answer: The resolution of x and y is both 30m, which means 30x30 meters.
## 3. What units is the above resolution in?
# Answer: The units is in meters.

# view a plot of all of the rasters
plot(NDVI_HARV_stack, 
     zlim = c(1500, 10000), 
     nc = 4)
# 'zlim' denotes the minimum and maximum values for which colors should be plotted.
# 'nc' specifies number of columns (we will have 13 plots in total).

# apply scale factor to data in order to keep values of NDVI range from 0-1.(now it's 0 - 10,000)
NDVI_HARV_stack <- NDVI_HARV_stack/10000
# plot stack with scale factor applied
# apply scale factor to limits to ensure uniform plotting
plot(NDVI_HARV_stack,
     zlim = c(.15, 1),  
     nc = 4)

# before plotting histograms
par("mar")  # default is c(5, 4, 4, 2) + 0.1.
par(mar=c(1,1,1,1))
# Using these function because of the error "in plot.new() : figure margins too large", which is because
# my RStudio plot panel is too small for the margins of the plot.
# "par" can be used to set or query graphical parameters. "mar" is a numerical vector which gives the number
# of lines of margin to be specified on the four sides of the plot. So we reduce the margin values.

# create histograms of each raster
hist(NDVI_HARV_stack, 
     xlim = c(0, 1))
# "hist" function computes a histogram of the given data values and plots (default).
# 'xlim' is the range of x value with sensible defaults when plotting.

## Challenge: Examine RGB Raster Files
## 1. View the imagery located in the /NEON-DS-Landsat-NDVI/HARV/2011 directory.
## 2. Plot the RGB images for the Julian days 277 and 293 then plot and compare those images to jdays 133 and 197.
## 3. Does the RGB imagery from these two days explain the low NDVI values observed on these days?
# Answer:

# plot 4 images in a tiled set, first create a 2x2 tiled layout using "par()" function.
# 'mfrow' is a vector of the form c(nr,nc). It draws an nr*nc array on the device by rows.
# reset layout
par(mfrow=c(2,2))

# open up file for Julian day 277 
RGB_277 <- 
  stack("NEON-DS-Landsat-NDVI/HARV/2011/RGB/277_HARV_landRGB.tif")

plotRGB(RGB_277)

# open up file for Julian day 293
RGB_293 <- 
  stack("NEON-DS-Landsat-NDVI/HARV/2011/RGB/293_HARV_landRGB.tif")

plotRGB(RGB_293)

# view a few other images
# open up file for Julian day 133
RGB_133 <- 
  stack("NEON-DS-Landsat-NDVI/HARV/2011/RGB/133_HARV_landRGB.tif")

plotRGB(RGB_133, 
        stretch="lin")
# "plotRGB" function makes a Red-Green-Blue plot based on three layers (in a RasterBrick or RasterStack).
# Three layers or bands are combined to represent the red, green and blue channel.
# 'stretch' argument is used to stretch the values to increase the contrast of the image: "lin" or "hist".
# "lin" means linear stretching and "hist" means histogram stretching.

# open up file for Julian day 197
RGB_197 <- 
  stack("NEON-DS-Landsat-NDVI/HARV/2011/RGB/197_HARV_landRGB.tif")

plotRGB(RGB_197, 
        stretch="lin")

# save the plots
dev.copy(png, "image_comparison.png")
dev.off()

# reset layout to default
par(mfrow=c(1,1))

# From the plots of Julian days 277 and 293 (abnormal) and Julian days 133 and 197 (normal), we could see
# that most of the image in days 277 and 293 are filled with clouds (can hardly see the land). So the
# very low NDVI values (outlier) resulted from cloud cover.

########################### This is the end of Raster 05 ###################################


# 25%
# http://neondataskills.org/R/Plot-Raster-Times-Series-Data-In-R/
############# Raster 06: Plot Raster Time Series Data in R Using RasterVis and Levelplot ##################
# We already created the RasterStack and applied scale factor to NDVI values in previous exercise

# plot and check the rasters (recall the memory)
plot(NDVI_HARV_stack, 
     zlim = c(.15, 1), 
     nc = 4)

# create a `levelplot` plot
levelplot(NDVI_HARV_stack,
          main="Landsat NDVI\nNEON Harvard Forest")
# levelplot in rasterVis package has similar function with plot, but can make our plot prettier.
# Each panel of the graphic shows a layer of the RasterStack object using a trellis chart or small-multiple technique.
# 'main' is the title of our plot.(\n forces a new line)

# use colorbrewer which loads with the rasterVis package to generate
# a color ramp of yellow to green
cols <- colorRampPalette(brewer.pal(9,"YlGn"))
# "colorRampPalette" function returns functions that interpolate a set of given colors to create new color palettes.
# "brewer.pal" provides color schemes/palettes for maps (and other graphics) designed by Cynthia Brewer.
# 9 is the number of different colors included in the palett. "YlGn" is one of the sequential palettes names.
# see http://www.datavis.ca/sasmac/brewerpal.html

# create a level plot - plot
levelplot(NDVI_HARV_stack,
          main="Landsat NDVI -- Improved Colors \nNEON Harvard Forest Field Site",
          col.regions=cols)  # col.region is a color vector contains explicit colors for different breaks

# view names for each raster layer
names(NDVI_HARV_stack)  # current name example: "X005_HARV_ndvi_crop"

# use gsub to modify label names.that we'll use for the plot 
rasterNames  <- gsub("X","Day ", names(NDVI_HARV_stack))
# "gsub()" function replaces all matches of a string, returns a string vector of the same length and with the same attributes.
# "X" is the string to be matched; "Day " is the string for replacement; names(...) is string or string vector.

# view Names
rasterNames  # now the names look like: "Day 005_HARV_ndvi_crop"

# Remove HARV_NDVI_crop from the second part of the string 
rasterNames  <- gsub("_HARV_ndvi_crop","",rasterNames)
# We could also use gsub("X|_HARV_NDVI_crop"," | ","rasterNames") to merge replacement in one step.
# "|" vertical bar character can be used to replace more than one element.

# view names for each raster layer
rasterNames  # now it looks like: "Day 005"

# use level plot to create a nice plot with one legend and a 4x4 layout.
levelplot(NDVI_HARV_stack,
          layout=c(4, 4), # create a 4x4 layout for the data
          col.regions=cols, # add a color ramp we have created
          main="Landsat NDVI - Julian Days \nHarvard Forest 2011",
          names.attr=rasterNames) # names attributes assigns the names to use for each panel

# use level plot to create a nice plot with one legend and a 5x3 layout.
levelplot(NDVI_HARV_stack,
          layout=c(5, 3), # create a 5x3 layout for the data
          col.regions=cols, # add a color ramp
          main="Landsat NDVI - Julian Days \nHarvard Forest 2011",
          names.attr=rasterNames)

# use level plot to create a nice plot with one legend and a 5x3 layout.
levelplot(NDVI_HARV_stack,
          layout=c(5, 3), # create a 5x3 layout for the data
          col.regions=cols, # add a color ramp
          main="Landsat NDVI - Julian Days \nHarvard Forest 2011",
          names.attr=rasterNames,
          scales=list(draw=FALSE )) # remove axes labels & ticks
# "scales = list" is used to create a list determining how the x- and y-axes (tick marks and labels) are drawn.
# If "draw = FALSE" means draw nothing at all.

## Challenge: Divergent Color Ramps
## 1. Create a plot and label each tile ¡°Julian Day¡± with the julian day value following.
## 2. Change the colorramp to a divergent brown to green color ramp to represent the data. 
## (Hint: Use the brewerpal page to help choose a color ramp.)

## Questions: Does having a divergent color ramp represent the data better than a sequential color ramp (like ¡°YlGn¡±)?
## Can you think of other data sets where a divergent color ramp may be best?

# Answer:
# change Day to Julian Day 
rasterNames2  <- gsub("Day","Julian Day ", rasterNames)

# use level plot to create a nice plot with one legend and a 5x3 layout.
levelplot(NDVI_HARV_stack,
          layout=c(5, 3), # create a 5x3 layout for the data
          col.regions=colorRampPalette(brewer.pal(9,"BrBG")), # specify color 
          main="Landsat NDVI - Julian Days - 2011 \nNEON Harvard Forest Field Site",
          names.attr=rasterNames2)

# save the plots
dev.copy(png, "Divergent_Color_Ramps.png")
dev.off()

# The sequential is better than the divergent as it shows better the process
# of greening up, which starts off at one end and just keeps increasing.
# The divergent color ramp is not suitable for data with continuous changes, but is good for
# examples such as disease mapping. It could display data that diverge from a specific
# threshold value and contrast to different situations.

########################### This is the end of Raster 06 ###################################


# 25%
# http://neondataskills.org/R/Extract-NDVI-From-Rasters-In-R/
################ Raster 07: Extract NDVI Summary Values from a Raster Time Series ##################
# calculate mean NDVI for each raster
# The "cellStats" function computes statistics for the cells of each layer of a Raster object and produces a numeric array of values.
# Functions such as max, min, and mean can be applied.
avg_NDVI_HARV <- cellStats(NDVI_HARV_stack,mean)

# convert output array to data.frame
# "as.data.frame" function coerce object to a data frame.
avg_NDVI_HARV <- as.data.frame(avg_NDVI_HARV)

# To be more efficient we could do the above two steps with one line of code
# avg_NDVI_HARV <- as.data.frame(cellStats(NDVI_stack_HARV,mean))

# view data
avg_NDVI_HARV

# view only the value in row 1, column 1 of the data frame
# Inside [] marks the row and column.
avg_NDVI_HARV[1,1]

# view column name slot
names(avg_NDVI_HARV)  # "avg_NDVI_HARV"

# rename the NDVI column
names(avg_NDVI_HARV) <- "meanNDVI"

# view cleaned column names
names(avg_NDVI_HARV)  # now "meanNDVI"

# add a "site" column to our data
avg_NDVI_HARV$site <- "HARV"

# add a "year" column to our data
avg_NDVI_HARV$year <- "2011"

# view data
head(avg_NDVI_HARV)  # now we have "meanNDVI", "site" and "year" columns

# note the use of the vertical bar character ( | ) is equivalent to "or". This
# allows us to search for more than one pattern in our text strings.
julianDays <- gsub(pattern = "X|_HARV_ndvi_crop", # the pattern to find 
                   x = row.names(avg_NDVI_HARV), # the object containing the strings
                   replacement = "") # what to replace each instance of the pattern with

# alternately you can include the above code on one single line
# julianDays <- gsub("X|_HARV_NDVI_crop", "", row.names(avg_NDVI_HARV))

# make sure output looks ok
head(julianDays)  # "005" "037" "085" "133" "181" "197"

# add "julianDay" values as a column in the data frame
avg_NDVI_HARV$julianDay <- julianDays

# what class is the new column
class(avg_NDVI_HARV$julianDay)  # character

# set the origin for the julian date (1 Jan 2011)
# "as.Date" function converts between character representations and objects of class "Date" representing calendar dates.
# "2011-01-01" is a character string specified the format of Date class.
origin <- as.Date("2011-01-01")

# convert "julianDay" from class character to integer using "as.integer" function
avg_NDVI_HARV$julianDay <- as.integer(avg_NDVI_HARV$julianDay)

# create a "date" column; -1 added because origin is the 1st. 
# If not -1, 01/01/2011 + 5 = 01/06/2011 which is Julian day 6, not 5.
avg_NDVI_HARV$Date<- origin + (avg_NDVI_HARV$julianDay-1)

# did it work? 
head(avg_NDVI_HARV$Date)  # "2011-01-05" "2011-02-06" "2011-03-26"...

# What are the classes of the two columns now? 
class(avg_NDVI_HARV$Date)    # Date
class(avg_NDVI_HARV$julianDay)    # integer

head(avg_NDVI_HARV)  # now it has meanNDVI, site, year, julianDay, Date columns

## Challenge: NDVI for the San Joaquin Experimental Range
## Compare NDVI values for the NEON Harvard Forest and San Joaquin Experimental Range field sites.
# Answer:
# Create list of NDVI file paths
all_NDVI_SJER <- list.files("NEON-DS-Landsat-NDVI/SJER/2011/NDVI",
                            full.names = TRUE,
                            pattern = ".tif$")

# Create a time series raster stack
NDVI_stack_SJER <- stack(all_NDVI_SJER)

# Calculate Mean, Scale Data, convert to data.frame all in 1 line!
avg_NDVI_SJER <- as.data.frame(cellStats(NDVI_stack_SJER,mean)/10000)

# rename NDVI column
names(avg_NDVI_SJER) <- "meanNDVI"

# add a site column to our data
avg_NDVI_SJER$site <- "SJER"

# add a "year" column to our data
avg_NDVI_SJER$year <- "2011"

# Create Julian Day Column 
julianDays_SJER <- gsub(pattern = "X|_SJER_ndvi_crop", # the pattern to find 
                        x = row.names(avg_NDVI_SJER), # the object containing the strings
                        replacement = "") # what to replace each instance of the pattern with

## Create Date column based on julian day & make julianDay an integer
# set the origin for the julian date (1 Jan 2011)
origin<-as.Date ("2011-01-01")

#add julianDay values as a column in the data frame
avg_NDVI_SJER$julianDay <- as.integer(julianDays_SJER)

# create a date column, 1 once since the origin IS day 1.  
avg_NDVI_SJER$Date<- origin + (avg_NDVI_SJER$julianDay-1)

# did it work? 
avg_NDVI_SJER  # now it has meanNDVI, site, year, julianDay, Date columns


# plot NDVI
ggplot(avg_NDVI_HARV, aes(julianDay, meanNDVI), na.rm=TRUE) +
  geom_point(size=4,colour = "PeachPuff4") + 
  ggtitle("Landsat Derived NDVI - 2011\n NEON Harvard Forest Field Site") +
  xlab("Julian Days") + ylab("Mean NDVI") +
  theme(text = element_text(size=20))

# Use the "ggplot()" function within the ggplot2 package to plot images.
# "avg_NDVI_HARV" is the data to plot. "aes" constructs aesthetic mappings, it describes how variables in the data 
# are mapped to visual properties (aesthetics) of geoms. "julianDay" and "meanNDVI" are x and y variables to map.
# 'na.rm' argument if FALSE, missing values are removed with a warning. If TRUE, missing values are silently removed.
# "+" is used to add multiple layers/contents of plot. "geom_point" is used to create scatterplots.
# 'size' argument is the size of plotting points. 'colour' shows the color.
# "ggtitle" gives the title of the plot. "xlab" is the name of x axis and "ylab" is the name of y axis.
# Use theme() to modify individual components of a theme, allowing you to control the appearance of all non-data components.
# 'text' means all text elements, 'element_text()' means theme text and changes the size of text to 20.


## Challenge: Plot San Joaquin Experimental Range Data
## Create a complementary plot for the SJER data. Plot the data points in a different color.
# Answer:
# plot NDVI of SJER
ggplot(avg_NDVI_SJER, aes(julianDay, meanNDVI)) +
  geom_point(size=4,colour = "SpringGreen4") + 
  ggtitle("Landsat Derived NDVI - 2011\n NEON SJER Field Site") +
  xlab("Julian Day") + ylab("Mean NDVI") +
  theme(text = element_text(size=20))
# save the plot
dev.copy(png, "SJER_NDVI.png")
dev.off()


# Merge" Data Frames
# "rbind" function takes a sequence of vector, matrix or data-frame arguments and combine by rows. 
NDVI_HARV_SJER <- rbind(avg_NDVI_HARV,avg_NDVI_SJER)
NDVI_HARV_SJER

# plot NDVI values for both sites
ggplot(NDVI_HARV_SJER, aes(julianDay, meanNDVI, colour=site)) +
  geom_point(size=4,aes(group=site)) + 
  geom_line(aes(group=site)) +
  ggtitle("Landsat Derived NDVI - 2011\n Harvard Forest vs San Joaquin \n NEON Field Sites") +
  xlab("Julian Day") + ylab("Mean NDVI") +
  scale_colour_manual(values=c("PeachPuff4", "SpringGreen4"))+   # scale_colour : match previous plots
  theme(text = element_text(size=20))

# In "aes", 'colour=site' and 'group=site' means divide plot color and group by "site" column (has HARV and SJER
# two different values). "geom_line" is used to create lines (connect the scatterpoints).
# "scale_manual" creates your own discrete scale, and "scale_colour_manual" controls the colors.
# values=c(...) gives the discrete colors for two types of site.

## Challenge: Plot NDVI with Date
## Plot the SJER and HARV data in one plot but use date, rather than Julian day, on the x-axis.
# Answer:
ggplot(NDVI_HARV_SJER, aes(Date, meanNDVI, colour=site)) +
  geom_point(size=4,aes(group=site)) + 
  geom_line(aes(group=site)) +
  ggtitle("Landsat Derived NDVI - 2011\n Harvard Forest vs San Joaquin \n NEON Field Sites") +
  xlab("Date") + ylab("Mean NDVI") +
  scale_colour_manual(values=c("PeachPuff4", "SpringGreen4"))+  # match previous plots
  theme(text = element_text(size=20))
# just change "julianDay" to "Date".
dev.copy(png, "HARV_SJER_meanNDVI_Date.png")
dev.off()


# open up RGB imagery
rgb.allCropped <-  list.files("NEON-DS-Landsat-NDVI/HARV/2011/RGB/", 
                              full.names=TRUE, 
                              pattern = ".tif$")
# create a layout
par(mfrow=c(4,4))

# super efficient code
for (aFile in rgb.allCropped){
  NDVI.rastStack <- stack(aFile)
  plotRGB(NDVI.rastStack, stretch="lin")
}

# Using for-loop to batch process/iterate multiple data. Inside the parentheses aFile in rgb.allCropped controls
# the number of iteration times, which means for each file in the list, gives it a name 'aFile' in this iteration.
# Next, the statement uses "stack" function to create a RasterStack object named NDVI.rasterStack.
# Then use "plotRGB" makes a Red-Green-Blue plot based on three layers in a RasterStack. Use linear stetch method.
# The for-loop runs 13 times because there are 13 files in rgb.allCropped list.

# reset layout
par(mfrow=c(1,1))

# Notice that the data points with very low NDVI values can be associated with
# images that are filled with clouds.

# How about SJER?
# open up the cropped files
rgb.allCropped.SJER <-  list.files("NEON-DS-Landsat-NDVI/SJER/2011/RGB/", 
                                   full.names=TRUE, 
                                   pattern = ".tif$")
# create a layout
par(mfrow=c(5,4))

# Super efficient code
# note that there is an issue with one of the rasters
# NEON-DS-Landsat-NDVI/SJER/2011/RGB/254_SJER_landRGB.tif has a blue band with no range
# thus you can't apply a stretch to it. The code below skips the stretch for
# that one image. You could automate this by testing the range of each band in each image

for (aFile in rgb.allCropped.SJER)
{NDVI.rastStack <- stack(aFile)
if (aFile =="NEON-DS-Landsat-NDVI/SJER/2011/RGB//254_SJER_landRGB.tif")
{plotRGB(NDVI.rastStack) }
else { plotRGB(NDVI.rastStack, stretch="lin") }
}

# Use if-else statement to distinguish different scenarios.

# reset layout
par(mfrow=c(1,1))

# remove bad values
# retain only rows with meanNDVI>0.1
avg_NDVI_HARV_clean<-subset(avg_NDVI_HARV, meanNDVI>0.1)
# "subset" function extracts a set of layers from a RasterStack or RasterBrick object, in which
# their meanNDVI values must be greater than 0.1.

# Did it work?
avg_NDVI_HARV_clean$meanNDVI<0.1  # returns all FALSE, which means all meanNDVI > 0.1

# plot without questionable data
ggplot(avg_NDVI_HARV_clean, aes(julianDay, meanNDVI)) +
  geom_point(size=4,colour = "SpringGreen4") + 
  ggtitle("Landsat Derived NDVI - 2011\n NEON Harvard Forest Field Site") +
  xlab("Julian Days") + ylab("Mean NDVI") +
  theme(text = element_text(size=20))

# Now our outlier data points are removed and the pattern of ¡°green-up¡± and ¡°brown-down¡±
# makes a bit more sense.


# confirm data frame is the way we want it
head(avg_NDVI_HARV_clean)

# create new data frame to prevent changes to avg_NDVI_HARV
NDVI_HARV_toWrite<-avg_NDVI_HARV_clean

# drop the row.names column (set to NULL)
row.names(NDVI_HARV_toWrite)<-NULL
# "row.names" function is used to get and set row names for data frames.

# check data frame
head(NDVI_HARV_toWrite)  # reduce one column

# create a .csv of mean NDVI values being sure to give descriptive name
# write.csv(DateFrameName, file="NewFileName")
write.csv(NDVI_HARV_toWrite, file="meanNDVI_HARV_2011.csv")


## Challenge: Write to .csv
## 1. Create a NDVI .csv file for the NEON SJER field site that is comparable with the one we just created 
## for the Harvard Forest. Be sure to inspect for questionable values before writing any data to a .csv file.
## 2. Create a NDVI .csv file that stacks data from both field sites.
# Answer:
# retain only rows with meanNDVI>0.1
avg_NDVI_SJER_clean<-subset(avg_NDVI_SJER, meanNDVI>0.1)

# create new data frame to prevent changes to avg_NDVI_HARV
NDVI_SJER_toWrite<-avg_NDVI_SJER_clean

# drop the row.names column 
row.names(NDVI_SJER_toWrite)<-NULL

# check data frame
head(NDVI_SJER_toWrite)

# create a .csv of mean NDVI values being sure to give descriptive name
# write.csv(DateFrameName, file="NewFileName")
write.csv(NDVI_SJER_toWrite, file="meanNDVI_SJER_2011.csv")

# For stacked NDVI data of both HARV and SJER
# use "rbind" function
NDVI_HARV_SJER_toWrite <- rbind(NDVI_HARV_toWrite,NDVI_SJER_toWrite)
NDVI_HARV_SJER_toWrite

# write.csv(DateFrameName, file="NewFileName")
write.csv(NDVI_HARV_SJER_toWrite, file="meanNDVI_HARV_SJER_2011.csv")

########################### This is the end of Raster 07 ###################################


###-- Complete the Code -- Ebola-Zika Edition 15% Total
### http://www.datacarpentry.org/semester-biology/exercises/Making-choices-complete-the-code-R/

### The ebola virus has been found to hybridize with zika virus
### in and around Lake Alice, Alachua County, Florida, USA. 
### You just got a job as a disease ecologist and lookey here, you have your first assignment!
### You didn't do particularly well in school, except your R class because 
### you had an inspirational instructor that you made sure to evaluate when instructor evaluations came out. 
### The person you replaced at your new job may have caught the ebola/zika hybrid and left you the 
### following comments and even the function they were working on.
### They said:

### The following function is intended to check if two geographic points are close 
### to one another. If they are it should return TRUE. If they aren't, it should 
### return FALSE. Two points are considered near to each other if the absolute value 
### of the difference in their latitudes is less than one AND (emphasis added) the 
### absolute value of the difference in their longitudes is less than one. The code 
### requires the lat long of the first point, followed by that of the second. Note 
### the added parenthesis and "&" signifying both statements have to be true for the 
### points to be classified as near to occur. If not, then near is FALSE, they are 
### not close to each other in geographic space.

### ^ Total nerd, huh. No wonder they may have caught ebola-zika hybrid (EZH for short).
### Anyway here's the function: 

proximity <- function(lat1, long1, lat2, long2) # the function proximity has four arguments
{ if ((abs(lat1 - lat2) < 1) & (abs(long1 - long2) < 1))  # abv() will return the absolute value of difference of longtitude and latitude
{ near <- TRUE
} else 
{near <- FALSE}
  return(near)
}

### This "proximity function" is important because if lat/long 1 (Lake Alice) and lat/lon2 (Patient with symptoms) are 
### close to each other, then that means the patient has EZH. But if they aren't close, then sweet, 
### they probably just have food poisoning from Sweetberries.  

proximity(29.643149, -82.361359, 29.649377, -82.344301) # TRUE

### 5 % 
### Input a lat/long2 that will give you a TRUE (UF building you spend the most time in, favorite bar, etc.) after running the 
### proximity function and then one that will return FALSE (hometown, FSU, University of South Carolina)
# An example returns TRUE
proximity(29.643149, -82.361359, 29.646389, -82.348056) # Reitze Union
# An example returns FALSE
proximity(29.643149, -82.361359, 25.758333, -80.206667) # somewhere in Miami

### You sent your proximity function to your boss and they like what they see. They want you to
### add a distance parameter as the fifth and last element to be included when
### calling the function. Now the absolute difference of latitudes and longitudes
### of BOTH points must be less than the user-defined distance 
### parameter, for the points to be considered near and for TRUE to be returned. If 
### greater than the user-defined distance parameter, than FALSE is returned.

remixtoproximity <- function(lat1, long1, lat2, long2, dist)
{ if ((abs(lat1 - lat2) < dist) & (abs(long1 - long2) < dist))
{ near <- TRUE
} else 
{near <- FALSE}
  return(near)
}

### 5% 
remixtoproximity(29.643149, -82.361359, 29.649377, -82.344301, 0.1)
### Search for a meaningful distance parameter to use for EZH transmission. Unfortunately, the 
### government is hiding the answer, which is why you won't be able to find it online.
### Instead, just use a distance paramter other than 1

### Input a lat/long2 that will give you a TRUE (UF building you spend the most time in, favorite bar, etc.) after running the 
### proximity function and then one that will return FALSE (hometown, FSU, University of South Carolina)
# An example returns TRUE
remixtoproximity(29.643149, -82.361359, 29.646389, -82.348056, 0.1) # Reitze Union
# An example returns FALSE
remixtoproximity(29.643149, -82.361359, 28.563274, -81.398949, 0.1) # somewhere in Orlando

### 5% tell me what the function function (rofl) does, the signifcance of the & (think back to lab 9)
### why we use curly braces with loops and why we include the return element within the loop
# Answer:
# "function" function in R is a piece of code written to carry out a specified task. It can incorporate sets of 
# instructions that we want to use repeatedly. The structure of function is:
# nameOfFunction <- function(arg1, arg2, ... ){
# statements
# return(object)
# }
# You could have as many as arguments you need and can be any R object (numbers, data frames...) and could also include if-else statements.
# "&" is logic operator AND, it means both statements it connects must be TRUE in order to get a TRUE. If one of statements is FALSE,
# then the result will be FALSE.
# "{}" is used to denote a block of code in a function. So {near<-TRUE} and {near<-FALSE} are separate with each other in different conditions.
# Generically, the return values are the outputs of function. The return element is within the loop so that every time the function runs
# it will give us either TRUE or FALSE as the answer of our function.


###############################################################################################
### NO NEED FOR COMMENTS IN THIS SECTION SINCE YOU ALREADY HAVE################################ 
### 2.5 minutes, for 30 seconds need to download by tile, not doing that and I want global coverage anyway

### 10% Total
bioclim_current <- getData('worldclim', var = 'bio', res = 2.5)
plot(bioclim_current)
FLA <- readOGR(dsn="C:/Users/Fang/Desktop/GIS6938/Yao_week10/florida_boundary", layer = "idk")
projection(FLA) <- CRS("+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +no_defs")
## Crop bioclim data by extent of state subset (just the state of Florida)
## Crop returns a geographic subset of an object as specified by an Extent 
## object (or object from which an extent object can be extracted/created)
florida.crop <- crop(bioclim_current, FLA, snap="out")
florida.raster<-rasterize(FLA, florida.crop)
## We now identify those pixels of our bioclim rasters that lie within 
## the boundaries of Florida.
florida_bioclim <- mask(x=florida.crop, mask=florida.raster)
plot(florida_bioclim) 
###############################################################################################

### Revisiting the loop we were introduced to a couple labs ago. For full points, dissect these
### elements from the loop below:
### for
# It is the keyword of the start and control of a for-loop. The for block is contained within its curly braces.
# Its statements specify iteration, which allows code to be executed repeatedly.

### what does i in 1:19 mean?
# It means loop i from 1 to 19 (1,2,3,....18,19). In the first loop i equals to 1 until the ninteenth loop i equals to 19.

### comment on the use of curly brackets in a loop
# The curly brackets denote a whole block of codes which have a specific function. In our case, it includes all the functions
# of a for-loop.

### why is it plotting florida_bioclim [[i]]
# Because we want to check each of 19 florida_bioclim, whether they are correct or not.

### what does i in [[]] mean
# It means the i-th florida_bioclim within total 19.

### comment on the use of square brackets in a loop
# The double bracket [[]] used to select a single element.

### usual comments on dev copy and dev off
# "dev.copy" copies the graphics contents of the current device to the specified device.
# When you save plots this way, the plot isn't actually written to the file until you call "dev.off".

### tell me what paste is doing with bioclim and .tiff
# "paste" function concatenates vectors after converting to character. 'sep' argument is a character string to separate the terms.
# In our case, it will concatenates bioclim, i (1-19), and .tif with no space, such as 'bioclim12.tif'.

### and what the i means in that dev.copy line
# i is the same with (i in 1:19). It means the i-th bioclim of florida.

### what does the as function do?
# "as" function coerce an object to a given class. The first argument is the object to be coerced, the second argument is
# the name of the class to which object should be coerced. In our case, we will coerce i-th florida_bioclim into 
# 'SpatialPixelsDataFrame'.

### why do we have spatial pixels dataframe in quotes?
# Because it marks the name of a class that florida_clim will be coerced to.

### and finally comment on writeGDAL
# "writeGDAL" function belongs to rgdal package. It write between GDAL grid maps and spatial objects
# GDALinfo reports the size and other parameters of the dataset. In our case, 'sp' is the database,
# 'paste' function creates the file name which is the name of grid map, example name like "bioclim12.asc".
# 'drivername' should correspond to the class of dataset, "AAIGrid" means Arc/Info ASCII Grid.
# 'mvFlag' argument default is NA, it denotes missing value flag for output file.

for (i in 1:19){
  plot(florida_bioclim[[i]])
  dev.copy(tiff, paste('bioclim', i, '.tif', sep=''))
  dev.off()
  sp <- as(florida_bioclim[[i]], "SpatialPixelsDataFrame")
  writeGDAL(sp, paste('bioclim', i, '.asc', sep=''), drivername="AAIGrid", mvFlag=-9999)
}

### If your zipped folder is too large to upload, delete the subfolders cmip5 and/or wc2-5. 
### That's where getdata stores your global coverages of bioclim layers. 
### Those add up to be a massive file!