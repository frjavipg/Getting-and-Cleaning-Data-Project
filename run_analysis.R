
# Merge the training and the test sets to create one data set.


library(reshape)
library(reshape2)

# Download the zip file from the web:

filename <- "getdata.zip"

fileURL <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

curl_download(fileURL, filename)



# Unzip the file:

unzip(filename) 

# Modify the route:

setwd('C:/Users/fprado/Documents/UCI HAR Dataset/');

# Load features.txt and activity_labels.txt:

features <- read.table('./features.txt',header=FALSE); #imports features.txt
activityType <- read.table('./activity_labels.txt',header=FALSE); #imports activity_labels.txt

# Cleaning up the variable names. To do this, extract only the measurements on the mean and standard deviation for each measurement. 

features_V2 <- as.character(features[,2])
featuresMeasure   <- grep(".*mean.*|.*std.*", features_V2 )
featuresMeasureNames  <- features[featuresMeasure ,2]
featuresMeasureNames  = gsub('-mean', 'Mean', featuresMeasureNames)
featuresMeasureNames  = gsub('-std', 'Std', featuresMeasureNames)
featuresMeasureNames <- gsub('[-()]', '', featuresMeasureNames)

# Load the other datasets:
subjectTrain <- read.table('./train/subject_train.txt',header=FALSE); #imports subject_train.txt
xTrain       <- read.table('./train/x_train.txt',header=FALSE) [featuresMeasure]; #imports x_train.txt
yTrain       <- read.table('./train/y_train.txt',header=FALSE); #imports y_train.txt

subjectTest <- read.table('./test/subject_test.txt',header=FALSE) ;#imports subject_test.txt
xTest       <- read.table('./test/x_test.txt',header=FALSE) [featuresMeasure];#imports x_test.txt
yTest       <- read.table('./test/y_test.txt',header=FALSE); #imports y_test.txt


# Naming columns for the imported data:

colnames(activityType)  = c('activityId','activityType');
colnames(subjectTrain)  = "subjectId";
colnames(xTrain)        = featuresMeasureNames;
colnames(yTrain)        = "activityId";
colnames(subjectTest)  = "subjectId";
colnames(xTest)        = featuresMeasureNames;
colnames(yTest)        = "activityId";



# Create the final test set by merging the xTest, yTest and subjectTest data.
DataTrain = cbind(yTrain,subjectTrain,xTrain);
# Create the final test set by merging the xTest, yTest and subjectTest data.
DataTest = cbind(yTest,subjectTest,xTest);
# Create the final  dataset by merging the DataTrain and DataTest data.
EndData = rbind(DataTrain, DataTest)




# Uses descriptive activity names to name the activities in the data set.
activityType[,2] <- as.character(activityType[,2])
EndData$activityId <- factor(EndData$activityId, levels = activityType[,1], labels = activityType[,2])
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
EndData$subjectId <- as.factor(EndData$subjectId)
EndDataMelt <- melt(EndData, id = c("activityId","subjectId"))
tidyData <- dcast(EndDataMelt, subjectId + activityId ~ variable, mean)
write.table(tidyData, file = "./tidy_data.txt",row.names = FALSE, quote = FALSE)


