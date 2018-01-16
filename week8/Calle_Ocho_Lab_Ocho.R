### RARARA-STER VERSION II (THE REMIX) LAB 8

### Two weeks ago we worked with raster data from worldclim.org. 
### These data were bioclimatic layers averaged from 1960-1990 
### and you saved them off as GeoTiff and ASCII files.
### Today we will be working with NDVI data, 
### but you will be using a lot of the same steps as in Lab 7. 
### We are going over NDVI in this lab because 
### we get to play with time series data next week!!!

### Create a new project for this week's lab
### Download the data found in the Raster Data Series Tutorial found here 
### http://neondataskills.org/tutorial-series/raster-data-series/
### Place the data inside your project folder. When this is done, 
### check the bottom right of your screen. The data should be visible (NO SUB-FOLDERS)
### Complete all Challenge Questions in Raster 00-04 AND Vector 05. 
### My recommendation is to work through the Raster Series and then Vector 05

### For Vector 05 Module, you may need to revisit your code 
### from the last time we worked with this module
### NEON Data Tutorial Series Modules used in this lab: 

### Vector 05 found at http://neondataskills.org/R/crop-extract-raster-data-R/
### Raster 00- Raster 04 found at http://neondataskills.org/tutorial-series/raster-data-series/
### Additional resource: http://www.datacarpentry.org/semester-biology/materials/spatial-data-R/

### Leave comments on every non-base-R function that is used in this lab. 
### This includes commenting on the arguments!

### Save plots using code you've learned earlier in the class. File type doesn't matter to me
### but you must be able to save off the plot/image programmatically and not by scrolling over
### to "Export" on the bottom right of the screen, 
### i.e., "pointing and clicking your way to Nirvana"- Tim Fik 

### Install the packages "ggplot2", sp", "rgdal", and "raster" in the lines below.

### You can check that packages are installed using
installed.packages()

### Raster data are gridded values of data used in remote sensing/environmental data
### that is smoothed across the landscape, these are fundamentally grids of numbers. 

### Biggest single challenge with spatial data is getting the file formats to work together, 
### we are working with geotiffs with metadata associated with them. 

### Check out the structure of any of your .tiff files using base function str

### crs is also a handy function to know

### All the plotting functions are overwritten by installing "raster", 
### so we can get these graphical representations of the rasters using base function plot

### Want to view ore than one plot?
### Use par(mfrow=c(2,2), mar=c(5, 4, 2, 2)) prior to plotting 
### to get the four figures on the same panel and to set margins to make labels visible.
### Running dev.off will clear this back to default settings if you get bored

### Get some more information, like distribution of the values using base function hist

### Remember that readOGR's dsn argument is a lil trickster. You need the full file path
### with /// not \\\

install.packages("raster")
install.packages("rgdal")
install.packages("rasterVis")
install.packages("ggplot2")
install.packages("sp")

# load all libraries
library(sp)
library(rgdal)
library(ggplot2)
library(raster)
library(rasterVis)

######## Raster 00: Intro to Raster Data in R ########

# Load raster into R
# use the raster("path-to-raster") function to open a raster in R
# if the file is in the project folder, just put raster file name in ""
DSM_HARV <- raster("HARV_dsmCrop.tif")
# View raster structure
DSM_HARV
# plot raster(note \n in the title forces a line break in the title)
# DSM_HARV is the rasterLayer to plot, "main=" is the title of plot
plot(DSM_HARV, main="NEON Digital Surface Model\nHarvard Forest")
# save the plot
# dev.copy copies the graphics contents of the current device to the other device.
# png is the device type, ' ' is the name of the to-be-saved file
# dev.off() is used when you're done with your commands
dev.copy(png,'DSM_HARV.png')
dev.off()

# view resolution units (+units=m)
# crs means Coordinate Reference System, view the CRS string
crs(DSM_HARV)
# assign crs to an object (class) to use for reprojection and other tasks
myCRS <- crs(DSM_HARV)
myCRS

# view the  min value
minValue(DSM_HARV)
# view the max value
maxValue(DSM_HARV)

# view histogram of data
# using the hist() function to produce a histogram, in which
# "main=" is the title of histogram plot
# "xlab=" is the label of x axis, "ylab" is the label of y axis
# "col=" is the color of histogram
hist(DSM_HARV,
     main="Distribution of Digital Surface Model Values\n Histogram Default: 100,000 pixels\n NEON Harvard Forest",
     xlab="DSM Elevation Value (m)",
     ylab="Frequency",
     col="wheat")
# save the plot
dev.copy(png,'DSM_HARV_hist.png')
dev.off()

# View the total number of pixels (cells) in is our raster 
ncell(DSM_HARV)
# create histogram that includes with all pixel values in the raster
# default maximum pixels value of 100,000 associated with the hist function
# so use maxpixels argument to force R plotting all pixel values "ncell(DSM_HARV)"
hist(DSM_HARV, 
     maxpixels=ncell(DSM_HARV),
     main="Distribution of DSM Values\n All Pixel Values Included\n NEON Harvard Forest Field Site",
     xlab="DSM Elevation Value (m)",
     ylab="Frequency",
     col="wheat4")
