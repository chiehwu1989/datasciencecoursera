library(dplyr)

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

prepareFullDataSet <- function(dataFilePaths, activityLabelFilePath, featureFilePath) {
  # Load activity id to label mapping
  activityLabels <- read.table(activityLabelFilePath)
  
  # Load feature list
  features <- read.table(featureFilePath)[,2]
  
  fullData <- data.frame()
  for (i in 1:nrow(dataFilePaths)) {
    # Combine data sets
    fullData <- rbind(fullData, loadData(dataFilePaths[i,1], dataFilePaths[i,2], dataFilePaths[i,3], activityLabels, features))
  }
  
  fullData
}

getAverage <- function(data) {
  # Get the average of each measurement in the given data set grouped by subjectId and activity
  data %>% group_by(subjectId, activity) %>% summarise_all(mean) %>% as.data.frame()
}
