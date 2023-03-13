#######################################################################################################
##  COURSERA JOHN HOPKINS UNIVERSITY GETTING AND CLEANING DATA COURSE PROJECT      
##  By: JOSEPH BLOOMQUIST
##
## 1: You should create one R script called run_analysis.R that does the following. 
##
## 2: Merges the training and the test sets to create one data set.
##
## 3: Extracts only the measurements on the mean and standard deviation for each measurement. 
##
## 4: Uses descriptive activity names to name the activities in the data set
##
## 5: Appropriately labels the data set with descriptive variable names. 
##
## 6: From the data set in step 4, creates a second, independent tidy data set 
##      with the average of each variable for each activity and each subject.
##
#######################################################################################################
library(dplyr)
library(data.table)

##Import and extract the data
currentDir <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(currentDir, "UCI_HAR_DATA.zip"))
unzip(zipfile = "UCI_HAR_DATA.zip")
downloadedDate <- date() 

#Make sure we can see the files and directory
dir("./UCI HAR Dataset/")

#Creating var to make path easy to repeat
mainDir <- "/UCI HAR Dataset"


##Begin extraction

#Main Directory
activityPath <- file.path(paste0(currentDir, mainDir),"activity_labels.txt")
activityLabels <- fread(activityPath, col.names = c("aIndex", "Activities"))

featurePath <- file.path(paste0(currentDir, mainDir),"features.txt")
features <- fread(featurePath, col.names = c("fIndex", "Features"))
#Remove Index from feature 
i <- 1
nFeatures <- vector()
while (i<=561) {
  nFeatures[i] <- features[i,2]
  i = i + 1
}
#Since its a list, return it back into a character vector so we can use it as names.
nFeatures <- unlist(nFeatures)


#Test Directory
subjectTestPath <- file.path(paste0(currentDir, testDir),"subject_test.txt")
subjectTest <- fread(subjectTestPath, col.names = "Subject")

xTestPath <- file.path(paste0(currentDir, testDir),"x_test.txt")
xTest <- fread(xTestPath, col.names = nFeatures)

yTestPath <- file.path(paste0(currentDir, testDir),"y_test.txt")
yTest <- fread(yTestPath, col.names = "aIndex")

test <- cbind(yTest, subjectTest, xTest)

#Train Directory
subjectTrainPath <- file.path(paste0(currentDir, trainDir),"subject_train.txt")
subjectTrain <- fread(subjectTrainPath, col.names = "Subject")

xTrainPath <- file.path(paste0(currentDir, trainDir),"x_train.txt")
xTrain <- fread(xTrainPath, col.names = nFeatures)

yTrainPath <- file.path(paste0(currentDir, trainDir),"y_train.txt")
yTrain <- fread(yTrainPath, col.names = "aIndex")

train <- cbind(yTrain, subjectTrain, xTrain) 

#All Data
allData <- rbind(train, test)




#Filter just mean and std
meanVector <- select(allData, contains("mean"))
stdVector <- select(allData, contains("std"))
filteredData <- cbind(meanVector, stdVector)
#filteredData is final product for mean and std

#creates a second, independent tidy data set 
##with the average of each variable for each activity and each subject.
totalAvgData <- as.data.frame(colMeans(filteredData))

# write final tidy data into new file
fwrite(totalAvgData, file="totalAverageData.txt")
View(totalAvgData)