# save the plot
dev.copy(png,'DSM_HARV_hist_all.png')
dev.off()

# view number of bands use nlayers function
nlayers(DSM_HARV)

# view attributes before opening file
# use the GDALinfo("path-to-raster") function to view raster metadata before we open a file in R
GDALinfo("HARV_dsmCrop.tif")

# Challenge: Explore Raster Metadata
GDALinfo("HARV_DSMhill.tif")
# 1. Does this file has the same CRS as DSM_HARV?
# Answer: Yes, they have the same projection "+proj=utm +zone=18 +datum=WGS84 +units=m +no_defs".
# 2. What is the NoDataValue?
# Answer: The NoDataValue of HARV_DSMhill.tif is -9999.
# 3. What is resolution of the raster data?
# Answer: The resolution is 1x1 because res.x is 1 and res.y is 1.
# 4. How large would a 5x5 pixel area would be on the Earth's surface?
# Answer: Because resolution represents the area on the ground that each pixel covers and 
#         the units for our data are in meters, so that means each pixel represents a 
#         1 square meter area on the ground. Therefore a 5x5 pixel area represents a 
#         5 meters x 5 meters = 25 square meters area on the Earth's surface.
# 5. Is the file a multi- or single-band raster?
# Answer: HARV_DSMhill.tif is a sinlge (1) band raster.

######## This is the end of Raster 00 ########


######## Raster 01: Plot Raster Data in R ########
## Notice that some of the steps we have already done in Raster 00

# Plot distribution of raster values 
# use the "breaks=" argument to get bins that are meaningful representations
# of our data, it tells R to use fewer or more breaks or bins.
DSMhist<-hist(DSM_HARV,
              breaks=3,
              main="Histogram Digital Surface Model\n NEON Harvard Forest Field Site",
              col="wheat3",  # changes bin color
              xlab= "Elevation (m)")  # label the x-axis
# save the plot
dev.copy(png,'DSM_HARV_hist_break.png')
dev.off()

# use dollar sign $ to access where are breaks and how many pixels in each category
DSMhist$breaks
DSMhist$counts

# plot using breaks
# use breaks argument to specify where the breaks occur use syntax c(value1,value2,value3...)
# use terrain.colors() function to create a vector(palette) of n contiguous colors
plot(DSM_HARV, 
     breaks = c(300, 350, 400, 450), 
     col = terrain.colors(3),
     main="Digital Surface Model (DSM)\n NEON Harvard Forest Field Site")

# save the plot
dev.copy(png,'DSM_HARV_breaks.png')
dev.off()

# Assign color to a object for repeat use or ease of changing
myCol = terrain.colors(3)
# Add axis labels
plot(DSM_HARV, 
     breaks = c(300, 350, 400, 450), 
     col = myCol,
     main="Digital Surface Model\nNEON Harvard Forest Field Site", 
     xlab = "UTM Westing Coordinate (m)", 
     ylab = "UTM Northing Coordinate (m)")

# save the plot
dev.copy(png,'DSM_HARV_withlabels.png')
dev.off()

# or we can turn off the axis altogether using "axes=" argument
plot(DSM_HARV, 
     breaks = c(300, 350, 400, 450), 
     col = myCol,
     main="Digital Surface Model\n NEON Harvard Forest Field Site", 
     axes=FALSE)

# save the plot
dev.copy(png,'DSM_HARV_offaxis.png')
dev.off()

# Challenge: Plot Using Custom Breaks
# Create a plot of the Harvard Forest Digital Surface Model (DSM) that has:
# - Six classified ranges of values (break points) that are evenly divided among the range of pixel values.
# - Axis labels
# - A plot title
# Answer:
# use dev.new opens a new device and set the width and height of the device
dev.new(width=12, height=6)
# use seq function to generate regular sequences, "from" min value "to" max value,
# length.out sets desired length of the sequence (7 sequence to evenly divide 6 parts)
brks <- seq(minValue(DSM_HARV),maxValue(DSM_HARV),length.out=7)
plot(DSM_HARV, 
     breaks = brks, 
     col = terrain.colors(6),
     main="My Plot: Digital Surface Model\nNEON Harvard Forest Field Site", 
     xlab = "UTM Westing Coordinate (m)", 
     ylab = "UTM Northing Coordinate (m)")
# save the plot
dev.copy(png,'DSM_HARV_challenge.png')
dev.off()

# use the functions below to check the size of plot
# par()$fin
# dev.size("in")

# import DSM hillshade
DSM_hill_HARV <- raster("HARV_DSMhill.tif")

dev.new(width=12, height=6)
# plot hillshade using a grayscale color ramp that looks like shadows.
plot(DSM_hill_HARV,
     col=grey(1:100/100),  # create a color ramp of grey colors
     legend=FALSE,
     main="Hillshade - DSM\n NEON Harvard Forest Field Site",
     axes=FALSE)
