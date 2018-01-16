########## Land Use Suitability Analysis ##########
######### Fang Yao GIS 6938 Final project #########

### Install libraries/packages needed
install.packages("sp")
install.packages("rgdal")
install.packages("rgeos")
install.packages("raster")
install.packages("dplyr")
install.packages("ggplot2")
install.packages("rasterVis")
install.packages("RColorBrewer")

library(sp)
library(rgdal)
library(rgeos)
library(raster)
library(dplyr)
library(ggplot2)
library(rasterVis)
library(RColorBrewer)

### Step 1: Load vector and raster data into R ###
### check their features and plot out
## import alachua county boundary (polygon)
Alachua_Boundary <- readOGR(".","cntbnd01")  # "." means current directory
crs(Alachua_Boundary)
extent(Alachua_Boundary)
class(Alachua_Boundary)
plot(Alachua_Boundary, col="lightyellow", border="black", lwd=2,
     main="Alachua County Boundary")

## import schools data in Florida (point)
Schools_FL <- readOGR(".","gc_schools_jul08")
crs(Schools_FL)
extent(Schools_FL)
class(Schools_FL)
plot(Schools_FL, col="navy", pch = 19, cex = .6, main="Schools in Florida")

## import major roads data in Florida (line)
MajorRoads_Ala <- readOGR(".","majrds_feb10_Ala")
crs(MajorRoads_Ala)
extent(MajorRoads_Ala)
class(MajorRoads_Ala)
plot(MajorRoads_Ala, col="darkorange", lwd = 1, 
     main="Major Roads in Alachua County")

## import drainage data in Alachua (polygon)
Drainage_Ala <- readOGR(".","nrcs_soils01", stringsAsFactors=FALSE)  # "stringsAsFactors=FALSE" for replacing the value in step 2
crs(Drainage_Ala)
extent(Drainage_Ala)
class(Drainage_Ala)
Drainage_Ala$DRAINAGECL
plot(Drainage_Ala, col="khaki", lwd = 1, main="Drainage in Alachua County")

## import slope data in Alachua (raster)
Slope_Ala <- raster("slope", resolution = 30)
crs(Slope_Ala)
extent(Slope_Ala)
class(Slope_Ala)
res(Slope_Ala)  # 30x30
ncol(Slope_Ala)
nrow(Slope_Ala)
plot(Slope_Ala, main="Slope of Alachua County")


### Step 2: Spatial analysis ###
### transfer data into rasters with proper values

## because of different resources of data, some of them are state-wide
## and others are county-wide
## we need to 'clip' them within county boundary

# create the clipping polygon
CP <- as(extent(Alachua_Boundary), "SpatialPolygons")
proj4string(CP) <- CRS(proj4string(Alachua_Boundary))
# clip the map (schools)
Schools_Ala <- gIntersection(Schools_FL, CP, byid=TRUE)
extent(Schools_Ala)
plot(Alachua_Boundary, col="lightyellow", border="black", lwd=2, main="Alachua County")
plot(Schools_Ala, add  = TRUE, pch = 19, col = "navy")

# create Euclidean Distance of schools
# first create a raster base (county boundary)
Ala_Bound_raster <- rasterize(Alachua_Boundary, Slope_Ala, field = 0)  # takes 2 mins to run
extent(Ala_Bound_raster)
class(Ala_Bound_raster)
res(Ala_Bound_raster)
plot(Ala_Bound_raster, main="Alachua County Rasterized")
# then assign new values (distances) to raster
Schools_ED <- distanceFromPoints(Ala_Bound_raster, Schools_Ala)
plot(Schools_ED, main="School Distances")


# create Euclidean Distance of major roads
# first create a raster base with proper crs, extent and resolution
Roads_ED <- raster(extent(Alachua_Boundary),res = c(30,30))
proj4string(Roads_ED) <- CRS(proj4string(Alachua_Boundary))
crs(Roads_ED)
show(Roads_ED)

# convert to points
SP = as(Roads_ED,"SpatialPoints")
# use rgeos for distance calculation
require(rgeos)
# previously merge all roads to a single feature for faster calculation (takes 8 mins to run)
d = gDistance(SP, MajorRoads_Ala, byid=TRUE)
# check dimension
dim(d) # 1 3843054, 1 line feature and 3843054 points
# find the minimum point-to-line distance
dmin = apply(d,2,min)
# stick values in the base raster
Roads_ED[] <- dmin
plot(Roads_ED, main="Major Roads Distances")
writeRaster(Roads_ED, "MajorRoadDist.tiff",
            format="GTiff",  # specify output format - GeoTIFF
            overwrite=TRUE,
            NAflag=-9999) # set no data value to -9999
