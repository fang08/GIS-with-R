#################################################################################################
# Week 7 Lab: Use the money you'd use to buy a 
# subscription to ArcGIS on a 75-gallon aquarium 
# instead because you can do a lot of the same stuff in R
# RASTER EDITION

# If you are reading this, make sure your project has been created
# If you have not created a project, do so now, then reopen this file
# Welcome back, make sure your project has been created. 
# Navigate to the "Files" tab in the bottom right. Do you see the .csv?
# If not raise your hand during the break so I can help you

# Sources
# my forthcoming oscar-winning autobiographical movie
# http://www.worldclim.org/bioclim
# http://www.gdal.org/frmt_various.html
# http://www.statmethods.net/management/subset.html
# http://www.statmethods.net/management/operators.html
# http://swcarpentry.github.io/r-novice-inflammation/reference/
# http://neondataskills.org/tutorial-series/vector-data-series/
# http://neondataskills.org/tutorial-series/raster-data-series/
# https://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html
# http://swcarpentry.github.io/r-novice-inflammation/01-starting-with-data/
# https://swcarpentry.github.io/r-novice-inflammation/11-supp-read-write-csv/

install.packages("sp")
install.packages("dismo")
install.packages("rgdal")
install.packages("dplyr")
install.packages("raster")
install.packages("stringr")
install.packages("ecoretriever")

library(sp)
library(dismo)
library(rgdal)
library(dplyr)
library(raster)
library(stringr)
library(ecoretriever)

