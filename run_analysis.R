### Load the Required Packages
library(dplyr)
library(tidyr)
library(data.table)


## Create a new Directory if necessary
if(!file.exists("UCI_HAR_data")){
	dir.create("UCI_HAR_data")
	}


## Download the "UCI HAR Dataset" (I am using a Windows computer)
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "./UCI_HAR_data/UCI_HAR_Dataset.zip", mode = "wb")


## Unzip the file
unzip(zipfile = "./UCI_HAR_data/UCI_HAR_Dataset.zip", exdir = "./UCI_HAR_data")


## Display the file path
filePath <- "C:\\Users\\574996\\Desktop\\R_Assignments\\UCI_HAR_data\\UCI HAR Dataset"


## Read in the following files: "subject_train.txt", "subject_test.txt", "Y_train.txt", "Y_test.txt", "X_train.txt", "X_test.txt"
subjectTrainData <- read.table(file.path(filePath, "train", "subject_train.txt"), header = FALSE)
subjectTestData <- read.table(file.path(filePath, "test", "subject_test.txt"), header = FALSE)

YActivityTrainData <- read.table(file.path(filePath, "train", "Y_train.txt"), header = FALSE)
YActivityTestData <- read.table(file.path(filePath, "test", "Y_test.txt"), header = FALSE)

XFeaturesTrainData <- read.table(file.path(filePath, "train", "X_train.txt"), header = FALSE)
XFeaturesTestData <- read.table(file.path(filePath, "test", "X_test.txt"), header = FALSE)


## Create data tables from the above data
subjectTrainDataTable <- tbl_df(subjectTrainData)
subjectTestDataTable <- tbl_df(subjectTestData)

YActivityTrainDataTable <- tbl_df(YActivityTrainData)
YActivityTestDataTable <- tbl_df(YActivityTestData)

XFeaturesTrainDataTable <- tbl_df(XFeaturesTrainData)
XFeaturesTestDataTable <- tbl_df(XFeaturesTestData)


## STEP ONE: MERGE TRAINING AND TEST SETS TO CREATE ONE DATA SET

## Combine the Training and Test Rows for the subject, YActivity, and XFeatures Data Sets
subjectDataTable <- rbind(subjectTrainDataTable, subjectTestDataTable)
YActivityDataTable <- rbind(YActivityTrainDataTable, YActivityTestDataTable)
XFeaturesDataTable <- rbind(XFeaturesTrainDataTable, XFeaturesTestDataTable)

## Provide variable names for the data sets
colnames(subjectDataTable) <- c("Subject")
colnames(YActivityDataTable) <- c("Activity")

XFeaturesNames <- read.table(file.path(filePath, "features.txt"), header = FALSE)
XFeaturesDataTableNames <- tbl_df(XFeaturesNames)
names(XFeaturesDataTable) <- XFeaturesDataTableNames$V2


## Combine the columns for the subject, YActivity, and XFeatures Data Sets to form one data set
harData <-cbind(subjectDataTable, YActivityDataTable, XFeaturesDataTable)


## STEP TWO: EXTRACT ONLY THE MEASUREMENTS ON MEAN AND STANDARD DEVIATION

muSigmaXFeaturesDataTableNames <- grep("mean\\(\\)|std\\(\\)", XFeaturesDataTableNames$V2, value = TRUE)

muSigmaXFeaturesDataTableNames <- union(c("Subject","Activity"), muSigmaXFeaturesDataTableNames)

harData <- subset(harData, select = muSigmaXFeaturesDataTableNames)


## STEP THREE: NAME THE ACTIVITIES IN THE DATA SET

activityNames <- read.table(file.path(filePath, "activity_labels.txt"), header = FALSE)
tableOfActivityNames <- tbl_df(activityNames)

colnames(tableOfActivityNames) <- c("ActivityID","Activity")

harData <- merge(tableOfActivityNames, harData, by.x = "ActivityID", by.y = "Activity", all = TRUE)

harData$Activity <- as.character(harData$Activity)


## STEP FOUR: LABEL THE DATA SET WITH DESCRIPTIVE VARIABLE NAMES

names(harData) <- gsub("^t", "Time", names(harData))
names(harData) <- gsub("^f", "Frequency", names(harData))
names(harData) <- gsub("BodyBody", "Body", names(harData))
names(harData) <- gsub("Acc", "Accelerometer", names(harData))
names(harData) <- gsub("Gyro", "Gyroscope", names(harData))
names(harData) <- gsub("Mag", "Magnitude", names(harData))
names(harData) <- gsub("mean()", "MEAN", names(harData))
names(harData) <- gsub("std()", "STDEV", names(harData))


## STEP FIVE: CREATE A 2ND, INDEPENDENT TIDY DATA SET WITH THE AVERAGE FOR EACH ACTIVITY AND SUBJECT

harData2nd <- aggregate(. ~ Subject + Activity, data = harData, mean)

harData2ndTable <- arrange(harData2nd, Subject, Activity)

write.table(harData2ndTable, file = "TidyData.txt", row.names = FALSE)




