###########################################################################
## Title: Getting and cleaning data Course Project
###########################################################################

library(dplyr)

## Download the file
dataFile <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dir.create("UCI HAR Dataset")
download.file(dataFile, "UCIHARdataset.zip")
unzip("./UCIHARdataset.zip")
  
## Merges the training and the test sets to create one data set.
train.df <- read.table("./UCI HAR Dataset/train/X_train.txt")
test.df <- read.table("./UCI HAR Dataset/test/X_test.txt")
x.df <- rbind(train.df, test.df)
rm(list = c("train.df", "test.df"))

trainSubj.df <- read.table("./UCI HAR Dataset/train/subject_train.txt")
testSubj.df <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subj.df <- rbind(trainSubj.df, testSubj.df)
rm(list = c("trainSubj.df", "testSubj.df"))

train.df <- read.table("./UCI HAR Dataset/train/y_train.txt")
test.df <- read.table("./UCI HAR Dataset/test/y_test.txt")
y.df <- rbind(train.df, test.df)
rm(list = c("train.df", "test.df"))

## Extracts only the measurements on the mean and standard deviation for 
## each measurement. 
features.df <- read.table("./UCI HAR Dataset/features.txt")
meandsd.df <- grep("-mean\\(\\)|-std\\(\\)", features.df[, "V2"])
xMeanSD.df <- x.df[, meandsd.df]

## Uses descriptive activity names to name the activities in the data set.
names(xMeanSD.df) <- features.df[meandsd.df, "V2"]
names(xMeanSD.df) <- gsub("\\(|\\)", "", names(xMeanSD.df))
activities.df <- read.table("./UCI HAR Dataset/activity_labels.txt")
y.df[, 1] <- activities.df[y.df[, 1], 2]
colnames(y.df) <- "activity"
colnames(subj.df) <- "subject"

## Appropriately labels the data set with descriptive activity names.
final.df <- cbind(subj.df, xMeanSD.df, y.df)
write.table(final.df, "./UCI HAR Dataset/tidy.txt", row.names = FALSE)

## From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject.
tidy2.df <- aggregate(x = final.df, 
                      by = list(activities = final.df[, "activity"], 
                                subj = final.df[, "subject"]), 
                      FUN = mean)
tidy2.df <- tidy2.df[, !(colnames(tidy2.df) %in% c("subj", "activity"))]
write.table(tidy2.df, "./UCI HAR Dataset/tidy2.txt", row.names = FALSE)

###########################################################################
## END
###########################################################################
