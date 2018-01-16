###################################################################################################
### Working with Vector Data in R
###
### Tutorial 00 and 04
### http://neondataskills.org/R/open-shapefiles-in-R/
### http://neondataskills.org/R/csv-to-shapefile-R/
### Part of the series
### http://neondataskills.org/tutorial-series/vector-data-series/

### After this lab you will be introduced to two other vector data types
### And start using read and write OGR for vector shapefiles

### Any general questions about Lab 5? 
### We can live code them! You can ask them during the break too!
### Let's go over some code presented by William Shatner Kessler last class:

# one of the sister functions of coercion (we've used this group before)
### cichlids<-as.data.frame(cichlids)
# note the == operator we learned 
### GGGG<-filter(cichlids, Species == "Ghanaian Gambusia Giganticusii Grande")
# once you set the coordinates, you cannot change them in the same session
### coordinates(GGGG)<-c("Longitude", "Latitude")
# make sure you install and load spplot
### spplot(GGGG, "Species")
# meaningful name, Mighty Sparrow is timeless
### dev.print(pdf, 'oneofthem.pdf') 

### Last night...it happened... The thing I'm always warning you about... 
### After two hours of living dangerously, and not saving often... I lost everything...
### Stuck in R auto-pilot, instead of closing a script I was done with, I closed the 
### whole thing, disregarding the warning boxes telling me not to...
### All the jokes, all the comments, everything. So... Learn from my mistake...

### Your Lab 6 this week is to complete most of Tutorial 00 and all of Tutorial 04
### EXCEPT the last challenge "Plot Raster & Vector Data Together"

## Lab 6 OGR (see tutorial 00)
# First, install and load all the packages we need
install.packages("rgdal")  # for vector work; sp package should always load with rgdal
#install.packages("sp")  # because I already installed in my computer
install.packages("raster")  # for metadata/attributes- vectors or rasters
library(sp)
library(rgdal)
library(raster)

# Import a polygon shapefile: readOGR("path","fileName"). no extension needed as readOGR only imports shapefiles
# Please note to give the full address of file path and use '/' instead of '\'.
aoiBoundary_HARV <- readOGR("C:/Users/Fang/Desktop/GIS6938/Yao_week6/HARV",
                            "HarClip_UTMZ18")

# view just the class for the shapefile
class(aoiBoundary_HARV)
# view just the crs (Coordinate Reference System) for the shapefile
crs(aoiBoundary_HARV)
# view just the extent for the shapefile
extent(aoiBoundary_HARV)
# view all metadata at same time
aoiBoundary_HARV
# alternate way to view attributes 
aoiBoundary_HARV@data
# view a summary of metadata & attributes associated with the spatial object
summary(aoiBoundary_HARV)

# create a plot of the shapefile
# 'lwd' sets the line width, 'col' sets internal color, 'border' sets line color
#  use main="" to give our plot a title
plot(aoiBoundary_HARV, col="cyan1", border="black", lwd=3,
     main="AOI Boundary Plot")

# Now Challenge: Import Line and Point Shapefiles
# import the HARV_roads and HARVtower_UTM18N layers
lines_HARV <- readOGR("C:/Users/Fang/Desktop/GIS6938/Yao_week6/HARV",
                            "HARV_roads")
point_HARV <- readOGR("C:/Users/Fang/Desktop/GIS6938/Yao_week6/HARV",
                      "HARVtower_UTM18N")

# Answer the following questions:

# 1. What type of R spatial object is created when you import each layer?
# Answer: HARV_roads is line spatial object, and HARVtower_UTM18N is point spatial object
class(lines_HARV)
class(point_HARV)
# lines_HARV object is a line of class SpatialLinesDataFrame,
# and point_HARV is a point of class SpatialPointsDataFrame

