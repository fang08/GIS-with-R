################################################################################################
######################################LAB_9#####################################################
################################################################################################
### SUBTITLE: TIME SERIES AREN'T MY WILL FORTE THOUGH 
### (i hated writing that as much as you hated reading that)

### Treat the answers/what I say in lecture as placeholders, you will need to look up 
### the functions and arguments asked of you more thoroughly for full  points 
install.packages("fpp")    # Data for Forecasting: principles and practice
install.packages("astsa")    # Applied Statistical Time Series Analysis
install.packages("dplyr")
install.packages("tidyr")    # Easily Tidy Data with spread() and gather() Functions
install.packages("ggplot2")
install.packages("forecast")    # Forecasting Functions for Time Series and Linear Models

### astsa is time series library you can explor if the topic interests you
library(fpp)
library(astsa)
library(dplyr)
library(tidyr)
library(ggplot2)
library(forecast)

### http://weecology.org/
### Comment on why we chose stringsAsFactors = FALSE in read.csv (5 Points)
ndvi<-read.csv(file = "portal_timeseries.csv", stringsAsFactors = FALSE)
head(ndvi)
# Answer: stringsAsFactors = FALSE prevent R from converting character strings into factors

###############################################################################################
##########################################PART_1###############################################
###############################################################################################
### What am I doing with the dollar sign here? Explain what start, stop, and frequency mean (5 Points)
ndvi_ts<- ts (ndvi$NDVI, start = c(1992, 3), end=c(2014, 11), frequency = 12)
# Answer: The dollar sign $ gets access to the column 'NDVI' in the ndvi file.
#         The function "ts" is used to create time-series objects.
#         'start' is the time of the first observation, either a single number or a vector of two integers. In our case it's March 1992.
#         'end' is the time of the last observation, specified in the same way as start. It's November 2014.
#         'frequency' is the number of observations per unit of time. 12 is monthly-based.

class(ndvi_ts)  # "ts"
start(ndvi_ts)  # 1992 3
end(ndvi_ts)  # 2014 11
plot(ndvi_ts)

### Extract that trend component using momomovinggg windows!
MA_m13<-ma(ndvi_ts, order=13, centre = TRUE)

MA_m61<-ma(ndvi_ts, order=61, centre = TRUE)
# "ma" function computes a simple moving average smoother of a given time series. Averaging eliminates some of
# the randomness in the data, leaving a smooth trend-cycle component.
# 'order' is the order of moving average smoother. If it's even, the observations averaged will include
# one more observation from the future than the past. In our case, order = 13 means one year and order = 61
# means 5 years.
#  If 'centre' is TRUE, the value from two moving averages are averaged, centering the moving average.

### In class Participation (and a real homework question)
### Describe what happens in the next three lines? (5 Points)
plot(ndvi_ts)
lines(MA_m13, col="blue", lwd=3)
lines(MA_m61, col="red", lwd=3)
# Answer: It first plot time series of NDVI (ndvi_ts);
#         "lines" function creates line charts and add them to the ndvi plot you have,
#         MA_m13 with the line color ('col') blue and line width ('lwd') 3 is plotted;
#         then MA_m61 with line color red and width 3 is plotted.
#         Notice that MA_m13 is smoothier than ndvi and MA_m61 is smoothier than MA_m13.

### In the lines below you will begin "mathing" (not real terminology please don't ever repeat that)
### What data types are ndvi_ts and MA_m13? (5 Points), do not just use the global environment, 
### figure it out programmatically (with a function we've learned)
seasonal_residual_m<- ndvi_ts-MA_m13
plot (seasonal_residual_m)
seasonal_residual_d<- ndvi_ts/MA_m13
plot(seasonal_residual_d)
# Answer: the data type of ndvi_ts and MA_m13 are both "ts" (time series).
class(ndvi_ts)
class(MA_m13)

