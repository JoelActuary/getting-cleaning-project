## Below code applies to data in the UCI HAR Dataset directory, and assumes that the R
## project working directory is the same where the UCI HAR Dataset directory is saved.
## This script requires the installation of the "dplyr" and "tidyr" R packages.

## The general steps of the code are as follows:
## 1. Read in test and training data sets, including data on subjects and activities.
## 2. Merge the test and training data into one data frame.
## 3. Subset the merged data for mean and standard deviation (SD) statistics on variables.
## 4. Tidy the data to have individual statistics (mean, SD) by variable set.
## 5. Group the subject/variable set, and produce summary of average mean & SD.


## 1. Read in test and training data sets, including data on subjects and activities.
# Load dplyr and tidyr packages
library(dplyr)
library(tidyr)

# Read in activity and features labels 
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt",colClasses = "character")
value_labels <- read.table("./UCI HAR Dataset/features.txt")

# Read training data
train_data <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_df <- tbl_df(train_data)
colnames(train_df) <- as.vector(value_labels[,2])
rm(train_data)

# Read training data activity index, and merge to training data
train_activity <- read.table("./UCI HAR Dataset/train/y_train.txt")
train_activity_df <- tbl_df(train_activity) %>% 
        mutate(activity = activity_labels[V1,2]) %>%
        select(activity)

train_df <- bind_cols(train_activity_df,train_df)
rm(train_activity)

# Tag training data
cat_train <- tbl_df(rep("train",nrow(train_df)))
colnames(cat_train) <- "category"
train_df <- bind_cols(cat_train,train_df)

# Read training data subjects and merge to data
train_subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")
colnames(train_subjects) <- "subject"
train_subjects_df <- tbl_df(train_subjects)
train_df <- bind_cols(train_subjects_df, train_df)
rm(train_subjects)

## repeating above sub-steps for "test" data
# Read test data
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_df <- tbl_df(test_data)
colnames(test_df) <- as.vector(value_labels[,2])
rm(test_data)

# Read test data activity index, and merge to test data frame
test_activity <- read.table("./UCI HAR Dataset/test/y_test.txt")
test_activity_df <- tbl_df(test_activity) %>% 
        mutate(activity = activity_labels[V1,2]) %>%
        select(activity)

test_df <- bind_cols(test_activity_df,test_df)
rm(test_activity)

# Tag test data
cat_test <- tbl_df(rep("test",nrow(test_df)))
colnames(cat_test) <- "category"
test_df <- bind_cols(cat_test,test_df)

# Read test data subjects and merge to test data frame
test_subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")
colnames(test_subjects) <- "subject"
test_subjects_df <- tbl_df(test_subjects)
test_df <- bind_cols(test_subjects_df, test_df)
rm(test_subjects)

## 2. Merge the test and training data into one data frame.
merge_df <- bind_rows(train_df,test_df)

## 3. Subset the merged data for mean and standard deviation (SD) statistics on variables.
subset_df <- select(merge_df,subject,category, activity, contains("mean()"), contains("std()")) 

## 4. Tidy and group the data to have averages of the mean and SD by variable set.
# Below code tidies the data based on Hadley-Wickam's principles (http://vita.had.co.nz/papers/tidy-data.pdf)
clean_df <- subset_df %>%
        gather(variable, value , -(subject:activity)) %>%
        separate(variable,c("variable_1","statistic","axis"),remove = FALSE) %>%
        mutate(axis = ifelse(grepl("Mag",variable_1) == TRUE, "magnitude", axis)) %>%
        mutate(domain = ifelse(grepl("^t",variable),"time",ifelse(grepl("^f",variable),"frequency","NA"))) %>%
        mutate(signal_reader = ifelse(grepl("Acc",variable),"accelerometer",ifelse(grepl("Gyro",variable),"gyroscope","NA"))) %>%
        mutate(signal_type = ifelse(grepl("Body",variable),"body",ifelse(grepl("Gravity",variable),"gravity","NA"))) %>%
        mutate(jerk_signal = ifelse(grepl("Jerk",variable),"jerk","stable")) %>%
        select(subject, category, activity, statistic, domain, axis, signal_reader, signal_type, jerk_signal, value)

## 5. Group the subject/variable set, and produce summary of average mean & SD.
group_df <- clean_df %>%
        group_by(subject, activity, domain, axis, signal_reader, signal_type, jerk_signal, statistic) 

summary_df <- group_df %>%
        summarize(average_stat = mean(value, na.rm = TRUE)) %>%
        spread(statistic, average_stat)

# output summary.txt file to working directory
write.table(summary_df,"./summary.txt")

