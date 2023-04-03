# YVR-Energy-Usage-Forecast

# Introduction
The YVR Energy Usage Forecast project aims to forecast energy consumption at the Vancouver International Airport (YVR) using time series modeling techniques. The project utilizes historical energy usage data, weather data, and several time series models to predict hourly energy consumption for future periods.

There are three types of models are tried out in this project: basic forecasting methods, exponential smoothing model (EST), and ARIMA model. The EST (MAA) is the final recommendation based on the model accuracy (lowest MSE) on test data and reasonability of visualized forecasts.

The project uses the following steps:
- Data preprocessing
- Exploratory data analysis (EDA)
- Model selection and validation
- Forecasting

# Datasets
The dataset contains monthly energy usage data of YVR from January 1997 to December 2010.
- Training set: 1997/1 - 2007/12
- Test set: 2008/1 - 2020/12

The dataset contains the following variables:

| \#  | Variable                 | Definition                                                                          |
|:-----------------------|:-----------------------|:-----------------------|
| 1   | month                    | Month and year, e.g.: Nov-98                                                        |
| 2   | energy                   | Energy use measured in thousands of kilowatt hours (kWh)                            |
| 3   | mean.temp                | Mean monthly temperature outside (degrees Celsius)                                  |
| 4   | total.area               | Total area of all terminals (sq. m.)                                                |
| 5   | total.passengers         | Total number of passengers in thousands                                             |
| 6   | domestic.passengers      | Total number of domestic passengers (traveling within Canada) in thousands          |
| 7   | US.passengers            | Total number of passengers traveling between Canada and the US in thousands         |
| 8   | international.passengers | Total number of passengers traveling between YVR and countries other than Canada/US |

# Language and libraries
**Language** : R

**Libraries** : 
- Data Manipulation: dplyr, tidyr, tidyverse
- Data Visualization: corrplot, RColorBrewer
- Statistics: fpp2

# Data Preprocessing
## Check transformation and calendar adjustment
While the seasonality of the data is obvious, which is shown below, it is always better to check if the transformation and calendar adjsutment would be helpful.

![time-plot]()

- Box-cox transformation

![box-cox plot]()

- Calendar adjustment

![Calendar adjustment plot]()

As both transformation and adjustment have no significant help on detecting a trend, there is no need to use them and choose the original data as modeling dataset.

# Exploratory Data Analysis (EDA)
An exploratory data analysis was conducted on the YVR energy data to gain insights into the patterns and trends in the data. This involved visualizing the data using various graphs and statistical measures.

## Key insights:
- Energy usage has an upward trend over time
- There is seasonality with higher usage during the summer months
- The electricity usage has some outliers, but overall it does not affect the result significantly.

## STL decomposition:
This is a statistical method of decomposing a Time Series data into 3 components containing seasonality, trend and residual. This plot can help to access the seasonality, trend, and outliers.

![stl]()

To view the trend more clearly, you can see the plot below.

![plot5]()

## Check the correlation between features

![correlation]()

Larger circle means higher correlation. The features related to passengers are all related to each other, meaning that there is no significant difference among passengers.

## Seasonality with higher usage during the summer months

![plot12-temp-seasonality]()

# Model Building
The YVR Energy Usage Forecast project utilized several time series models to forecast energy usage, including: basic forecasting methods (mean, drift, naive, seasonal naive), ETS model, and ARIMA model.

## Basic forecasting methods

![plot13-basic-methods]()

# start from here

## Exponential Smoothing (ETS MAA)

![plot15]()

Comparison among different ETS models and some basic methods

## Auto Regressive Integrated Moving Average (ARIMA (1,1,0)(0,1,1)[12] )

![plot21]()

Comparison among different ARIMA models and some basic methods


# Model Evaluation
The performance of the time series models was evaluated using several metrics, including:

## Mean Absolute Error (MAE): The average absolute difference between the actual and predicted energy usage values.

## Root Mean Squared Error (RMSE): The square root of the average squared difference between the actual and predicted energy usage values.


# Model Selection
The best time series model was selected based on the lowest MAE and RMSE values. The ARIMA and ETS models were compared using these metrics, and the ARIMA model was selected as the best model for forecasting energy usage at YVR.


--- 

# Forecasting
The best performing model was used to forecast the energy usage of YVR for the year 2020. The forecasted values were compared to the actual values to evaluate the performance of the model.

# Conclusion
In conclusion, this project successfully forecasted the energy usage of YVR using ARIMA and ETS models. The project provides useful insights into the trends and seasonality of the energy usage at YVR and can be used for future planning and resource allocation.