### Tell me what the function decompose does. Why is it necessary when working with time series? (5 Points)
fit_add<- decompose(ndvi_ts, type = 'additive')
# Answer: the fundction "decompose" decomposes a time series into seasonal, trend and irregular components using moving averages.
#         The 'type' of decompose is the type of seasonal component. "additive" is a basic decomposition model,
#         it means 'Trend + Seasonal + Random' add them together.
#         Because time series comprises three components: a seasonal component, a trend-cycle component, and a remainder component,
#         thus using decompose function can help us learn each individual component.

plot(fit_add)
dev.copy(png,'decompose_ts.png')
dev.off()
### Export the plot (programmatically). I don't care what file format you choose

### And finally, you know the drill. What is stl, comment out each argument. What unit of time is this?
### 5 Points
fit_stl<-stl(ndvi_ts, t.window = 23, s.window = 7, robust = TRUE)
# Answer: "stl" function decomposes a time series into seasonal, trend and irregular components using loess, acronym STL.
#         Compare with "decompose", "stl" provides a much more sophisticated decomposition.
#         't.window' is the span (in lags) of the loess window for trend extraction, which should be odd.
#         's.window' is the span (in lags) of the loess window of the low-pass filter used for each subseries.
#         'robust' = TURE indicates robust fitting will be used in the loess procedure.
#         The unit of time is month (same with ndvi_ts).

### And export the plot (programmatically) for Five More Points
plot(fit_stl)
dev.copy(png,'stl_ts.png')
dev.off()

###############################################################################################
#################################################PART_2########################################
###############################################################################################

### Dollar sign, comment out what it means and what we're doing here (no existential answers)
### See symbols aren't so scary!!! (5 Points)
rain_ts<-ts(ndvi$rain, start = c(1992, 3), end = c(2014, 11), frequency = 12)
# Answer: we use "ts" function to create a time series. We use dollar sign to get access to column 'rain'.
#        The 'start' first observation is March 1992 and the 'end' last observation is November 2014,
#        and the 'frequency' is monthly-based observation frequency.

### Always check your work. Plotting is great for this! 
### Plus when your grandma gets a second grandson after 
### you were her only grandson for 15 years, then you can 
### export your plots and staple them to her refrigerator!
plot(ndvi_ts)
dev.copy(png,'ndvi_ts.png')
dev.off()

### meanf used in forecasting using average, sometimes it's the best you CAN do
### Same as usual, comment out the function mean_f, describe what fitted 
### and lines does (5 Points)
avg_model<- meanf(ndvi_ts)
lines(fitted(avg_model), col='red')
# Answer: "meanf" function is mean forecast, it returns forecasts and prediction intervals for an iid model applied to y.
#         "fitted" is a generic function which extracts fitted values from objects returned by modeling functions. 
#         "lines" function plot line chart on top of privious plot.

### Tell me what acf and pcf do
acf(ndvi_ts)
# Answer: The function "acf" computes and plots estimates of the autocovariance or autocorrelation function.
#         The confidence limits (blue dash) are provided to show when ACF or PACF appears to be significantly different from zero. 
#         In our plot, the acf of lag 0 is 1.0 because it's itself; it also has strong correlation with lag 0.1 (acf approx. 0.7),
#         and relative strong correlation with lag 1 and 2 (value 0.3), which means 1 year and 2 years before. The closerer to 
#         plus or minus one, the stronger correlation.
### one and two time steps back, and then a year and two years before. Use the acf to weight model
pacf(ndvi_ts)
# Answer: The function "pacf" computes and plots the partial autocorrelations function.
#         Pacf removes the effect of shorter lag autocorrelation from the correlation estimate at longer lags.
#         In our plot, the 0.1 lag has high parcial acf value (0.7, the same with acf) and it has relative high correlation
#         with lag 0.9 (1 year before, it didn't plot lag 0), which is the same in acf plot.
### weaker autocorrelation two time steps back

### Autoregressive model- a regression model using previous time steps as predictors
### Y(t) = c + b1Y(t-1)+b2Y(t-2)+e(t) FIIIIIIIIKKKKKKKKKKKKKKKK AHHHHHHHHHHHHHHHHHH 
### We will be using ARIMA, AR- autoregressive, (I) is the differencing part, moving average (MA) is 
### autocorrelation in errors, not in the values