######################################################################################################################
### Non-native Range Presence Records 25 Points Total
#####################################################################################################################
# (5 Points)
# Read in nnfish.csv using a built-in function we have learned. 
# The only additional argument you'll be required to need is stringsAsFactors
# If you are curious of whether to set it to TRUE or FALSE, flip a penny
# Just kidding, pennies cost more to make than they are worth,
# the answer is in one of the source links
Fish_Data<-read.csv("nnfish.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE)

# (5 Points)
### Using a dplyr verb, tell me all of the 
### states represented in the nnfish.csv dataset
### save this off to a vector and tell me how many states are in this vector
### Why doesn't the function length work, check str?
Fish_Data$State  # prints out all 4000+ records of state names
states<-distinct(Fish_Data,State)
str(states)  # 'data.frame'
states$State # prints out all the unique state names
table(Fish_Data$State) # prints out all unique states, and how many records of each state
length(states)  # prints out 21, which is incorrect!(should be 33)

# (5 Points)
### Ahh, it says it's a dataframe, coerce this back into a vector
states<-as.vector(states)
# as.vector attempts to coerce its argument into a vector of mode
# (the default is to coerce to whichever vector mode is most convenient)
length(states)  # still prints out 21
str(states)
states

### O-M-G why?
states<-as.vector(states, mode='character')
# mode is character string naming an atomic mode,
# include "logical", "integer", "numeric", "complex", "character" and "raw".
length(states) # still 21

### Still no, using your dplyr verb (hint its distinct), run the following block of code:
states<-distinct(Fish_Data, State)
states_new<-unlist(states, character)
# unlist simplifies a list structure to produce a vector which contains all the atomic components.
length(states_new)  # prints out 693, still incorrect

# So finally, I use another dplyr function that counts/tally number of observations
# you could also counts by group, but it's optional. If not specified, it will return the number of rows.
count(states)  # Now it prints out 33!

### sigh of relief

# (10 Points)
### Okay return back to the dataset of 4,777 observations and 21 variables
### You will 'filter' (hint) the dataset, once for State using an operator we have learned (and the syntax for 'filter' you used in lab 5)
### Your dataset should ONLY include presence records from the state of Florida
### Then use filter again, this time for the species of your choice. 
### Just like before, post your choice in the discussion board (first come, first served)
FL_fish<-filter(Fish_Data,State == "FL")  # 4275 objects
my_fish<-filter(FL_fish,common_name == "Mayan Cichlid")  # 395 objects

### Save the resulting dataframe off. There should be 21 variables, the number
### of observations varies with your species. Make sure to include rOw.NAmeS=False
### like last time, and make sure you capitalize the right letters for this argument
write.csv(FL_fish,"FL_species.csv",row.names = FALSE)
write.csv(my_fish,"my_species.csv",row.names = FALSE) # it turns out all Mayan Cichlid records are in FL

################################################################################################
###Environmental Layers 75 POINTS TOTAL
################################################################################################

### Examine the following chunk of code
bioclim_current <- getData('worldclim', var = 'bio', res = 2.5)
### Break down the line of code entirely, telling me about (5 Points Each)

# getData: a raster function that gets geographic data for anywhere in the world. Data are first downloaded if necessary.
# the worldclim argument: thie argument specifies the dataset. 'worldclim' returns the World Climate Data. 
#                         If specified, you must also provide arguments var, and a resolution res.
# var='bio': this argument Selects variable. Valid variables names are 'tmin', 'tmax', 'prec' and 'bio'.
#            'bio' means bioclimatic variables; 'tmin' is minimum temperature; 'tmax' is maximum temperature;
#            'prec' is maximum temperature. Reference: http://www.worldclim.org/current
# and res=2.5: it specifies resolution. Valid resolutions are 0.5, 2.5, 5, and 10 (minutes of a degree).
#              Equal sign is not used here for assignment, but for the value we want to choose.

plot(bioclim_current)
# R's default is plotting these rasters 4 X 4 (total of 16), but I assure you
# the last ones are there. In fact, I'll PROVE IT!
### What does the double bracket '[[]]' do here? (5 Points)
plot (bioclim_current[[17]])
plot (bioclim_current[[18]])
plot (bioclim_current[[19]])
# the double bracket [[]] used to select a single element from 18 bioclimate variables
# covering the whole world with a resoltion of 2.5 minutes of degrees.
# Reference: http://www.gis-blog.com/r-raster-data-acquisition/
####################################################################################
### the above is the same as your first loop seen below! 
for (i in 17:19){
  plot(bioclim_current[[i]])
}
####################################################################################

### Okay I'm scared, let's move away from loops and revisit an old friend
# Reunion (5 Points)
#Hey! Look it's lab 6's readOGR, what's up, lab 6's readOGR?
FLA <- readOGR(dsn="C:/Users/Fang/Desktop/GIS6938/Yao_week7/florida_boundary", layer = "idk")
# readOGR is used to import a polygon shapefile. dsn denotes data source name; layer denotes layer name.
class(FLA)  # now FLA is ¡®SpatialPolygonsDataFrame¡¯
# layer is called idk because I didn't assign it a meaningful name. Sad!

### Tell me what projection and CRS are in R. (5 Points)
projection(FLA)
crs(FLA)
# the projection is "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
# the CRS is +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0

# Could I get away with using one or the other instead of both? Explain (5 Points)
projection(FLA) <- crs("+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +no_defs")
# after testing, it's probably not necessary to run above line.

### 50 Points Left ###

### Take the following line of code and tell me the following (10 Points Total)
florida.crop <- crop(bioclim_current, FLA, snap="out")
plot(florida.crop)
# now the plot contains part of GA and AL, because extent is different from mask.

# What is crop: crop returns a geographic subset of an object as specified by an Extent object
#               (or object from which an extent object can be extracted/created). 
# Why are bioclim_current and FLA ordered the way that they are?
# Answer: "bioclim_current" is the raster object we work on,
#          and "FLA" is the object that we want to extract Extent object from.
# What does snap=out do? What would snap=in do?
# Answer: snap is a characer we use to determine in which direction the extent should be aligned.
#         'out' means to outwards, 'in' means to inwards, and 'near' means to the nearest border.

### Take the following line of code and tell me the following (10 Points Total)
florida.raster<-rasterize(FLA, florida.crop)
plot(florida.raster) # note the plot only contains the boundary of FL
# What in tarnation is rasterize? (5 Points)
# Answer: rasterize transfers values associated with spatial data objects (points, lines, polygons) to raster cells.
# Why does it make sense assigning names like florida.crop or florida.raster to things?
# You may have to look through a style guide for full points on this question (5 Points)
# Answer: "florida.raster" is the result of rasterization, we convert the polygon FL boundary to raster cells.
#         "florida.crop" is the subset of world climate data (has the same extent with FLA).
#         florida.raster is created based on the raster characteristics/values of florida.crop.

# Finally, tell me what the function 'mask does' 5 Points 
florida_bioclim <- mask(x=florida.crop, mask=florida.raster)
plot(florida_bioclim)
# Answer: mask function creates a new raster "florida_bioclim" which has the same value as
#         x (florida.crop contains bioclim value in the state of FL);
#         has the same mask as 'florida.raste' (within the boundary of FL)

### Look through the following variables and pick your favorite
# http://www.worldclim.org/bioclim

### Think of Dijkstra! We are doing this line by line and it works, but think of 
# how we can simplify it using a loop. We'll get to loops after Spring Break

#"Call your favorite variable" (bring it up) using double square brackets [[]]
plot(florida_bioclim[[6]])
# so I just pick up bio6 Min Temperature of Coldest Month
### Tell me what dev.copy and dev.off () do 5 points Total
dev.copy(tiff, paste('bioclim', 6, '.tif', sep=''))
dev.off() 
# Answer: dev.copy copies the graphics contents of the current device to the other device.
#         tiff is one of the graphical devices in R (Reference: https://stat.ethz.ch/R-manual/R-devel/library/grDevices/html/Devices.html)
#         the 'past(.....)' is the argument for the previous "tiff" device function. (will explain paste later)
#         dev.off() is used when you're done with your plotting commands,
#         the plot isn't actually written to the file until you call dev.off().


### What is a spatial pixels data frame (5 points)
sp <- as(florida_bioclim[[6]], "SpatialPixelsDataFrame")
# Answer: the "as" method coerces/creates an object to a given class. Here the object is "florida_bioclim[[6]]",
#         and the given class is "SpatialPixelsDataFrame".
#         "SpatialPixelsDataFrame" is a class for spatial attributes that have spatial locations on a regular grid.

### For the final 5 points, break down the function writeGDAL and tell me about the arguments below:
writeGDAL(sp, paste('bioclim', 6, '.asc', sep=''), drivername="AAIGrid", mvFlag=-9999)
### Tell me what paste does since we've used it so heavily this lab
### I'd also like your description of what .asc, drivername, and mvFlag arguments
### mean using this link to guide you  http://www.gdal.org/frmt_various.html
# Answer: paste function takes vectors as input and joins/concatenates them together.
#         Here we concatenate 'bioclim', 6, and '.asc' with seperator sep=''(no space).
#         .asc means ASCII raster file.
#         writeGDAL function write between GDAL grid maps and spatial objects.
#         Here "sp" is the dataset, it could be an object of class SpatialPixelsDataFrame or SpatialGridDataFrame
#         The "paste(...)" denotes the file name of a grid map.
#         divername is GDAL driver name to support dataset creation.
#         AAIGrid is supported for read and write access to Arc/Info ASCII Grid - the file type we will create.
#         This format is the ASCII interchange format for Arc/Info Grid, and takes the form of an ASCII file,
#         plus sometimes an associated .prj file (we could see a .prj file for output).
#         mvFlag is missing value flag for output file, default is NA, we assign to -9999.

### We will be doing #funstuff with both your variable of choice and fish species next lab
### so make sure each were saved correctly and are easily accessible for you when we meet
### again in March #newmonthnewme have a great break, remmeber to turn in your lab proposals