# save the plot
dev.copy(png,'DSM_hill_HARV.png')
dev.off()

# add the DSM on top of the hillshade
# turn off, or hide, the legend on a plot using "legend=FALSE" or "F"
# set the transparency of the plot using "alpha=", a number in [0,1]
# layer another raster on top of hillshade  using "add=TRUE" or "T"
plot(DSM_HARV,
     col=rainbow(100), # 100 is the number of colors (¡Ý 1) to be in the palette
     alpha=0.4,
     add=T,
     legend=F)
# save the plot
dev.copy(png,'DSM_hill_HARV_color.png')
dev.off()

# Challenge: Create DTM & DSM for SJER
# create a Digital Terrain Model map and Digital Surface Model map 
# of the San Joaquin Experimental Range field site.
# Make sure to:
# - include hillshade in the maps,
# - label axes on the DSM map and exclude them from the DTM map,
# - a title for the maps,
# - experiment with various alpha values and color palettes to represent the data.
# Answer:
# import all the DSM and DTM files
DSM_hill_SJER <- raster("SJER_dsmHill.tif")
DTM_hill_SJER <- raster("SJER_dtmHill.tif")
DSM_SJER <- raster("SJER_dsmCrop.tif")
DTM_SJER <- raster("SJER_dtmCrop.tif")

# CREATE SJER DSM MAP
dev.new(width=12, height=6)
# plot hillshade using a grayscale color ramp that looks like shadows.
plot(DSM_hill_SJER,
     col=grey(1:100/100),  #create a color ramp of grey colors
     legend=F,
     main="DSM with Hillshade\n NEON SJER Field Site",
     axes=FALSE)
# add the DSM on top of the hillshade
plot(DSM_SJER,
     col=terrain.colors(100),
     alpha=0.7,
     add=T,
     legend=F)
# save the plot
dev.copy(png,'DSM_hill_SJER.png')
dev.off()

# CREATE SJER DTM MAP
dev.new(width=12, height=6)
# plot hillshade using a grayscale color ramp that looks like shadows.
plot(DTM_hill_SJER,
     col=grey(1:100/100),  #create a color ramp of grey colors
     legend=F,
     main="DTM with Hillshade\n NEON SJER Field Site",
     axes=FALSE)
# add the DSM on top of the hillshade
plot(DTM_SJER,
     col=terrain.colors(100),
     alpha=0.4,
     add=T,
     legend=F)
# save the plot
dev.copy(png,'DTM_hill_SJER.png')
dev.off()

######## This is the end of Raster 01 ########


######## Raster 02: When Rasters Don't Line Up - Reproject Raster Data in R ########
# import DTM
DTM_HARV <- raster("HARV_dtmCrop.tif")
# import DTM hillshade
DTM_hill_HARV <- raster("HARV_DTMhill_WGS84.tif")

# plot hillshade using a grayscale color ramp 
plot(DTM_hill_HARV,
     col=grey(1:100/100),
     legend=FALSE,
     main="DTM Hillshade\n NEON Harvard Forest Field Site")
# save the plot
dev.copy(png,'DTM_hill_HARV.png')
dev.off()

# overlay the DTM on top of the hillshade
plot(DTM_HARV,
     col=terrain.colors(10),
     alpha=0.4,
     add=TRUE,
     legend=FALSE)
# Notice: DTM_HARV did not plot on top of our hillshade, and showed an error:
# ...cannot allocate memory block of size 67108864 Tb

# Plot DTM 
plot(DTM_HARV,
     col=terrain.colors(10),
     alpha=1,
     legend=F,
     main="Digital Terrain Model\n NEON Harvard Forest Field Site")
# save the plot
dev.copy(png,'DTM_HARV.png')
dev.off()
# But plot DTM_HARV individually is fine

# view crs for DTM
crs(DTM_HARV)
# view crs for hillshade
crs(DTM_hill_HARV)
# it turns out that DTM_HARV is in the UTM projection,
# while DTM_hill_HARV is in Geographic WGS84.

# reproject to UTM
# use the "projectRaster" function to reproject a raster into a new CRS
# the "crs=" argument assign new crs to the raster (e.g. UTM)
DTM_hill_UTMZ18N_HARV <- projectRaster(DTM_hill_HARV, 
                                       crs=crs(DTM_HARV))

# compare attributes of DTM_hill_UTMZ18N to DTM_hill
crs(DTM_hill_UTMZ18N_HARV)
crs(DTM_hill_HARV)

# compare attributes of DTM_hill_UTMZ18N to DTM_hill
extent(DTM_hill_UTMZ18N_HARV)
extent(DTM_hill_HARV)

# Challenge: Extent Change with CRS Change
# Why do you think the two extents differ?
# Answer: Because we just used reproject function to move it from one ¡°grid¡± to another.
#         The extent for DTM_hill_UTMZ18N_HARV is in meters (UTMS), while 
#         the extent for DTM_hill_HARV is in decimal degrees (lat/long).