### second lag 
### Music break. And tell me what Arima is/does in words other than my own ramblings (5 Points)
ar_model<-Arima(ndvi_ts, c(2, 0, 0))
# Answer: "Arima" function fits an ARIMA (autoregressive integrated moving average) model to a univariate time series.
#         'c(2,0,0)' is a specification of the non-seasonal part of the ARIMA model: the three integer components (p, d, q)
#         are the AR order (number of time lags), the degree of differencing (I), and the MA order.
#         In ARIMA, AR indicates that the evolving variable of interest is regressed on its own lagged values; I (integrated)
#         indicates that the data values have been replaced with the difference between their values and the previous values;
#         MA indicates that the regression error is actually a linear combination of error terms at various times in the past.
#         The model is fitted to time series data either to better understand the data or to predict/forecast future points in the series.
#         In our case, non-seasonal ARIMA(2,0,0)(could be seen as AR(2)) predicts values well except for missing some peak
#         and trough values. But it predict the trends well (see red line in plot).

plot(ndvi_ts)
lines(fitted(ar_model), col='red')
### drivers at low points of NDVI could be improved but this looks great so far

### Look at this line and the structure of the parentheses. Tell me what function resid does
### Write a line of code where you would get the same answer but it's not as efficient
### Five Points
plot(resid(ar_model))
# Answer: "resid" is a generic function which extracts model residuals from objects returned by modeling functions.
residual_ar<- resid(ar_model)
plot(residual_ar)

### good news is that there is less structure to these residuals, the bad news is it's not solely
### white noise, there is still some structure here

### should suck up all two time step autocorrelation
acf(resid(ar_model))
pacf(resid(ar_model))

### seasonality in the one and two year lag, let's include that next in a new ARIMA model
### y(t)=c + b1Y(t-1) + b2Y(t-2)+ b3Y(t-12) + b4Y(t-24) + e(t)

seasonal_ar<-Arima(ndvi_ts, c(2, 0, 0), seasonal = c(2, 0, 0))
plot(ndvi_ts)
# 'seasonal' is a specification of the seasonal part of the ARIMA model, plus the period (which defaults to frequency(x)).
# A specification of a numeric vector of length 3 will be turned into a suitable list with the specification as the order.

### the seasonal ARIMA is getting closer at the troughs 
lines(fitted(seasonal_ar), col='red')
lines(fitted(ar_model), col='blue')

acf(resid(seasonal_ar))
pacf(resid(seasonal_ar))

###now build in auto-arima, with seasonality turned off
### ooo new function, what does auto.arima do? (5 Points)
arima_model<- auto.arima(ndvi_ts, seasonal = FALSE)
# Answer: "auto.arima" function fits best ARIMA model to univariate time series, it returns 
#         best ARIMA model according to either AIC, AICc or BIC value.
#         If 'seasonal' = FALSE, it restricts search to non-seasonal models.
plot(ndvi_ts)
### Did I break the lab computer, will I have to flee the country? 
lines(fitted(arima_model), col='red')
lines(fitted(ar_model), col='blue')
# Notice that two line charts almost completely overlap with each other, which means the best ARIMA
# model is actually (2,0,0).

### now add seasonal to it 
arima_model<- auto.arima(ndvi_ts, seasonal = TRUE)  # turn seasonal on
arima_model
### takes the form of: y(t)=c + b1Y(t-1) + b2Y(t-2)+ b3Y(t-12) + b4Y(t-24) + b5(et-1) + e(t)

### now add rain, an external covariate directly into the ARIMA, x reg is list of values of rain
### this is an exogenous, dynamic arima, it gives us the proper estimate between rain and ndvi
### correcting for autocorrelation. This line (is) NASA Lab:

rain_am<-auto.arima(ndvi_ts, xreg = rain_ts)
plot(ndvi_ts)
# 'xreg' argument is a vector or matrix of external regressors, which must have the same
# number of rows as y.

### not such a big improvement but still interesting 
lines(fitted(rain_am), col= 'blue')   # add rain
lines(fitted(arima_model), col ='red')  # seasonal best-fit ARIMA

