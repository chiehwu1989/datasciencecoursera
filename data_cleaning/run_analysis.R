library(dplyr)

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

# Download and decomporess the data set
dataSourceUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(dataSourceUrl,destfile="dataset.zip")
unzip(zipfile="dataset.zip",exdir="dataset")

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

# Load activity id to label mapping
activityLabels <- read.table(activityLabelFilePath)

# Load feature list
features <- read.table(featureFilePath)[,2]

# Load data set
testData <- loadData(testMeasurementFilePath, testSubjectFilePath, testActivityFilePath, activityLabels, features)
trainData <- loadData(trainMeasurementFilePath, trainSubjectFilePath, trainActivityFilePath, activityLabels, features)
# Merge test and training data sets
fullData <- rbind(testData, trainData)

# Get the average of each measurement in the given data set grouped by subjectId and activity
tidyData <- fullData %>% group_by(subjectId, activity) %>% summarise_all(mean) %>% as.data.frame()

# Write data to a file
write.table(tidyData, "TidyData.txt", row.names = FALSE)
