# Code Book

## Measurements
The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation

## Data set information

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

## Script explanation
### Download data
```
# Download and decomporess the data set
dataSourceUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(dataSourceUrl,destfile="dataset.zip")
unzip(zipfile="dataset.zip",exdir="dataset")
```

### Set up data file path variables
```
# Set up file path variables
dataSetRootPath <- file.path("dataset", "UCI HAR Dataset")
activityLabelFilePath <- file.path(dataSetRootPath, "activity_labels.txt")
featureFilePath <- file.path(dataSetRootPath, "features.txt")
# test data set file paths
testDataPath <- file.path(dataSetRootPath, "test")
testMeasurementFilePath <- file.path(testDataPath, "X_test.txt")
testSubjectFilePath <- file.path(testDataPath, "subject_test.txt")
testActivityFilePath <- file.path(testDataPath, "y_test.txt")
# training data set file paths
trainDataPath <- file.path(dataSetRootPath, "train")
trainMeasurementFilePath <- file.path(trainDataPath, "X_train.txt")
trainSubjectFilePath <- file.path(trainDataPath, "subject_train.txt")
trainActivityFilePath <- file.path(trainDataPath, "y_train.txt")
```
### Define method to load test and training data sets
```
# Function to load data set into a data frame and give it descriptive variable names and activity labels
loadData <- function(measurementFilePath, subjectFilePath, activityFilePath, activityLabels, features) {
  # A helper function to read suject and activity files
  loadFileHelper <- function(filePath) {
    f <- file(filePath)
    lines <- readLines(f)
    close(f)
    
    as.factor(lines)
  }
  
  # Load data set
  rawData <- read.table(measurementFilePath, col.names = features, check.names = FALSE)
  
  # Select only mean and standard deviation for each measurement
  data <- rawData[grep("mean\\(\\)|std\\(\\)", features)]
  
  # Load activity
  activityIds <- loadFileHelper(activityFilePath)
  
  # Maps activity id to labels and append it to the data set
  data["activity"] <- sapply(activityIds, function(activityId) activityLabels[activityId, 2])
  
  # Load subject
  subjectIds <- loadFileHelper(subjectFilePath)
  
  # Add subject id to the data set
  data["subjectId"] <- subjectIds
  
  data
}
```
### Load and merge test and training data sets
```
# Load data set
testData <- loadData(testMeasurementFilePath, testSubjectFilePath, testActivityFilePath, activityLabels, features)
trainData <- loadData(trainMeasurementFilePath, trainSubjectFilePath, trainActivityFilePath, activityLabels, features)
# Merge test and training data sets
fullData <- rbind(testData, trainData)
```
### Create an independent tidy data set with the average of each variable for each activity and each subject.
```
# Get the average of each measurement in the given data set grouped by subjectId and activity
tidyData <- fullData %>% group_by(subjectId, activity) %>% summarise_all(mean) %>% as.data.frame()
```
### Output tidy data information
```
# Write data to a file
write.table(tidyData, "TidyData.txt", row.names = FALSE)
```
The tidy data includes averages of each measurement for each activity and each subject. In total of 10299 observations and splited into 180 group (30 subjects + 6 activities). 66 mean and standard deviation measurements. The data table has 180 rows and 68 columns, 1 subject id, 1 activity labels and 66 measurements. The 1st line of the output is the header of each column.