# 2. What is the CRS and extent for each object?
# Answer:
crs(lines_HARV)
extent(lines_HARV)
# +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0
# the CRS of lines_HARV is UTM Zone18, datum WGS84
# the extent of line_HARV is below:
# class       : Extent 
# xmin        : 730741.2 
# xmax        : 733295.5 
# ymin        : 4711942 
# ymax        : 4714260
crs(point_HARV)
extent(point_HARV)
# +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0
# the CRS of point_HARV is UTM Zone18, datum WGS84
# the extent of point_HARV is below:
# class       : Extent 
# xmin        : 732183.2 
# xmax        : 732183.2 
# ymin        : 4713265 
# ymax        : 4713265

# 3. Do the files contain, points, lines or polygons?
summary(lines_HARV)
summary(point_HARV)
# HARV_roads file has lines (Object of class SpatialLinesDataFrame), 
# while HARVtower_UTM18N file has points (Object of class SpatialPointsDataFrame).

# 4. How many spatial objects are in each file?
length(lines_HARV)
length(point_HARV)
# Answer: lines_HARV has 13 line spatial objects
#         point_HARV has 1 point spatial object

# Plot multiple shapefiles
# 'col' sets internal color, "pch=" option to specify symbols (node, square, asterisk...) to use when plotting points.
# use 'add = TRUE' argument to overlay shapefiles on top of each other
# use main="" to give our plot a title, use \n where the line should break
plot(aoiBoundary_HARV, col = "lightgreen", 
     main="NEON Harvard Forest\nField Site")
plot(lines_HARV, add = TRUE)
# use the pch element to adjust the symbology of the points
plot(point_HARV, add  = TRUE, pch = 19, col = "purple")

# using dev.print to export file
dev.print(pdf, 'NEON Harvard Forest Field Site.pdf')


## Tutorial 04:
# Read the .csv file
# stringsAsFactors=FALSE means our data import as a character rather than a factor class.
plot.locations_HARV <- read.csv("HARV/HARV_PlotLocations.csv",
                                stringsAsFactors = FALSE)
# look at the data structure
str(plot.locations_HARV)
# view column names
names(plot.locations_HARV)

# view first 6 rows of the X and Y columns
head(plot.locations_HARV$easting)
head(plot.locations_HARV$northing)
# note that you can also call the same two columns using their COLUMN NUMBER
head(plot.locations_HARV[,1])
head(plot.locations_HARV[,2])

# view first 6 rows of metadata
head(plot.locations_HARV$geodeticDa)
head(plot.locations_HARV$utmZone)

# create an crs object
utm18nCRS <- crs(lines_HARV)
utm18nCRS
class(utm18nCRS)

# convert our data.frame into a SpatialPointsDataFrame
# note that the easting and northing columns are in columns 1 and 2
# proj4string is used to assign Coordinate Reference System
plot.locationsSp_HARV <- SpatialPointsDataFrame(plot.locations_HARV[,1:2],  # specify X(easting) and Y(northing) coordinate values
                                                plot.locations_HARV,    # the R object to convert
                                                proj4string = utm18nCRS)   # assign a CRS 
# look at CRS
crs(plot.locationsSp_HARV)

# plot spatial object
plot(plot.locationsSp_HARV, main="Map of Plot Locations")
# export the plot as a pdf
dev.print(pdf, 'Map of Plot Locations.pdf')

# plot Boundary
plot(aoiBoundary_HARV,
     main="AOI Boundary\nNEON Harvard Forest Field Site")
# add plot locations
plot(plot.locationsSp_HARV, 
     pch=8, add=TRUE)
# export the plot as a pdf
dev.print(pdf, 'AOI Boundary.pdf')

# aoiBoundary_HARV and plot.locationsSp_HARV have different extent to plot,
# we have to manually assign the plot extent using 'xlim' and 'ylim'
# 'xlab' gives a title for the x axis, 'ylab' gives a title for the y axis
plot(extent(plot.locationsSp_HARV),  # plot the extent boundrary
     col="purple", 
     xlab="easting",
     ylab="northing", lwd=8,
     main="Extent Boundary of Plot Locations \nCompared to the AOI Spatial Object",
     ylim=c(4712400,4714000)) # extent the y axis to make room for the legend

