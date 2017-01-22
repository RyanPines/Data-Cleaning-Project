---
title: "Getting and Cleaning Data Course Project"
author: "Ryan Pines"
date: "January 21, 2017"
output: html_document
---

## Description and Purpose of the Course Project

The purpose of this project is to collect, work with, and clean the following data set: "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" (UCI HAR Dataset)

More information about the data set is included in the code book "CodeBook.md"

## Purpose of the run_analysis.R script

The run_analysis.R script does the following tasks

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set.
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Pre-requisities

* UCI HAR Dataset, which should contain the following files and folders: "test" folder, "train" folder, "activity_labels.txt" file, "features.txt" file, 
"features_info.txt" file

* The following packages should be installed and downloaded: dplyr, tidyr, data.table


## run_analysis.R overview and output

The following will have an overview of the 5 steps, as well as the final output.

###Step One:
* Read in the following files: "subject_train.txt", "subject_test.txt", "Y_train.txt", "Y_test.txt", "X_train.txt", "X_test.txt"
* Combine the rows of the "subject_train.txt" and "subject_test.txt" files, the "Y_train.txt" and "Y_test.txt" files, and the "X_train.txt" and "X_test.txt" files to form 3 different data sets.
* Provide variable names for the 3 data sets.
* Combine the columns of the 3 data sets from above to form one big data set.

###Step Two:
* Extract the measurements on only mean and standard deviation from the main data set created from step One by using the grep() function.

###Step Three:
* Read in the "activity_labels.txt" file as a table
* Merge the "activity_labels.txt" table with the main data set by joining on the "ActivityID" colum
* As a result, the Activity Names in the main data set will now have labels.

###Step Four:
* Using the gsub() function, replace most of the current variable names with more descriptive variable names (For example, replace "Acc" with "Accelerator").

###Step Five:
* Use the aggregate() function to find the mean for each subject and activity combination in the main data set
* Arrange the order of the variables in the data set
* Write the output in a text file using the write.table() function

**The Output** is a text file called "tidydata.txt". This file is an independent tidy data set with the average for each activity and each subject