# compare resolution use "res" function
res(DTM_hill_UTMZ18N_HARV)
# adjust the resolution
# use code "res=" to force our newly reprojected raster to be 1m x 1m resolution
DTM_hill_UTMZ18N_HARV <- projectRaster(DTM_hill_HARV, 
                                       crs=crs(DTM_HARV),
                                       res=1)
# view resolution (now is 1x1)
res(DTM_hill_UTMZ18N_HARV)

dev.new(width=12, height=6)
# plot newly reprojected hillshade
plot(DTM_hill_UTMZ18N_HARV,
     col=grey(1:100/100),
     legend=F,
     main="DTM with Hillshade\n NEON Harvard Forest Field Site")

# overlay the DTM on top of the hillshade
plot(DTM_HARV,
     col=rainbow(100),
     alpha=0.4,
     add=T,
     legend=F)
# save the plot
dev.copy(png,'DTM_hill_HARV_adjust.png')
dev.off()

# Challenge: Reproject, then Plot a Digital Terrain Model
# Create a map of the San Joaquin Experimental Range field site using 
# the SJER_DSMhill_WGS84.tif and SJER_dsmCrop.tif files.
# Answer:
# import DSM
DSM_SJER <- raster("SJER_dsmCrop.tif")
# import DSM hillshade
DSM_hill_SJER_WGS <- raster("SJER_DSMhill_WGS84.tif")

# reproject raster and force resolution
DSM_hill_UTMZ18N_SJER <- projectRaster(DSM_hill_SJER_WGS, 
                                       crs=crs(DSM_SJER),
                                       res=1)

dev.new(width=12, height=6)
# plot hillshade using a grayscale color ramp 
plot(DSM_hill_UTMZ18N_SJER,
     col=grey(1:100/100),
     legend=F,
     main="DSM with Hillshade\n NEON SJER Field Site")

# overlay the DSM on top of the hillshade
plot(DSM_SJER,
     col=terrain.colors(10),
     alpha=0.4,
     add=T,
     legend=F)
# save the plot
dev.copy(png,'DTM_hill_HARV_adjust.png')
dev.off()

# how does the map you just created compare to the map in Raster 01?
# Answer: The maps look exactly the same although they have difference coordinate systems.
#         The 02 one was reprojected from WGS84 to UTM when plotting.  

######## This is the end of Raster 02 ########


######## Raster 03: Raster Calculations in R - Subtract One Raster from ########
######## Another and Extract Pixel Values For Defined Locations ########
# view info about the dtm & dsm raster data that we will work with.
GDALinfo("HARV_dtmCrop.tif")
GDALinfo("HARV_dsmCrop.tif")

# load the DTM & DSM rasters: we already did that in previous tutorial

# create a quick plot of each to see what we're dealing with
plot(DTM_HARV,
     main="Digital Terrain Model \n NEON Harvard Forest Field Site")

plot(DSM_HARV,
     main="Digital Surface Model \n NEON Harvard Forest Field Site")

# (we already saved them before, here not to save twice)

# Raster math example: just use the operator "-"
CHM_HARV <- DSM_HARV - DTM_HARV 
# plot the output CHM
plot(CHM_HARV,
     main="Canopy Height Model - Raster Math Subtract\n NEON Harvard Forest Field Site",
     axes=FALSE)
# save the plot
dev.copy(png,'CHM_HARV1.png')
dev.off()

# histogram of CHM_HARV
hist(CHM_HARV,
     col="springgreen4",
     main="Histogram of Canopy Height Model\nNEON Harvard Forest Field Site",
     ylab="Number of Pixels",
     xlab="Tree Height (m) ")
# save the plot
dev.copy(png,'CHM_HARV_hist.png')
dev.off()

# Challenge: Explore CHM Raster Values
# 1. What is the min and maximum value for the Harvard Forest Canopy
#    Height Model (CHM_HARV) that we just created?
# Answer: min value is 0 and max value is 38.16998
minValue(CHM_HARV)
maxValue(CHM_HARV)

# 2. What are two ways you can check this range of data in CHM_HARV?
# Answer: By default, the horizontal axis spans the range of the dataset, so you could
#         look directly at the histogram, or use max-min to calculate
rangeCHM <- maxValue(CHM_HARV)-minValue(CHM_HARV)
rangeCHM

# 3. What is the distribution of all the pixel values in the CHM?
# Answer:
# use "maxpixels=" argument to force plot all the pixels in the CHM
hist(CHM_HARV, 
     col="springgreen4",
     main = "Histogram of Canopy Height Model\nNEON Harvard Forest Field Site",
     maxpixels=ncell(CHM_HARV))
# save the plot
dev.copy(png,'CHM_HARV_histall.png')
dev.off()

