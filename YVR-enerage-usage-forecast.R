## ------------------------------------------------------------------
library(fpp2) # load the Forecasting: Principles and Practice package, as well as all its dependencies
library("corrplot")
# library("PerformanceAnalytics")
library("RColorBrewer")
library("dplyr")
library("tidyr")
library("tidyverse")
library("car")
YVR_rawdata <- read.csv(file = 'Energy use at YVR.csv')
head(YVR_rawdata)


## ------------------------------------------------------------------
ts_YVRdata <- ts(data = YVR_rawdata[,2], start = c(1997,01,01) , end = c(2010,12,31), frequency = 12)
ts_YVRdata


## ------------------------------------------------------------------
options(repr.plot.width=12, repr.plot.height=8)
autoplot(ts_YVRdata, 
         xlab = "Year",
         ylab="Energy usage measured in thousands \n of  kilowatt per hours (kWh)") +
theme(text = element_text(size = 20), plot.title = element_text(hjust = 0.5, size=30)) +
ggtitle("Energy usage vs Time") 


## ------------------------------------------------------------------
lambda <- BoxCox.lambda(ts_YVRdata)
lambda
par(mfrow=c(2,1), mar=c(4,4,4,1))
plot(ts_YVRdata, ylab="Original Energy usage (kWh)", xlab="Year", main="Original Energy usage (kWh)")
plot(BoxCox(ts_YVRdata,lambda), ylab="Transformed Energy usage (kWh)",
     xlab="Year", main="Box-Cox Transformed Energy usage (kWh)")


## ------------------------------------------------------------------
par(mfrow=c(2,1), mar=c(4,4,4,1))
plot(ts_YVRdata, ylab="Original Energy usage (kWh)", xlab="Year", main="Original Energy usage (kWh)")
plot(ts_YVRdata/monthdays(ts_YVRdata), ylab="Average energy usage (kWh)",
     xlab="Year", main="Calendar-adjusted energy usage for every month (kWh)")
# maybe use "Calendar-adjusted Energy Usage (kWh)" as title?


## ------------------------------------------------------------------
YVRdata_train <- window(ts_YVRdata,start=c(1997,1),end=c(2007,12))
YVRdata_test <- window(ts_YVRdata,start=2008)
# plot(YVRdata_train)
YVRdata_train_adj <- YVRdata_train/monthdays(YVRdata_train)
YVRdata_test_adj <- YVRdata_test/monthdays(YVRdata_test)
# plot(YVRdata_train_adj)


## ------------------------------------------------------------------
autoplot(ts_YVRdata, 
         xlab = "Year",
         ylab="Energy usage (kilowatt per hours [kWh])") +
theme(text = element_text(size = 15), plot.title = element_text(hjust = 0.5, size=20)) +
ggtitle("Plot 1. YVR's Energy usage from 1997 to 2010") 


## ------------------------------------------------------------------
fit_0 <- stl(ts_YVRdata, t.window=13, s.window="periodic", robust=TRUE)
plot(fit_0, main = "Plot 2. Decomposition by slt", cex.main=3)
#Additive decomposition only since there is no seasonal variation 


## ------------------------------------------------------------------
monthplot(ts_YVRdata, main = "Plot 3. Seasonality pattern with trend and remainders for energy usage", 
          ylab="Energy usage (kilowatt per hours [kWh])",
         xlab="Month",cex.main=1.5, cex.lab=1.2)
# from the plot below, we can see the peak happens in August and valley happens in March 


## ------------------------------------------------------------------
# plot with seasonal components only 
# without the trend and remainder, the seasonal plot provides the same conclusion
monthplot(seasonal(fit_0),main = "Plot 4. Seasonality pattern without trend and remainders for energy usage", 
          ylab="Energy usage - Seasonality portion (kilowatt per hours [kWh])",
         xlab="Month",cex.main=1.5, cex.lab=1.2)


