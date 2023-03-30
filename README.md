# YVR-Energy-Usage-Forecast
Forecast monthly energy use for the Vancouver International Airport (YVR) utilizing time series methodologies and R.

YVR Energy Usage Forecast
Introduction
The purpose of this project is to forecast the energy usage of Vancouver International Airport (YVR) in British Columbia, Canada. The data used for this project was obtained from the Open Data Catalogue of the British Columbia government. The dataset contains monthly energy usage data of YVR from January 2010 to December 2019.

The YVR Energy Usage Forecast project aims to forecast energy consumption at the Vancouver International Airport (YVR) using time series modeling techniques. The project utilizes historical energy usage data, weather data, and several time series models to predict hourly energy consumption for future periods.

The project uses the following steps:

Data preprocessing
Exploratory data analysis (EDA)
Model selection and validation
Forecasting

Data Preprocessing
The dataset contains the following variables:

---
Methodology
Data Collection
The project utilized several datasets, including:

YVR Hourly Energy Usage Data: This dataset contains hourly energy usage data for several facilities at YVR from 2016 to 2019.

YVR Hourly Weather Data: This dataset contains hourly weather data for the YVR area from 2016 to 2019.

Data Preprocessing
The YVR energy data was preprocessed to prepare it for analysis and model building. This involved several steps, including:

Data Cleaning: The dataset contained missing values and outliers, which were removed or imputed based on the specific feature and the extent of the missing data. The data was also checked for duplicates and erroneous readings.

Data Transformation: The energy usage data was initially provided as cumulative kWh readings, which were transformed into hourly energy consumption values. Additionally, the date and time information were separated into individual features, and weather data was added to the dataset.

Feature Engineering: Several additional features were created from the existing dataset, including lagged energy consumption values, moving averages, and indicator variables for weekends and holidays.

Exploratory Data Analysis (EDA)
An exploratory data analysis was conducted on the YVR energy data to gain insights into the patterns and trends in the data. This involved visualizing the data using various graphs and statistical measures, including:

Time Series Plots: Line plots were used to visualize the hourly energy usage over time, including patterns in daily, weekly, and seasonal trends.

Box Plots: Box plots were used to visualize the distribution of energy usage across different facilities and times of day.

Correlation Analysis: Correlation coefficients were calculated between the energy usage and weather variables to identify the factors that most strongly influence energy consumption.

Model Building
The YVR Energy Usage Forecast project utilized several time series models to forecast energy usage, including:

Auto Regressive Integrated Moving Average (ARIMA): An ARIMA model was built to capture the autocorrelation and seasonal patterns in the energy usage data.

Exponential Smoothing (ETS): An ETS model was built to capture the trend, seasonality, and random variation in the energy usage data.

Model Evaluation
The performance of the time series models was evaluated using several metrics, including:

Mean Absolute Error (MAE): The average absolute difference between the actual and predicted energy usage values.

Root Mean Squared Error (RMSE): The square root of the average squared difference between the actual and predicted energy usage values.

Symmetric Mean Absolute Percentage Error (SMAPE): The average percentage difference between the actual and predicted energy usage values.

Model Selection
The best time series model was selected based on the lowest MAE and RMSE values. The ARIMA and ETS models were compared using these metrics, and the ARIMA model was selected as the best model for forecasting energy usage at YVR.


---


Month
Electricity Usage (kWh)
Natural Gas Usage (GJ)
The "Month" variable was converted to a datetime object and set as the index of the dataset. Then, the dataset was resampled to monthly frequency.

Exploratory Data Analysis (EDA)
The EDA was performed on the preprocessed dataset. The following observations were made:

The electricity and natural gas usage have an upward trend over time.
There is seasonality in both electricity and natural gas usage, with higher usage during the winter months.
The electricity usage has some outliers that need to be addressed.
Model Selection and Validation
The following models were used for forecasting:

AutoRegressive Integrated Moving Average (ARIMA)
Exponential Smoothing (ETS)
The models were fitted on the training set and validated on the test set using the Mean Absolute Percentage Error (MAPE) metric. The best performing model was selected based on the lowest MAPE.

Forecasting
The best performing model was used to forecast the energy usage of YVR for the year 2020. The forecasted values were compared to the actual values to evaluate the performance of the model.

Conclusion
In conclusion, this project successfully forecasted the energy usage of YVR using ARIMA and ETS models. The project provides useful insights into the trends and seasonality of the energy usage at YVR and can be used for future planning and resource allocation.