# 4. Plot a histogram with 6 bins instead of the default and change the color of the histogram.
# Answer:
# use "breaks=" argument to set the number of bins we need
hist(CHM_HARV, 
     col="lightgreen",
     main = "Histogram of Canopy Height Model\nNEON Harvard Forest Field Site",
     maxpixels=ncell(CHM_HARV),
     breaks=6)
# save the plot
dev.copy(png,'CHM_HARV_hist6.png')
dev.off()

# 5. Plot the CHM_HARV raster using breaks that make sense for the data.
# Include a appropriate color palette for the data, plot title and no axes ticks/labels.
# Answer:
myCol2=terrain.colors(4)
plot(CHM_HARV,
     breaks=c(0,10,20,30),
     col=myCol2,
     axes=F,
     main="Canopy Height Model \nNEON Harvard Forest Field Site")
# save the plot
dev.copy(png,'CHM_HARV2.png')
dev.off()

# Another way for raster calculation: raster-overlay
# The "overlay()" function takes two or more rasters and applies a function/calculation to them.
# The syntax is: outputRaster <- overlay(raster1, raster2, fun=functionName)
# Here we create a custom function for tasks that need to be repeated over and over in the code.
# The syntax is: function(variable1, variable2){WhatYouWantDone, WhatToReturn}, things inside {} will repeat
CHM_ov_HARV<- overlay(DSM_HARV,
                      DTM_HARV,
                      fun=function(r1, r2){return(r1-r2)})
plot(CHM_ov_HARV,
     main="Canopy Height Model - Overlay Subtract\n NEON Harvard Forest Field Site")
# save the plot
dev.copy(png,'CHM_HARV_overlay.png')
dev.off()

# export CHM object to new GeotIFF
# after we¡¯ve created a new raster, export the data as a GeoTIFF using
# the "writeRaster()" function.
writeRaster(CHM_ov_HARV, "chm_HARV.tiff", # the raster to be exported and its name
            format="GTiff",  # specify output format - GeoTIFF
            overwrite=TRUE, # CAUTION: if this is true, it will overwrite an existing file
            NAflag=-9999) # set no data value to -9999

# Challenge: Explore the NEON San Joaquin Experimental Range Field Site
# Import the SJER DSM and DTM raster files and create a Canopy Height Model.
# Then compare the two sites.
# 1. Import the DSM and DTM from the SJER directory.
#    Don¡¯t forget to examine the data for CRS, bad values, etc.
# Answer: we already imported DSM and DTM raster data, so we don't need to do that again.
# check CRS, units, nodata values etc using:
GDALinfo("SJER_dtmCrop.tif")
GDALinfo("SJER_dsmCrop.tif")
# check detail values with histogram (help detect bad values)
hist(DTM_SJER, 
     maxpixels=ncell(DTM_SJER),
     main="Digital Terrain Model - Histogram\n NEON SJER Field Site",
     col="slategrey",
     ylab="Number of Pixels",
     xlab="Elevation (m)")
dev.copy(png,'DTM_SJER_hist.png')
dev.off()

hist(DSM_SJER, 
     maxpixels=ncell(DSM_SJER),
     main="Digital Surface Model - Histogram\n NEON SJER Field Site",
     col="slategray2",
     ylab="Number of Pixels",
     xlab="Elevation (m)")
dev.copy(png,'DSM_SJER_hist.png')
dev.off()

# 2. Create a CHM from the two raster layers and check to make sure the data are what you expect.
# Answer:
# use overlay to subtract the two rasters & create CHM
CHM_SJER <- overlay(DSM_SJER,DTM_SJER,
                    fun=function(r1, r2){return(r1-r2)})

hist(CHM_SJER, 
     main="Canopy Height Model - Histogram\n NEON SJER Field Site",
     col="springgreen4",
     ylab="Number of Pixels",
     xlab="Elevation (m)")
dev.copy(png,'CHM_SJER_hist.png')
dev.off()

# 3. Plot the CHM from SJER.
# Answer:
plot(CHM_SJER,
     main="Canopy Height Model - Overlay Subtract\n NEON SJER Field Site",
     axes=F)
dev.copy(png,'CHM_SJER.png')
dev.off()

# 4. Export the SJER CHM as a GeoTIFF.
# Answer: write to object to file with writeRaster
writeRaster(CHM_SJER,"chm_ov_SJER.tiff",
            format="GTiff", 
            overwrite=TRUE, 
            NAflag=-9999)

# 5. Compare the vegetation structure of the Harvard Forest and San Joaquin Experimental Range.
# Answer: Compare the histogram plot of CHM_HARV and CHM_SJER, we could find that the distribution
#         of HARV concentrate around 20m while most of pixel values of SJER are around 0-5m.
#         Thus tree heights in HARV are much higher than in SJER.

######## This is the end of Raster 03 ########


######## Raster 04: Work With Multi-Band Rasters - Image Data in R ########
# Read in multi-band raster with raster function. 
# Default is the first band only.
RGB_band1_HARV <- raster("HARV_RGB_Ortho.tif")