## ------------------------------------------------------------------
# Looking at the trend component (moving average at 12*2)
# Alternative code:
#trend_ele = ma(ts_YVRdata, order = 12, centre = TRUE);plot(ts_YVRdata);lines(trend_ele, col="red")

plot(ts_YVRdata, col="black", main="Plot 5. Trend in electricity usage in YVR", 
     ylab="Energy usage - trend portion (kilowatt per hours [kWh])", xlab="Year",cex.main=1.5)
lines(fit_0$time.series[,2],col="red",ylab="Trend",lwd="2") # Graph the trend-cycle


## ------------------------------------------------------------------
# plot for remainders in data
plot(remainder(fit_0),main = "Plot 6. Remainders in electricity usage data for YVR", 
          ylab="Energy usage - Remainder portion (kilowatt per hours [kWh])",
         xlab="Year",cex.main=1.5, cex.lab=1.2)
abline(h=0,col="red",lwd="2")


## ------------------------------------------------------------------
# check what other variables 
reg_YVR <- YVR_rawdata[,-1]
head(reg_YVR)


## ------------------------------------------------------------------
# Checking the correlation
# pairs() would work too
P <- cor(reg_YVR)
print(P)
corrplot(P, type="upper", order="hclust",
         col=brewer.pal(n=8, name="RdYlBu"))


## ------------------------------------------------------------------
# Prepare time series data for other variables 
ts_YVRdata_pas<- ts(data = YVR_rawdata[,5], start = c(1997,01,01) , end = c(2010,12,31), frequency = 12)
ts_YVRdata_area <- ts(data = YVR_rawdata[,4], start = c(1997,01,01) , end = c(2010,12,31), frequency = 12)
ts_YVRdata_temp<- ts(data = YVR_rawdata[,3], start = c(1997,01,01) , end = c(2010,12,31), frequency = 12)

# Plot the trend and area of YVR
par(mfrow=c(2,1))
plot(fit_0$time.series[,2], main="Plot 7. Trend in electricity usage in YVR", 
     ylab="Energy usage - trend portion (kWh)", xlab="Year",cex.main=1.5)
plot(ts_YVRdata_area, main="Plot 8. Trend of YVR's area 1997-2010", 
     ylab="Area", xlab="Year",cex.main=1.5)


## ------------------------------------------------------------------
# Look into the seasonality of number of passengers
fit_1 <- stl(ts_YVRdata_pas, t.window=13, s.window="periodic", robust=TRUE)
plot(fit_1, main = "Plot 9. stl decomposition for total number of passengers")


## ------------------------------------------------------------------
# Compare the seasonality of energy usage and number of passangers 
par(mfrow=c(2,1))
monthplot(seasonal(fit_0), main = "Plot 10. Seasonality pattern only for energy usage", 
          ylab="Monthly energy usage - Seasonality portion (kilowatt per hours [kWh])",
         xlab="Month",
         cex.main=1.5)
monthplot(seasonal(fit_1),main = "Plot 11. Seasonality pattern only for total number of travellers", 
          ylab="Monthly total number of passengers",
         xlab="Month",
         cex.main=1.5)


## ------------------------------------------------------------------
# Tempurature check 
fit_2 <- stl(ts_YVRdata_temp, t.window=13, s.window="periodic", robust=TRUE)
monthplot(seasonal(fit_2), main = "Plot 12. Seasonality pattern only for Vancouver's temperature", 
          ylab="Monthly temperature",
         xlab="Month",cex.main=1.5)


## ------------------------------------------------------------------
#mean 
fit_mean <- meanf(YVRdata_train, 36)
#drift
fit_drift <- rwf(YVRdata_train, 36, drift = TRUE)
#naive
fit_naive <- naive(YVRdata_train, 36)
#seasonal naive
fit_snaive <- snaive(YVRdata_train, 36)

