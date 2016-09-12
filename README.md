# getting-cleaning-project
R script and codebook for output to the "getting and cleaning" assignment

The analysis performed by the run_analysis.R script is applied on raw data based on statistical measurements taken on 30 subjects while performing 6 activities of daily living (ADL), such as sitting, walking, standing, etc. The data is based on raw signals recorded from the accelerometers and gyroscopes of waist-mounted smartphones with such embedded inertial sensors, compiled as at December 10, 2012.  

## Link to source data and description
Information on the experiment, raw data description and its source can be found at the following link:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#

The raw data files can be accessed by following the "Data Folder" link in the above URL. Prior to running the run_analysis.R script, the raw data directory should be extracted to a local working dirctory and saved as "UCI HAR Dataset". That is, do not change the name of the downloaded raw data directory. The working directory for the "run_analysis.R" script should similalry be set to the working directory which contains the "UCI HAR Dataset" folder.

The "UCI HAR Dataset" directory contains raw data on two subsets of observed data: "test" and "training" data.

## Description of data observations
For each subject and activity (e.g. walking, sitting, etc.) combination, there were 33 different types of signals (based on variables such as the signal axis, body vs. gravity signal type, etc.) being recorded per observation from the inertial sensors (accelerometer & gyroscope), on which 17 statistical measurements (e.g. mean, standard deviation, etc.) were determined, resulting in 561 recorded attributes per observation. These observations were repeated multiple times for each subject for each activity. In all there were 10,299 observations between the test and training data. Further details on the above described attributes can be found on the “features_info.txt” file in the "UCI HAR Dataset" directory