# create a grayscale color palette to use for the image.
grayscale_colors <- gray.colors(100,            # number of different color levels 
                                start = 0.0,    # how black (0) to go
                                end = 1.0,      # how white (1) to go
                                gamma = 2.2,    # correction between how a digital 
                                # camera sees the world and how human eyes see it
                                alpha = NULL)   #Null=colors are not transparent

# Plot band 1
plot(RGB_band1_HARV, 
     col=grayscale_colors, # use the grey color we just created
     axes=FALSE,
     main="RGB Imagery - Band 1-Red\nNEON Harvard Forest Field Site")
dev.copy(png,'RGB_band1_HARV.png')
dev.off()

# view attributes: Check out dimension, CRS, resolution, values attributes, and band.
RGB_band1_HARV
# view min value (0)
minValue(RGB_band1_HARV)
# view max value (255)
maxValue(RGB_band1_HARV)

## read-specific-band
# Can specify which band we want to read in use "band=" argument
RGB_band2_HARV <- raster("HARV_RGB_Ortho.tif", band = 2)

# plot band 2
plot(RGB_band2_HARV,
     col=grayscale_colors, # we already created this palette & can use it again
     axes=FALSE,
     main="RGB Imagery - Band 2- Green\nNEON Harvard Forest Field Site")
dev.copy(png,'RGB_band2_HARV.png')
dev.off()

# view attributes of band 2 
RGB_band2_HARV

# Challenge: Making Sense of Single Band Images
# Compare the plots of band 1 (red) and band 2 (green). Is the forested area darker or 
# lighter in band 2 (the green band) compared to band 1 (the red band)?
# Answer: The forested area lighter in band 2 (green) than in band 1 (red), because
#         healthy leaves reflect more green light than red light, that's why they
#         look green.

# Use stack function to read in all bands
# The stack() function bring in all bands of a multi-band raster to create a RasterStack.
RGB_stack_HARV <- stack("HARV_RGB_Ortho.tif")

# view attributes of stack object
RGB_stack_HARV

# view raster attributes by different layers
RGB_stack_HARV@layers
# view attributes for one band (e.g. layer 1)
RGB_stack_HARV[[1]]

# view histogram of all 3 bands (show in three histograms separately)
hist(RGB_stack_HARV,
     maxpixels=ncell(RGB_stack_HARV))
dev.copy(png,'RGB_stack_HARV_hist.png')
dev.off()

# plot all three bands separately
plot(RGB_stack_HARV, 
     col=grayscale_colors)
dev.copy(png,'RGB_stack_HARV.png')
dev.off()

# revert to a single plot layout
# R uses "par()" function to combine multiple plots into one overall graph
# option mfrow=c(nrows, ncols) to create a matrix of nrows x ncols plots that are filled in by row;
# mfcol=c(nrows, ncols) fills in the matrix by columns.
par(mfrow=c(1,1)) 

# plot band 2 
plot(RGB_stack_HARV[[2]], 
     main="Band 2\n NEON Harvard Forest Field Site",
     col=grayscale_colors)
dev.copy(png,'RGB_stack_HARV_b2.png')
dev.off()

# Create an RGB image from the raster stack
# plotRGB function make a Red-Green-Blue plot based on three layers.
# The r, g, b argument are index of the Red, Green and Blue channel,
# integer value between 1 and nlayers(x).
plotRGB(RGB_stack_HARV, 
        r = 1, g = 2, b = 3)
dev.copy(png,'RGB_stack_HARV_color.png')
dev.off()

# "scale=" argument is possible maximum value in the three channels,
# it's an integer and default is 255, could be larger than 255.
# "stretch=" argument is option to stretch the values to increase the contrast of the image
# "lin" is linear streching and "hist" is hitogram streching.
plotRGB(RGB_stack_HARV,
        r = 1, g = 2, b = 3, 
        scale=800,
        stretch = "lin")
dev.copy(png,'RGB_stack_HARV_lstrech.png')
dev.off()

plotRGB(RGB_stack_HARV,
        r = 1, g = 2, b = 3, 
        scale=800,
        stretch = "hist")
dev.copy(png,'RGB_stack_HARV_hstrech.png')
dev.off()

# Challenge - NoData Values
# use the HARV_Ortho_wNA.tif:
# 1. View the files attributes. Are there NoData values assigned for this file?
# Answer: Yes.
GDALinfo("HARV_Ortho_wNA.tif")

# 2. If so, what is the NoData Value?
# Answer: NoData values are assigned as -9999.

# 3. How many bands does it have?
# Answer: 3

# 4. Open the multi-band raster file in R.
# Answer: reading in file using stack function
HARV_NA<- stack("HARV_Ortho_wNA.tif")

# 5. Plot the object as a true color image.
# Answer: use plotRGB function to assign r = red band, g = green band 
#         and b = blue band to get true color image.
plotRGB(HARV_NA, 
        r = 1, g = 2, b = 3)