# Plot them into one graph
plot(ts_YVRdata, main="Plot 13. Forecasted energy usage using basic methods",
     ylab="Energy usage (kilowatt per hours [kWh])",
    xlab = "Year",
    cex.main=1.5)
lines(fit_mean$mean,col="blue",lwd = "2")
lines(fit_drift$mean, col = "green",lwd = "2")
lines(fit_naive$mean, col = "red",lwd = "2")
lines(fit_snaive$mean, col = "purple")
legend("topleft",lty=1, col=c("black","blue","green","red","purple"), 
       c("Data", "Mean method","Drift method","Naive method","Seasonal naive method"),pch=1,cex=1) 


## ------------------------------------------------------------------
# Compare accuracy measures for each model 
method <- c("Mean method", "Drift method","Naive method", "Seasonal naive method")
cbind(method, rbind(round(accuracy(fit_mean, YVRdata_test)[2,c(2,3,5,6)],1),
      round(accuracy(fit_drift, YVRdata_test)[2,c(2,3,5,6)],1),
                    round(accuracy(fit_naive, YVRdata_test)[2,c(2,3,5,6)],1),
                    round(accuracy(fit_snaive, YVRdata_test)[2,c(2,3,5,6)],1)))


## ------------------------------------------------------------------
ets_MAA = ets(YVRdata_train, model="MAA"); summary(ets_MAA)
# potential models set up
ets_AAA = ets(YVRdata_train, model="AAA")
ets_AAA_d = ets(YVRdata_train, model="AAA", damped = TRUE)
ets_MAA = ets(YVRdata_train, model="MAA")
ets_MAA_d = ets(YVRdata_train, model="MAA", damped = TRUE)
# test_ets_AMA = ets(YVRdata_train, model="AMA") # Forbidden model conbination
# test_ets_MMA = ets(YVRdata_train, model="MMA") # Forbidden model conbination
auto_ets = ets(YVRdata_train)


## ------------------------------------------------------------------
summary(ets_MAA)$par[c(1:3)]


## ------------------------------------------------------------------
autoplot(YVRdata_train)+
theme(text = element_text(size = 20), plot.title = element_text(hjust = 0.5, size=30)) +
ggtitle("Plot 14. YVR's Energy usage from 1997 to 2008") 


## ------------------------------------------------------------------
options(repr.plot.width=15, repr.plot.height=6)
plot(forecast(ets_MAA, h=length(YVRdata_test)), YVRdata_test,
    main="Plot 15. YVR's Energy usage Forecast by ETS(M,A,A)",
     cex.main=1.5
    )
lines(YVRdata_train, lwd=2)
lines(fitted(ets_MAA), col='blue')
lines(YVRdata_test, lwd=1)


## ------------------------------------------------------------------
method <- c("AAA", "AAA damped", "MAA", "MAA damped","Auto")
cbind(method, 
      round(rbind(
          accuracy(ets_AAA) [1,c(2,3,5,6)], 
          accuracy(ets_AAA_d) [1,c(2,3,5,6)],
          accuracy(ets_MAA) [1,c(2,3,5,6)],
          accuracy(ets_MAA_d) [1,c(2,3,5,6)],
          accuracy(auto_ets) [1,c(2,3,5,6)]
          ),4))


## ------------------------------------------------------------------
accuracy(forecast(ets_MAA, h=length(YVRdata_test)) , YVRdata_test)[2,c(2,3,5,6)]