##############################################################################################
#################################################PART_3#######################################
##############################################################################################

### one of the most common ways to evaluate forecasts is evaluating the steps used to make the 
### forecasting using hindcasting, take existing time series, cut it in two and see how well it does

### this is a special case of cross-validation, when we fit a model to some data, the model can 
### overfit the data which is not representative of the process, picking up on idiosynchronies
### not the actual structure of the data, 

### Window, describe what it is in this context. (5 Points)
### Look at the time period of the training versus the testing dataset.
ndvi_train<- window(ndvi_ts, end= c(2009, 11))
ndvi_test<- window(ndvi_ts, start= c(2009, 12))
# Answer: "window" function extracts the subset of the object x observed between the times start and end.
#         'start' is the start time of the period of interest (in our case, December 2009).
#         'end' is the end time of the period of interest (in our case, Novermber 2009).
#         So the train set is 1992.03(default)-2009.11 and test set is 2009.12-2014.11(default).

### Check if it worked using a certain built-in function that checks for length
length(ndvi_train)  #213
length(ndvi_test)   #60

### And for 3.7 points, one of your supplemental readings
### https://motherboard.vice.com/en_us/article/bless-the-man-who-trained-ai-to-identify-pokemon-type
### Aside from your TA being in a state of arrested development (excellent show btw), 
### why did I include this reading (look at their training/testing partition). 
# Training/testing method is widely used in research like AI or machine learning.
### Why is this partition newsworthy?
# Because it's pokemon! It's interesting.
### And if you're a fan, up to what pokemon generation do you acknowledge as real?
# ...7??

arima_model<- auto.arima(ndvi_train, seasonal = FALSE)  # turn off seasonal
### Tell me what forecast does including what h does and why it's 60. 
### TRICKY QUESTION, LOOK BACK TO YOUR LENGTHS
arima_forecast<- forecast(arima_model, h = 60)
plot(arima_forecast)
# Answer: "forecast" function forecasts time series or time series models.  The function invokes
#         particular methods which depend on the class of the first argument.
#         'h' is the number of periods for forecasting. It is 60 because we run length(ndvi_test)
#         previously and the result is 60.
#         In our plot, the forecasts are shown as a blue line, with the 80% prediction intervals as an dark grey 
#         shaded area, and the 95% prediction intervals as a light grey shaded area. The function predicts ok 
#         at the very beginning of test period, but later it just gives us the mean value (straight line).

### throw hold-out data onto the graph and see how we think it looks using lines
lines(ndvi_test, col = 'red')
### most are within the 95% prediction interval, some outside, but this is a good starting point
### to visualize things


plot(arima_forecast$mean, ndvi_test) # lines connect with each other with year label
### this is the default 

### Boom look at your coercive friend as.vector, what's up, as.vector?
### Tell me what we do in the line below and why we did it
plot(as.vector(arima_forecast$mean), as.vector(ndvi_test))
# Answer: "as.vector" method coerces its argument into a vector of a specified mode,
#         the default is to coerce to whichever vector mode is most convenient.
#         Here we coerce arima_forecast' mean and ndvi_test into numeric, which makes it
#         easier to be plotted and more meaningful and readable.
class(as.vector(arima_forecast$mean)) # numeric
class(as.vector(ndvi_test)) # numeric
# Notice the nodes concentrate as a vertical line at mean value (0.79), which coincide with forecast plot (blue line).


### And boom, what does accuracy do, describe the arguments annd why we need both/why they're in the order they are in
accuracy(arima_forecast, ndvi_test)
# Answer: "accuracy" function returns range of summary measures of the forecast accuracy, which could be
#         denoted as accuracy(f, x, ...). 'f' must be an object of class "forecast", or a numerical vector 
#         containing forecasts. That's why we use as.vector first to convert arima_forecast into numberical vector.
#         If 'x' is provided, the function measures out-of-sample (test set) forecast accuracy based on x-f.
#         (if not provided, only produces in-sample (training set) accuracy measures of the forecasts)