dev.copy(png,'HARV_NA.png')
dev.off()

# 6. What happened to the black edges in the data?
# Answer: The black edges are not plotted (empty).

# 7. What does this tell us about the difference in the data structure between
# HARV_Ortho_wNA.tif and HARV_RGB_Ortho.tif (R object RGB_stack). How can you check?
# Answer: They both have NoDataValue. HARV_RGB_Ortho.tif doesn't define NoData (it shows
#         -1.7e+308) while HARV_Ortho_wNA.tif has NoData value as -9999. Thus R Renders
#         RGB NoData values as black color but the later Ortho_wNA NoData value as NA.
GDALinfo("HARV_Ortho_wNA.tif")
GDALinfo("HARV_RGB_Ortho.tif")

# view size of the RGB_stack object that contains our 3 band image
# use object.size() function (40336 bytes)
object.size(RGB_stack_HARV)

# convert RasterStack to a RasterBrick use function "brick(StackName)".
# They are object types can both store multiple bands.
RGB_brick_HARV <- brick(RGB_stack_HARV)

# view size of the brick (170896080 bytes)
object.size(RGB_brick_HARV)

# the raster brick is much larger than raster stack because 
# the bands in a RasterStack are stored as links to raster data
# that is located somewhere on our computer. But A RasterBrick contains
# all of the objects stored within the actual R object.

# plot brick use default settings
plotRGB(RGB_brick_HARV)
dev.copy(png,'RGB_brick_HARV.png')
dev.off()

# Challenge: What Methods Can Be Used on an R Object?
# We can view various methods available to call on an R object with 
# methods(class=class(objectNameHere)).
# 1. What methods can be used to call on the RGB_stack_HARV object?
# Answer:
# methods for calling a stack: total 162 methods
methods(class=class(RGB_stack_HARV))

# 2. What methods are available for a single band within RGB_stack_HARV?
# Answer:
# methods for calling a band (1) with a stack as an example: 41 methods
methods(class=class(RGB_stack_HARV[1]))

# 3. Why do you think there is a difference?
# Answer: Because there are far more thing one could or wants to ask of 
# a full stack than of a single band.

######## This is the end of Raster 04 ########


######## Vector 05: Crop Raster Data and Extract Summary Pixels Values From Rasters in R ########
# Import a polygon shapefile using readOGR() function
# If the shapefile you are reading is in current working directory,
# the dsn refers to that directory,  use ¡°.¡± to represent dsn
aoiBoundary_HARV <- readOGR(".","HarClip_UTMZ18")

# Import a line shapefile
lines_HARV <- readOGR( ".", "HARV_roads")

# Import a point shapefile 
point_HARV <- readOGR(".","HARVtower_UTM18N")

# import raster Canopy Height Model (CHM)
chm_HARV <- raster("HARV_chmCrop.tif")

dev.new(width=12, height=6)
# plot full CHM
plot(chm_HARV,
     main="LiDAR CHM - Not Cropped\nNEON Harvard Forest Field Site")
dev.copy(png,'chm_HARV.png')
dev.off()

# crop the chm
# crop() function returns a geographic subset of an object as specified by an Extent object
# x is the raster object to be cropped, y is the extent object
chm_HARV_Crop <- crop(x = chm_HARV, y = aoiBoundary_HARV)

# plot full CHM
dev.new(width=12, height=6)
# plot(x, y, ...) is generic function for plotting of R objects, in which
# x is the coordinates in the plot, y is optional coordinates for the plot
# "lwd" sets the line width, "col" sets color, "main=" sets the title
# xlab and ylab are labels of x and y axis
plot(extent(chm_HARV),
     lwd=4,col="springgreen",
     main="LiDAR CHM - Cropped\nNEON Harvard Forest Field Site",
     xlab="easting", ylab="northing")
# add another layer on top of previous one
plot(chm_HARV_Crop,
     add=TRUE)
dev.copy(png,'chm_HARV_Crop.png')
dev.off()

# lets look at the extent of all of our objects
extent(chm_HARV)
extent(chm_HARV_Crop)
extent(aoiBoundary_HARV)

# Challenge: Crop to Vector Points Extent
# 1. Crop the Canopy Height Model to the extent of the study plot locations.
# Answer:
# imported Shapefile in R
plot.locationSp_HARV <- readOGR(".", "PlotLocations_HARV")

# crop the chm
chm_ext<-extent(plot.locationSp_HARV)
CHM_plots_HARVcrop <- crop(x = chm_HARV, y = chm_ext)

plot(CHM_plots_HARVcrop,
     main="Study Plot Locations\n NEON Harvard Forest")
dev.copy(png,'CHM_plots_HARVcrop.png')
dev.off()

# 2. Plot the vegetation plot location points on top of the Canopy Height Model.
# Answer:
# "pch=" option to specify symbols (node, square, asterisk...) to use when plotting points
plot(plot.locationSp_HARV, 
     add=TRUE,
     pch=19,
     col="blue")