## ------------------------------------------------------------------
method <- c("AAA", "AAA damped", "MAA", "MAA damped","Auto","Drift","Seasonal naive")
cbind(method, 
      round(rbind(
          accuracy(forecast(ets_AAA, h=length(YVRdata_test)) , YVRdata_test)[2,c(2,3,5,6)], 
          accuracy(forecast(ets_AAA_d, h=length(YVRdata_test)) , YVRdata_test)[2,c(2,3,5,6)],
          accuracy(forecast(ets_MAA, h=length(YVRdata_test)) , YVRdata_test)[2,c(2,3,5,6)],
          accuracy(forecast(ets_MAA_d, h=length(YVRdata_test)) , YVRdata_test)[2,c(2,3,5,6)],
          accuracy(forecast(auto_ets, h=length(YVRdata_test)) , YVRdata_test)[2,c(2,3,5,6)],
          accuracy(forecast(fit_drift, h=length(YVRdata_test)) , YVRdata_test)[2,c(2,3,5,6)],
          accuracy(forecast(fit_snaive, h=length(YVRdata_test)) , YVRdata_test)[2,c(2,3,5,6)]
          ),4))


## ------------------------------------------------------------------
plot(forecast(ets_MAA, h=length(YVRdata_test)), YVRdata_test, xlim = c(2008, 2011),
    main="Plot 16. YVR's Energy usage Forecast by ETS(M,A,A) from 2008 to 2011",
     cex.main=1.5
    )
# lines(YVRdata_train, lwd=2)
# lines(fitted(ets_MAA), col='blue')
lines(YVRdata_test, lwd=1)
lines(forecast(ets_AAA, h= length(YVRdata_test))$mean, col='green')
legend(
    "topleft",
    lty=1, 
    col=c(1,"blue","green"), 
    c("data", "ets(M,A,A)", "ets(A,A,A)"),
    pch=1) 



## ------------------------------------------------------------------
mean(residuals(ets_MAA))
checkresiduals(ets_MAA) 


## ------------------------------------------------------------------
arima_fit4 = Arima(YVRdata_train, order = c(1,1,0), seasonal = c(0,1,1), include.constant=TRUE)
summary(arima_fit4)
# candidate model set up
arima_fit1 = Arima(YVRdata_train, order = c(0,1,1), seasonal = c(3,1,0), include.constant=TRUE)
arima_fit2 = Arima(YVRdata_train, order = c(1,1,0), seasonal = c(3,1,0), include.constant=TRUE) 
arima_fit3 = Arima(YVRdata_train, order = c(0,1,1), seasonal = c(0,1,1), include.constant=TRUE) 
arima_fit4 = Arima(YVRdata_train, order = c(1,1,0), seasonal = c(0,1,1), include.constant=TRUE) 
arima_auto = auto.arima(YVRdata_train, stepwise=FALSE, approximation=FALSE, ic="aicc")


## ------------------------------------------------------------------
summary(arima_fit4)[1]


## ------------------------------------------------------------------
options(repr.plot.width=18, repr.plot.height=6)
par(mfrow = c(1,3))
plot(YVRdata_train, main="Plot 17. Time Series Plot",cex.main=1.5)
plot(diff(YVRdata_train,12),  main="Plot 18-A. Seasonal Differencing",cex.main=1.5)
plot(diff(diff(YVRdata_train,12)),  main="Plot 18-B. First Differencing After Seasonal Differencing",cex.main=1.5)


## ------------------------------------------------------------------
par(mfrow=c(1,2))
Acf( diff( diff(YVRdata_train, 12),  1 ) , lag=48, main="Plot 19. ACF After Differencing",cex.main=1.5)
Pacf(diff( diff(YVRdata_train, 12),  1 ) , lag=48, main="Plot 20. PACF After Differencing",cex.main=1.5)
# ggtsdisplay(diff( diff(YVRdata_train, 48),  1 ), lag=48)


## ------------------------------------------------------------------
plot(forecast(arima_fit4, h=length(YVRdata_test)), YVRdata_test,
    main="Plot 21. Forecasts of Energy Usage for YVR from ARIMA(1,1,0)(0,1,1)[12]",
    cex.main=1.5
    )
lines(YVRdata_train, lwd=2)
lines(fitted(arima_fit4), col='blue')
lines(YVRdata_test, lwd=1)