# for next time: could import previous saved raster (save time)
# Roads_ED <- raster("MajorRoadDist.tiff", resolution = 30)

# prepare drainage values of suitability (1-9)
# Replace the data in a field based on equal to some value (remember stringsAsFactors=FALSE)
Drainage_Ala$DRAINAGECL  # before
Drainage_Ala$DRAINAGECL[Drainage_Ala$DRAINAGECL == "VERY POORLY DRAINED"] <- 1
Drainage_Ala$DRAINAGECL[Drainage_Ala$DRAINAGECL == "POORLY DRAINED"] <- 2
Drainage_Ala$DRAINAGECL[Drainage_Ala$DRAINAGECL == "SOMEWHAT POORLY DRAINED"] <- 3
Drainage_Ala$DRAINAGECL[Drainage_Ala$DRAINAGECL == "MODERATELY WELL DRAINED"] <- 5
Drainage_Ala$DRAINAGECL[Drainage_Ala$DRAINAGECL == "WELL DRAINED"] <- 7
Drainage_Ala$DRAINAGECL[Drainage_Ala$DRAINAGECL == "EXCESSIVELY DRAINED"] <- 9
Drainage_Ala$DRAINAGECL[is.na(Drainage_Ala$DRAINAGECL)] <- 0
Drainage_Ala$DRAINAGECL # after
class(Drainage_Ala$DRAINAGECL) # character
Drainage_Ala$DRAINAGECL <- as.numeric(Drainage_Ala$DRAINAGECL)
Drainage_Ala$DRAINAGECL # to numeric
class(Drainage_Ala$DRAINAGECL) # numeric


### Step 3: Reclassify cell values in all raster data ###
### rasterize data if vectors

# reclassify school distance values with 1-9 suitability
# mask raster value within county boundary
re_school <- mask(x=Schools_ED, mask=Ala_Bound_raster)
plot(re_school)
minValue(re_school)
maxValue(re_school)
# matrix for reclassification
rcl1 <- c(0, 900, 9,  900, 1800, 8,  1800, 2700, 7,  2700, 3600, 6,
        3600, 4500, 5,  4500, 5400, 4,  5400, 6300, 3,  6300, 7200, 2,
        7200, maxValue(re_school), 1) # quantile method
re_school <- reclassify(re_school, rcl1)
plot(re_school, main="School Distance Suitability (1-9)")

# reclassify major road distance values with 1-9 suitability
re_road <- mask(x=Roads_ED, mask=Alachua_Boundary)
plot(re_road)
minValue(re_road)
maxValue(re_road)
rcl2 <- c(0, 110, 9,  110, 250, 8,  250, 450, 7,  450, 640, 6,
        640, 890, 5,  890, 1200, 4,  1200, 1600, 3,  1600, 2300, 2,
        2300, maxValue(re_road), 1) # quantile method
re_road <- reclassify(re_road, rcl2)
plot(re_road, main="Major Road Distance Suitability (1-9)")

# reclassify drainage values with 1-9 suitability
# previous has been classified (1-9), need rasterize according to drainage values
# takes more than 10 mins to run
re_drainage <- rasterize(Drainage_Ala, Ala_Bound_raster, field = "DRAINAGECL")
plot(re_drainage, main="Drainage Condition Suitability (1-9)")
writeRaster(re_drainage, "ReclassDrainage.tiff",
            format="GTiff",  # specify output format - GeoTIFF
            overwrite=TRUE,
            NAflag=-9999) # set no data value to -9999
# for next time: could import previous saved raster (save time)
# re_drainage <- raster("ReclassDrainage.tiff", resolution = 30)

# reclassify slope values with 1-9 suitability
minValue(Slope_Ala)
maxValue(Slope_Ala)
rcl3 <- c(0, 0.358, 9,  0.358, 1.195, 8,  1.195, 1.912, 7,  1.912, 2.748, 6,
       2.748, 3.824, 5,  3.824, 5.138, 4,  5.138, 7.289, 3,  7.289, 14.698, 2,
       14.698, maxValue(Slope_Ala), 1) # natural break
re_slope <- reclassify(Slope_Ala, rcl3)
crs(re_slope)
show(re_slope)
plot(re_slope, main="Slope Condition Suitability (1-9)")

# Unify their extent and resolution
extent(re_school)
extent(re_road) <- extent(re_school)
extent(re_road)
extent(re_drainage)
extent(re_slope)

res(re_school)
res(re_road)
res(re_drainage)
res(re_slope)


### Step 4: Calculate final suitability with weight ###

## create a function, assume the same weight to all raster data
reclassification <- function(raster1, raster2, raster3, raster4)
{ 
  result = raster1*0.25 + raster2*0.25 + raster3*0.25 + raster4*0.25
  return(result)
}