dev.copy(png,'CHM_plots_HARVcrop_p.png')
dev.off()

# use an extent() method to define an extent to be used as a cropping boundary
# extent format (xmin,xmax,ymin,ymax)
new.extent <- extent(732161.2, 732238.7, 4713249, 4713333)
class(new.extent)

# crop raster use the new extent we just created
CHM_HARV_manualCrop <- crop(x = chm_HARV, y = new.extent)

# plot extent boundary and newly cropped raster
plot(aoiBoundary_HARV, 
     main = "Manually Cropped Raster\n NEON Harvard Forest Field Site")
plot(new.extent, 
     col="brown", 
     lwd=4,
     add = TRUE)
plot(CHM_HARV_manualCrop, 
     add = TRUE)
dev.copy(png,'CHM_HARV_manualCrop.png')
dev.off()

# extract tree height for AOI
# extract() function extract values from a Raster at the locations of other spatial data.
# x is the raster, y is the extent
# set df=TRUE to return a data.frame rather than a list of values
tree_height <- extract(x = chm_HARV, 
                       y = aoiBoundary_HARV, 
                       df=TRUE)

# view the object
head(tree_height) # return the first part of object
nrow(tree_height) # return the number of rows

# view histogram of tree heights in study area
# use the dollar sign $ to access a specific column
hist(tree_height$HARV_chmCrop, 
     main="Histogram of CHM Height Values (m) \nNEON Harvard Forest Field Site",
     col="springgreen",
     xlab="Tree Height", ylab="Frequency of Pixels")
dev.copy(png,'tree_height_hist.png')
dev.off()

# view summary of values
summary(tree_height$HARV_chmCrop)

# extract the average tree height (calculated using the raster pixels)
# located within the AOI polygon
# "fun=" argument is the function to summarize the values (calculate the mean value)
av_tree_height_AOI <- extract(x = chm_HARV, 
                              y = aoiBoundary_HARV,
                              fun=mean, 
                              df=TRUE)

# view output (only one row shows mean value)
av_tree_height_AOI

# what are the units of our buffer
crs(point_HARV)

# extract the average tree height (height is given by the raster pixel value) at the tower location
# "buffer=" argument set the radius around each point from which to extract cell values.
# use a buffer of 20 meters and mean function (fun) 
av_tree_height_tower <- extract(x = chm_HARV, 
                                y = point_HARV, 
                                buffer=20,
                                fun=mean, 
                                df=TRUE)

# view data (only one row shows mean value)
head(av_tree_height_tower)

# how many pixels were extracted (1)
nrow(av_tree_height_tower)

# Challenge: Extract Raster Height Values For Plot Locations
# Extract an average tree height value for the area within 20m of
# each vegetation plot location in the study area.
# Create a simple plot showing the mean tree height of each plot 
# using the plot() function in base-R.
# Answer:
# first import the plot location file.
plot.locationsSp_HARV <- readOGR(".", "PlotLocations_HARV")
# extract data at each plot location (20m and mean)
meanTreeHt_plots_HARV <- extract(x = chm_HARV, 
                                 y = plot.locationsSp_HARV, 
                                 buffer=20,
                                 fun=mean, 
                                 df=TRUE)

# view data
meanTreeHt_plots_HARV

# plot data
plot(meanTreeHt_plots_HARV,
     main="MeanTree Height at each Plot\nNEON Harvard Forest Field Site",
     xlab="Plot ID", ylab="Tree Height (m)",
     pch=16)
dev.copy(png,'meanTreeHt_plots_HARV.png')
dev.off()

######## This is the end of Vector 05 ########

################################################################################################
### Additional questions for you to answer (10 Points Total): 

### What is spTransform? Answer in two sentences:
# Answer: In package "rgdal", spTransform is used for map projection and datum transformation.
#         In detail, the spTransform methods provide transformation between datum(s)
#         and conversion between projections.

### What is a RasterBrick? Answer in two sentences:
# Answer: RasterBrick is an object types can store multiple bands. A RasterBrick contains all of 
#         the objects stored within the actual R object, which is often more efficient and faster to process.

### What two ways can you perform raster calculations in R? What tool would you use in ArcGIS 
### to do the same thing?
# Answer: In R, we can perform raster calculation by 1) directly using raster math (+,-,*,/ operators etc.);
#         2)using the overlay() function when rasters are large and/or the calculations are complex.
#         In ArcGIS, we can use a tool named "Raster Calculator" to perform the same function.

### What can you use instead of TRUE or FALSE when it comes to 
### using logical (boolean) elements in R? One sentence:
# Answer: Use "T" to replace "TRUE" and use "F" to replace "FALSE".

### FCAT IS BACK: READ THINK EXPLAIN SHORT ANSWER PROMPT
### What is "Calle Ocho"?  # "Eighth Street"?
### Name the city, the street, and the celebration. # Florida?
### Why is it significant to this lab/the class/TA/just life in general? # em...not clear
###############################################################################################