## ------------------------------------------------------------------
models_aicc <- c(
    "First: (0,1,1)(3,1,0)[12]  AICc", 
    "Second: (1,1,0)(3,1,0)[12]  AICc",
    "Third: (0,1,1)(0,1,1)[12]  AICc", 
    "Fourth: (1,1,0)(0,1,1)[12]  AICc",
    "Auto.arima  (1,1,0)(2,1,0)[12] AICc")
aicc = c(
          arima_fit1$aicc,
          arima_fit2$aicc,
          arima_fit3$aicc,
          arima_fit4$aicc,
          arima_auto$aicc
          )

cbind(models_aicc, round(aicc,4))


## ------------------------------------------------------------------
accuracy(forecast(arima_fit4, h=length(YVRdata_test)), YVRdata_test)


## ------------------------------------------------------------------
method <- c(
    "Third: (0,1,1)(0,1,1)[12] ", 
    "Fourth: (1,1,0)(0,1,1)[12] ",
    "Drift",
    "Seasonal naive"
)
cbind(method, 
      round(rbind(
          accuracy(forecast(arima_fit3, h=length(YVRdata_test)) , YVRdata_test)[2,c(2,3,5,6)],
          accuracy(forecast(arima_fit4, h=length(YVRdata_test)) , YVRdata_test)[2,c(2,3,5,6)],
          accuracy(forecast(fit_drift, h=length(YVRdata_test)) , YVRdata_test)[2,c(2,3,5,6)],
          accuracy(forecast(fit_snaive, h=length(YVRdata_test)) , YVRdata_test)[2,c(2,3,5,6)]
          ),4))


## ------------------------------------------------------------------
cat('Mean of the residuals:',mean(residuals(arima_fit4)))
checkresiduals(arima_fit4)


## ------------------------------------------------------------------
method <- c(
    "ETS(M,A,A) ", 
    "Final Arima model (1,1,0)(0,1,1)[12] ",
    "Mean method", 
    "Drift method",
    "Naive method", 
    "Seasonal naive method"
)
cbind(method, 
      round(rbind(
          accuracy(forecast(ets_MAA, h=length(YVRdata_test)) , YVRdata_test)[2,c(2,3,5,6)],
          accuracy(forecast(arima_fit4, h=length(YVRdata_test)) , YVRdata_test)[2,c(2,3,5,6)],
          accuracy(forecast(fit_mean, h=length(YVRdata_test)) , YVRdata_test)[2,c(2,3,5,6)],
          accuracy(forecast(fit_drift, h=length(YVRdata_test)) , YVRdata_test)[2,c(2,3,5,6)],
          accuracy(forecast(fit_naive, h=length(YVRdata_test)) , YVRdata_test)[2,c(2,3,5,6)],
          accuracy(forecast(fit_snaive, h=length(YVRdata_test)) , YVRdata_test)[2,c(2,3,5,6)]
          ),4))


## ------------------------------------------------------------------
plot(forecast(ets_MAA, h=length(YVRdata_test)), YVRdata_test, xlim = c(2008, 2011),
    main="Plot 22. YVR's Energy usage Forecast from 2008 to 2011",
     cex.main=1.5
    )
lines(YVRdata_test, lwd=2)
lines(forecast(arima_fit4, h= length(YVRdata_test))$mean, col='green')
lines(forecast(fit_mean, h= length(YVRdata_test))$mean, col='purple')
lines(forecast(fit_drift, h= length(YVRdata_test))$mean, col='red')
lines(forecast(fit_naive, h= length(YVRdata_test))$mean, col='orange')
lines(forecast(fit_snaive, h= length(YVRdata_test))$mean, col='yellow')
legend(
    "topleft",
    lty=1, 
    col=c(1,"blue","green", "purple","red","orange","yellow"), 
    c("data", "ets(M,A,A)", "Arima model (1,1,0)(0,1,1)[12]","Mean","Drift","Naive", "Snaive"),
    cex=1.1,
    bty = "n"
) 