plot(extent(aoiBoundary_HARV),  # plot the extent boundrary
     add=TRUE,
     lwd=6,
     col="springgreen")

# legend function add legends to plots
# "bottomright" set the location of legend by setting x to a single keyword
# optional inset argument specifies how far the legend is inset from the plot margins
# 'legend = ' sets the text of the legend
# 'bty' sets the type of box to be drawn around the legend ("o" has box and "n" has none)
# 'col' sets the color; 'cex' sets character expansion factor (similar to the size)
# 'lty' set the type of lines to illustrate, 'lwd' sets line width in units of character
legend("bottomright",
       #inset=c(-0.5,0),
       legend=c("Layer One Extent", "Layer Two Extent"),
       bty="n", 
       col=c("purple","springgreen"),
       cex=.8,
       lty=c(1,1),
       lwd=6)

# export the plot as a pdf
dev.print(pdf, 'Boundary comaprison.pdf')

# in order to plot different extent of layers together
# create an extent object
plotLoc.extent <- extent(plot.locationsSp_HARV)
plotLoc.extent
# grab the x and y min and max values from the spatial plot locations layer
xmin <- plotLoc.extent@xmin
xmax <- plotLoc.extent@xmax
ymin <- plotLoc.extent@ymin
ymax <- plotLoc.extent@ymax
# adjust the plot extent using xlim (x extent) and ylim (y extent)
plot(aoiBoundary_HARV,
     main="NEON Harvard Forest Field Site\nModified Extent",
     border="darkgreen",  #'border' sets line color
     xlim=c(xmin,xmax),
     ylim=c(ymin,ymax))

plot(plot.locationsSp_HARV, 
     pch=8,
     col="purple",
     add=TRUE)

# add a legend
legend("bottomright", 
       legend=c("Plots", "AOI Boundary"),
       pch=c(8,NA),  # set point type
       lty=c(NA,1),  # set line type
       bty="n", 
       col=c("purple","darkgreen"),
       cex=.8)

# use lab 5 code to save as pdf file
dev.print(pdf, 'Harvard Forest Field Site Modified Extent.pdf')

# write a shapefile
# you need the name of the spatial object, the directory where we want to save
# use getwd() to get current working directory
# the name of the new shapefile, and the 'driver' which specifies the file format
writeOGR(plot.locationsSp_HARV, getwd(),
         "PlotLocations_HARV", driver="ESRI Shapefile")
# will export .shp .shx .dbf .prj files

### 40 Points
### Answer all of the questions asked of you in "Import Line and Point Shapefiles"
### Follow the structure of the code before to bring in the point and line shapefile into R
### We will import the polygon shapefile together since R and OGR can be tricky
### Answer all of the questions in Tutorial 004 EXCEPT "Challenge-Import & Plot Additional Points"
### wE WILL NOT BE WORKING WITH PHENOLOGY DATA YET

### 50 Points
### Comment out every line of code already provided to you in the tutorials.
### I expect every non-base/built-in function and its argument(s) to be #commented out. 
### When looking through the code provided, look for alternative ways we've
### covered in class where you could get the same answer.

### 10 Points
### Using your Lab 5 code for saving off plots, in the "Plot Multiple Shapefiles" section,
### export the "NEON Harvard Forest Field Site" plot as a .png file using dev.print.
### Include this plot in the folder you submit containing your code and comments.
### All plots from Tutorial 04 should also be saved off as .pngs using your code from Lab 5
### In Tutorial 04 "Export a Shapefile" save your shapefile off in your project folder.
### Make sure you have all plots (check them to make sure they plotted okay)
### and shapefiles you've created in your week 6 submission 
### And please, learn from me, save your work. 