# calculate the final suitability and its statistics
re_all <- reclassification(re_school, re_road, re_drainage, re_slope)
minValue(re_all)
maxValue(re_all)
writeRaster(re_all, "Summary_classify.tiff",
            format="GTiff",  # specify output format - GeoTIFF
            overwrite=TRUE,
            NAflag=-9999) # set no data value to -9999
# for next time:
# re_all <- raster("Summary_classify.tiff", resolution = 30)

# check the histogram of suitability values
re_hist<- hist(re_all,
               maxpixels=ncell(re_all), # Histogram Default: 100,000 pixels
               main="Distribution of Suitability Values in Alachua County",
               xlab="Suitability values",
               ylab="Frequency",
               col="springgreen4")
re_hist$breaks
re_hist$counts
plot(re_all, main="Summary Suitability (1-9)")


### Step 5: Data analysis ###

## import parcel data for comparison
Alachua_Parcels <- readOGR(".","Alachua_parcels_14", stringsAsFactors=FALSE)
crs(Alachua_Parcels)
crs(Alachua_Boundary)
# plot(Alachua_Parcels, main="All Parcels in Alachua County") # takes more than 20 mins

class(Alachua_Parcels)
str(Alachua_Parcels)
Alachua_Parcels$OCITY
# Due to large size of data, only select parcels in Gainesville city as an example
Gainesville_parcels <- Alachua_Parcels[which(Alachua_Parcels$OCITY == "GAINESVILLE"),]
plot(re_all, main="All Parcels in Gainesville")
plot(Gainesville_parcels, add = TRUE)
length(Gainesville_parcels) # 59615
# save as shapefile for next time use
writeOGR(Gainesville_parcels, getwd(),
         "Gainesville_parcels", driver="ESRI Shapefile")
# for next time:
# Gainesville_parcels <- readOGR(".","Gainesville_parcels")

# calculate the average suitability values in each parcel (takes 20mins or more)
stats_extract <- extract(x = re_all, 
                         y = Gainesville_parcels,
                         fun=mean, 
                         df=TRUE)
# use zonal function but get a different number of variables as Gainesville_parcels
# zonal_stats <- zonal(re_all, Gain_Parcel_raster, mean, digits=2)

# save for next time use
write.csv(stats_extract, file = "stats_extract.csv", row.names = FALSE)
tail(stats_extract[,2]) # test the results

# add a new column (not necessary)
# mutate(Gainesville_parcels, suitability = stats_extract[,2])

# find parcels land use type is residential (TRUE) and suitability value larger than 5 (good suitability)
goodChoice <- Gainesville_parcels$IsResident == "T" & stats_extract[,2] > 5
class(goodChoice) # logical
length(goodChoice) # same as parcel data 59615

# how many residential parcels have good suitability for residential land use
length(which(goodChoice==TRUE))  # 42901
length(which(Gainesville_parcels$IsResident == "T"))

# calculate the percentage
percentage <- length(which(goodChoice==TRUE)) / length(which(Gainesville_parcels$IsResident == "T"))
percentage  # 84.45%


### Step 6: Data visualization ###
### to make it looks better

## plot the final results of suitability values (after recalssification)
colr <- colorRampPalette(brewer.pal(11, 'RdYlBu'))
levelplot(re_all, 
          main=list("Suitability Values for Alachua County",
            side=1,line=0.5, cex= 1.5),       # title
          margin=FALSE,                       # suppress marginal graphics
          colorkey=list(
            space='bottom',                   # plot legend at bottom
            labels=list(at=0:9, font=4),      # legend ticks and labels
            axis.line=list(col='black')
          ),    
          par.settings=list(
            axis.line=list(col='transparent') # suppress axes and legend outline
          ),
          scales=list(draw=FALSE),            # suppress axis labels
          col.regions=colr,                   # colour ramp
          at=seq(0, 9, len=101)) +            # colour ramp breaks
          layer(sp.polygons(Alachua_Boundary, lwd=2))    # add boundary


### Useful links:
# https://gis.stackexchange.com/questions/233443/finding-distance-between-raster-pixels-and-line-features-in-r/233493
# http://rprogramming.net/recode-data-in-r/
# http://www.theanalysisfactor.com/r-tutorial-recoding-values/
# https://gis.stackexchange.com/questions/20415/how-to-select-a-subset-of-polyset-data-in-r
# http://stackoverflow.com/questions/33227182/how-to-set-use-ggplot2-to-map-a-raster
# https://cran.r-project.org/web/packages/raster/raster.pdf
# https://cran.r-project.org/web/packages/rgeos/rgeos.pdf

