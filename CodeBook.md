# Data Dictionary for "summary.txt" output produced by running "run_analysis.R" scripts

This document contains 2 sections as follows:

* A.	Data Dictionary for output.txt file produced in "run_analysis.R" script, which is also included in this repo.
* B.	Source Data and Manipulation

## A. Data Dictionary for "summary.txt" output
### subject
  ID number for identifying individuals on whom statistical measurements of Activities of Daily Living (ADL) were recorded

### activity
  Activity for which accelerometer and gyroscope readings were recorded. This can be either of the following:
  1.	Laying
  2.	Sitting
  3.	Standing
  4.	Walking
  5.	Walking_downstairs
  6.	Walking_upstairs

### domain
  Type of measurement being recorded:
  1.	Time
  2.	Frequency

### axis
  Indicates the which of the XYZ directional axes is being monitored, unless the measurement is with respect to a magnitude without directional denomination.
  1.	X
  2.	Y
  3.	Z
  4.	magnitude

### signal_reader
  Indicates which instrument of the smartphone ADL readings are being captured from.
  1.	accelerometer
  2.	gyroscope

### signal_type
  Specific signal being monitored by the accelerometer. Note, the gyroscope only monitors gravity signals. 
  1.	Body
  2.	Gravity

### jerk_signal
  Indicates measurement of signals derived from changes in the body’s linear acceleration and/or angular velocity (cite the features document read.me) . Non-jerk measurements are classified as “stable” states.
  1.	Jerk
  2.	stable

### mean
  Average of the statistical means of the various signal measurements taken from each individual activity being observed, for each subject.

### std
  Average of the statistical standard deviations of the various signal measurements taken from each individual activity being observed, for each subject.

## B.	Source Data and Manipulation

The analysis performed by the run_analysis.R script is applied on raw data based on statistical measurements taken on 30 subjects while performing 6 activities of daily living (ADL), such as sitting, walking, standing, etc. The data is based on raw signals recorded from the accelerometers and gyroscopes of waist-mounted smartphones with such embedded inertial sensors, compiled as at December 10, 2012.  

### Link to source data and description
Information on the experiment, raw data description and its source can be found at the following link:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#

The raw data files can be accessed by following the "Data Folder" link in the above URL. Prior to running the run_analysis.R script, the raw data directory should be extracted to a local working dirctory and saved as "UCI HAR Dataset". That is, do not change the name of the downloaded raw data directory. The working directory for the "run_analysis.R" script should similalry be set to the working directory which contains the "UCI HAR Dataset" folder.

The "UCI HAR Dataset" directory contains raw data on two subsets of observed data: "test" and "training" data.

### Description of data observations
For each subject and activity (e.g. walking, sitting, etc.) combination, there were 33 different types of signals (based on variables such as the signal axis, body vs. gravity signal type, etc.) being recorded per observation from the inertial sensors (accelerometer & gyroscope), on which 17 statistical measurements (e.g. mean, standard deviation, etc.) were determined, resulting in 561 recorded attributes per observation. These observations were repeated multiple times for each subject for each activity. In all there were 10,299 observations between the test and training data. Further details on the above described attributes can be found on the “features_info.txt” file in the "UCI HAR Dataset" directory

### General functions of "run_analysis.R"
This script outputs a file called "summary.txt", based on raw data downladed from the URL indicated above.  This file provides the averages of the means and standard deviations of the 33 measured signals for each set of observed subject and activity (for example, the averages of the 33 signals recorded for each observation of subject 1's walking). In order to prepare this file, the raw data first had to be acquired, then trimmed down and tidied using techniques and principles outlined in Hadley Wickham’s paper on Tidy Data (http://vita.had.co.nz/papers/tidy-data.pdf). Additional details on the general steps are as follows:

1. Both the test and training data were used in the summary analysis. 

2. The source test and training data is split into three separate files: (i) the 561 recorded attributes for each subject-activity observation (X_train.txt, X_test.txt), (ii) the subject ids for each observation (subject_train.txt, subject_test.txt), and (iii) the ADL activity index for each observation (y_train.txt, y_test.txt).  

3. The above raw files were first merged into single “training” and “test” data sets before merging into one master file.

4. Once merged, the next step was to trim the data so as to only pull attributes on mean and standard deviation measurements by observation.

5. Based on the trimmed dataset from item 4 above, each attribute was stored in a separate column, for each row of observation. For example, the mean of the body acceleration frequency signals in the Y axis was stored in a specific column for the set of observations. As noted in Hadley Wickham’s Tidy Data paper, this breaks the tidy data rule of having a single variable per column. That is, a single attribute’s column in the raw data may indicate information on several variables such as the statistic being measured (mean versus standard deviation), the signal axis (e.g. X, Y, Z) , the measurement domain (time vs. frequency), etc. Hence, the next major step in cleaning the data was to establish all of the individual variables/indicators that make up the various attributes being measured, and split out into single variable columns using R functions. 

6.	Once cleaned, the data was then grouped in order to retrieve the average statistical measurements (i.e. average means and average standard deviations) over multiple observations of the same attribute set by subject and activity. 

7. Although effort was taken to split the variables for each attribute into separate columns (in item 6 above), mean and standard deviation statistics are kept in separate columns so as to maintain Hadley Wickham’s tidy data principle that variables should not be contained in both rows and columns. This also allowed for efficient summarizing of the average mean and standard deviation measurements.

8.	A printout of the scripts used to clean the raw data and prepare the “summary.txt” file are included in the README.md document in this repo.