##############################now do seasonal###################################################
### now lets model a seasonal arima model on the training
### Make sure the first time you defined auto.arima that 
### you desribed the seasonal argument, if not you can do so below:
### Make sure to keep track of what you assigned the seasonal TRUE and seasonal FALSE arimas to
### It's fine if you overwrote the names as long as you keep track of it. However, if we are
### to foster a collaborative environment (blah blah blah) use meaningful names and don't overwrite. 
### The person reading your code can be a complete dummy (like your TA) and not see what's going on

arima_model<- auto.arima(ndvi_train, seasonal = TRUE) # turn seasonal on
arima_forecast<- forecast(arima_model, h = 60) 
plot(arima_forecast)
# Notice the blue line predicts the seasonal trend and the prediction intervals also show seasonal characteristics.
# This looks much better than the mean value one above.

### throw hold-out data onto the graph and see how we think it looks using lines
lines(ndvi_test, col = 'red')

plot(arima_forecast$mean, ndvi_test)

plot(as.vector(arima_forecast$mean), as.vector(ndvi_test))
# Notice the plot is not concentrated on the mean value any more. If create a diagonal line from 0 to 1,
# most of nodes are below the line. The plot reflects the forecast model.

### how do we quantify fit of data to models? needs forecast, and the test data, respectively
### in most programming languages, order is critical. 
accuracy(arima_forecast, ndvi_test)

### right idea of seasonal signal but can't continue on for a while because of the noise,
### gradually it washes out and decays to the average at the end (forecast from previous forecast)
### confidence intervals expand at the tail ends, let's see if the quality falls off

### calculate rmse for each future data point
### Notice the parentheses, the math going on. It's beautiful 
RMSE<- sqrt((arima_forecast$mean - ndvi_ts)^2)

### What is the data class of RMSE?
class(RMSE)
# Answer: It's time series (ts).
### time series of individual point value errors
RMSE
plot(RMSE) # difference between real values and predicted values

arima_accur<-accuracy (arima_forecast, ndvi_test)
arima_accur
### We haven't done this before. What is the square bracket doing, why the comma, why the 2,
### what is the data.frame line doing (5 Points)
data.frame(arima = arima_accur[2,]) 
# Answer: "data.frame" function creates data frames, tightly coupled collections of variables which share many of 
#         the properties of matrices and of lists.
#         The argument 'tag = value' which tag is the component name (arima) and arima_accur[2,] are the values.
#         The square bracket [] specifies the column(s)/row(s) we want to use. In this case, only the second row (Test set) 
#         is used (with all columns). 2 is the row and comma separate the column and row.

plot(arima_forecast)
lines(ndvi_test) # real values

### manually check whether it's in there or not, below is a matrix, pick out second column
### keep ot within the bounds
arima_forecast
### And finally, some new formatting, dissect this line (5 Points)
in_interval<- arima_forecast$lower[,2]<ndvi_test & arima_forecast$upper[,2] > ndvi_test
# Answer: First the logic operator "&" (AND) connect two elements, they must be both true in our case.
#         $lower[,2] is the lower bound of 95% prediction intervals and $upper[,2] is the upper bound.
#         Therefore, 'arima_forecast$lower[,2]<ndvi_test' means the ndvi test values (real values) are
#         higher than the lower bound; 'arima_forecast$upper[,2] > ndvi_test' means test values are 
#         lower than the upper bound. Together it means the test values within 95% prediction intervals.
#         The result is a time series contains TRUE or FALSE values.
in_interval  # only three FALSE

### And this line 5 Points 
coverage<- sum(in_interval)/length(ndvi_test)
# Answer: sum(in-interval) gives us the number of TRUE values in in_interval and length(ndvi_test) is the
#         total numbers of test set (should be 60). Therefore the coverage represents the percentage of
#         test values (real values) fall within the 95% prediction intervals.
coverage  # 57/60 = 0.95

### Tell me what data classes each are and plot each of them. Relating to your final projects, what
### can you see yourself replicating with the in_interval and coverage lines? (5 Points)
class(in_interval) # ts (time series)
class(coverage) # numeric
# This method could be used in land use to filter the land cover type we need and calculate
# the percentage of land we select.

##############################################################################################