## ------------------------------------------------------------------
ets_MAA = ets(ts_YVRdata, model="MAA")
plot(forecast(ets_MAA, h=3*12), ts_YVRdata,
    main="Plot 23. Forecasts of Energy Usage for YVR by ETS(M,A,A) from 2011 to 2013",
     cex.main=1.5
    )
lines(ts_YVRdata, lwd=2)


## ------------------------------------------------------------------
ets_AAA = ets(YVRdata_train, model="AAA")
ets_AAA_d = ets(YVRdata_train, model="AAA", damped = TRUE)
ets_MAA = ets(YVRdata_train, model="MAA") # final model
ets_MAA_d = ets(YVRdata_train, model="MAA", damped = TRUE)
# test_ets_AMA = ets(YVRdata_train, model="AMA") # Forbidden model conbination
# test_ets_MMA = ets(YVRdata_train, model="MMA") # Forbidden model conbination
auto_ets = ets(YVRdata_train)

plot(YVRdata_train, lwd=2, xlim = c(1997, 2011), ylim = c(5000,9000), 
    main="Plot 25. YVR's Energy usage Forecast by Different ETS Models",
    cex.main=1.5)
lines(YVRdata_test, lwd=2)
lines(forecast(ets_AAA, h= length(YVRdata_test))$mean, col='blue')
lines(forecast(ets_AAA_d, h= length(YVRdata_test))$mean, col='green')
lines(forecast(ets_MAA, h= length(YVRdata_test))$mean, col='purple')
lines(forecast(ets_MAA_d, h= length(YVRdata_test))$mean, col='red')
lines(forecast(auto_ets, h= length(YVRdata_test))$mean, col='orange')
legend(
    "topleft",
    lty=1, 
    col=c(1,"blue","green", "purple","red","orange"), 
    c("data", "AAA", "AAA damped", "MAA", "MAA damped","Auto"),
    cex=1.1,
    bty = "n"
) 


## ------------------------------------------------------------------
arima_fit1 = Arima(YVRdata_train, order = c(0,1,1), seasonal = c(3,1,0), include.constant=TRUE)
arima_fit2 = Arima(YVRdata_train, order = c(1,1,0), seasonal = c(3,1,0), include.constant=TRUE)
arima_fit3 = Arima(YVRdata_train, order = c(0,1,1), seasonal = c(0,1,1), include.constant=TRUE)
arima_fit4 = Arima(YVRdata_train, order = c(1,1,0), seasonal = c(0,1,1), include.constant=TRUE)
arima_auto = auto.arima(YVRdata_train, stepwise=FALSE, approximation=FALSE, ic="aicc")

plot(YVRdata_train, lwd=2, xlim = c(1997, 2011), ylim = c(5000,10000),
    main="Plot 25. YVR's Energy usage Forecast by Different Arima Models",
     cex.main=1.5
    )
lines(YVRdata_test, lwd=2)
lines(forecast(arima_fit1, h= length(YVRdata_test))$mean, col='blue')
lines(forecast(arima_fit2, h= length(YVRdata_test))$mean, col='green')
lines(forecast(arima_fit3, h= length(YVRdata_test))$mean, col='purple')
lines(forecast(arima_fit4, h= length(YVRdata_test))$mean, col='red')
lines(forecast(arima_auto, h= length(YVRdata_test))$mean, col='orange')
legend(
    "topleft",
    lty=1, 
    col=c(1,"blue","green", "purple","red","orange"), 
    c("data", 
     "First: (0,1,1)(3,1,0)[12]", 
    "Second: (1,1,0)(3,1,0)[12]",
    "Third: (0,1,1)(0,1,1)[12]", 
    "Fourth: (1,1,0)(0,1,1)[12]",
    "Auto.arima  (1,1,0)(2,1,0)[12]"
     ),
    cex=1.1,
    bty = "n"
) 

