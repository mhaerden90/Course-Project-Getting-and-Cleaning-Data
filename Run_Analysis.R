## Getting required packages
library(dplyr)

## Reading in files
testSubjectTest <-read.table("./UCI HAR Dataset/test/subject_test.txt")
testXtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
testYtest <- read.table("./UCI HAR Dataset/test/y_test.txt")

trainSubjectTest <-read.table("./UCI HAR Dataset/train/subject_train.txt")
trainXtest <- read.table("./UCI HAR Dataset/train/X_train.txt")
trainYtest <- read.table("./UCI HAR Dataset/train/y_train.txt")

features <- read.table("./UCI HAR Dataset/features.txt")


#adding column names to testXtest and trainXtest
columnNames <- features[,2]
names(testXtest) <- columnNames
names(trainXtest) <- columnNames

#Columnbinding test data and train data seperately

testData <- cbind(testSubjectTest, testYtest, testXtest)
trainData <- cbind(trainSubjectTest, trainYtest, trainXtest)

#rowbinding both sets together

allData <-rbind(testData, trainData)

#rename first two columns
names(allData)[1:2] <- c("Subject", "Activity")

#Extracting only columns regarding standard deviation (std) or mean - leaving Subject and Activity there as well, as they identify the case

allDataMeanStd <- allData[,grepl("Subject|Activity|std()|mean()", names(allData))]

#Factorising Labels and replacing levels with approriate values
allDataMeanStd$Activity <- as.factor(allDataMeanStd$Activity) 
levels(allDataMeanStd$Activity) <- c("Walking", "Walking upstairs", "Walking downstairs", "Sitting", "Standing", "Laying")

#creating new table with averages per subject and activity

meanOfSubjectperActivity <- allDataMeanStd %>%
  group_by(Subject, Activity) %>%
  summarise_all(funs(mean))

#creating file

write.table(meanOfSubjectperActivity, file = "GettingandCleaningDataProject.txt", row.names = FALSE)