## General functions of "run_analysis.R"
This script outputs a file called "summary.txt", based on raw data downladed from the URL indicated above.  This file provides the averages of the means and standard deviations of the 33 measured signals for each set of observed subject and activity (for example, the averages of the 33 signals recorded for each observation of subject 1's walking). In order to prepare this file, the raw data first had to be acquired, then trimmed down and tidied using techniques and principles outlined in Hadley Wickham’s paper on Tidy Data (http://vita.had.co.nz/papers/tidy-data.pdf). Additional details on the general steps are as follows:

1. Both the test and training data were used in the summary analysis. 

2. The source test and training data is split into three separate files: (i) the 561 recorded attributes for each subject-activity observation (X_train.txt, X_test.txt), (ii) the subject ids for each observation (subject_train.txt, subject_test.txt), and (iii) the ADL activity index for each observation (y_train.txt, y_test.txt).  

3. The above raw files were first merged into single “training” and “test” data sets before merging into one master file.

4. Once merged, the next step was to trim the data so as to only pull attributes on mean and standard deviation measurements by observation.

5. Based on the trimmed dataset from item 4 above, each attribute was stored in a separate column, for each row of observation. For example, the mean of the body acceleration frequency signals in the Y axis was stored in a specific column for the set of observations. As noted in Hadley Wickham’s Tidy Data paper, this breaks the tidy data rule of having a single variable per column. That is, a single attribute’s column in the raw data may indicate information on several variables such as the statistic being measured (mean versus standard deviation), the signal axis (e.g. X, Y, Z) , the measurement domain (time vs. frequency), etc. Hence, the next major step in cleaning the data was to establish all of the individual variables/indicators that make up the various attributes being measured, and split out into single variable columns using R functions. 

6.	Once cleaned, the data was then grouped in order to retrieve the average statistical measurements (i.e. average means and average standard deviations) over multiple observations of the same attribute set by subject and activity. 

7. Although effort was taken to split the variables for each attribute into separate columns (in item 6 above), mean and standard deviation statistics are kept in separate columns so as to maintain Hadley Wickham’s tidy data principle that variables should not be contained in both rows and columns. This also allowed for efficient summarizing of the average mean and standard deviation measurements.

8.	A printout of the scripts used to clean the raw data and prepare the “summary.txt” file are included below.

## R scripts for reproducing “summary_df”
Prior to running the below scripts in R, the raw data file directory should be downloaded and saved in the working directory, as described near the beginning of this document. The R scripts are as follows. Please note as well that lines starting with a # character are comments within the script:

###########################################################################
####### Below code applies to data in the UCI HAR Dataset directory, and assumes that the R
####### project working directory is the same where the UCI HAR Dataset directory is saved.
####### This script requires the installation of the "dplyr" and "tidyr" R packages.

####### The general steps of the code are as follows:
####### 1. Read in test and training data sets, including data on subjects and activities.
####### 2. Merge the test and training data into one data frame.
####### 3. Subset the merged data for mean and standard deviation (SD) statistics on variables.
####### 4. Tidy the data to have individual statistics (mean, SD) by variable set.
####### 5. Group the subject/variable set, and produce summary of average mean & SD.


####### 1. Read in test and training data sets, including data on subjects and activities.
####### Load dplyr and tidyr packages
library(dplyr)
library(tidyr)

####### Read in activity and features labels 
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt",colClasses = "character")
value_labels <- read.table("./UCI HAR Dataset/features.txt")

####### Read training data
train_data <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_df <- tbl_df(train_data)
colnames(train_df) <- as.vector(value_labels[,2])
rm(train_data)

####### Read training data activity index, and merge to training data
train_activity <- read.table("./UCI HAR Dataset/train/y_train.txt")
train_activity_df <- tbl_df(train_activity) %>% 
        mutate(activity = activity_labels[V1,2]) %>%
        select(activity)

train_df <- bind_cols(train_activity_df,train_df)
rm(train_activity)

####### Tag training data
cat_train <- tbl_df(rep("train",nrow(train_df)))
colnames(cat_train) <- "category"
train_df <- bind_cols(cat_train,train_df)

####### Read training data subjects and merge to data
train_subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")
colnames(train_subjects) <- "subject"
train_subjects_df <- tbl_df(train_subjects)
train_df <- bind_cols(train_subjects_df, train_df)
rm(train_subjects)

####### repeating above sub-steps for "test" data
####### Read test data
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_df <- tbl_df(test_data)
colnames(test_df) <- as.vector(value_labels[,2])
rm(test_data)

####### Read test data activity index, and merge to test data frame
test_activity <- read.table("./UCI HAR Dataset/test/y_test.txt")
test_activity_df <- tbl_df(test_activity) %>% 
        mutate(activity = activity_labels[V1,2]) %>%
        select(activity)

test_df <- bind_cols(test_activity_df,test_df)
rm(test_activity)

####### Tag test data
cat_test <- tbl_df(rep("test",nrow(test_df)))
colnames(cat_test) <- "category"
test_df <- bind_cols(cat_test,test_df)

####### Read test data subjects and merge to test data frame
test_subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")
colnames(test_subjects) <- "subject"
test_subjects_df <- tbl_df(test_subjects)
test_df <- bind_cols(test_subjects_df, test_df)
rm(test_subjects)

####### 2. Merge the test and training data into one data frame.
merge_df <- bind_rows(train_df,test_df)

####### 3. Subset the merged data for mean and standard deviation (SD) statistics on variables.
subset_df <- select(merge_df,subject,category, activity, contains("mean()"), contains("std()")) 

####### 4. Tidy and group the data to have averages of the mean and SD by variable set.
####### Below code tidies the data based on Hadley-Wickam's principles (http://vita.had.co.nz/papers/tidy-data.pdf)
clean_df <- subset_df %>%
        gather(variable, value , -(subject:activity)) %>%
        separate(variable,c("variable_1","statistic","axis"),remove = FALSE) %>%
        mutate(axis = ifelse(grepl("Mag",variable_1) == TRUE, "magnitude", axis)) %>%
        mutate(domain = ifelse(grepl("^t",variable),"time",ifelse(grepl("^f",variable),"frequency","NA"))) %>%
        mutate(signal_reader = ifelse(grepl("Acc",variable),"accelerometer",ifelse(grepl("Gyro",variable),"gyroscope","NA"))) %>%
        mutate(signal_type = ifelse(grepl("Body",variable),"body",ifelse(grepl("Gravity",variable),"gravity","NA"))) %>%
        mutate(jerk_signal = ifelse(grepl("Jerk",variable),"jerk","stable")) %>%
        select(subject, category, activity, statistic, domain, axis, signal_reader, signal_type, jerk_signal, value)

####### 5. Group the subject/variable set, and produce summary of average mean & SD.
group_df <- clean_df %>%
        group_by(subject, activity, domain, axis, signal_reader, signal_type, jerk_signal, statistic) 

summary_df <- group_df %>%
        summarize(average_stat = mean(value, na.rm = TRUE)) %>%
        spread(statistic, average_stat)

####### output summary.txt file to working directory
write.table(summary_df,"./summary.txt")
