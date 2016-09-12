# Data Dictionary for "summary.txt" output produced by running "run_analysis.R" scripts

This document contains 3 sections as follows:

* A.	Data Dictionary for output.txt file produced in "run_analysis.R" script, which is also included in this repo.
* B.	Source Data and Manipulation
* C.	R scripts for reproducing summary_df

## Section A - Data Dictionary for "summary.txt" output
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
