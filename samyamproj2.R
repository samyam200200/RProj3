fileName <- "UCIdata.zip"
url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dir <- "UCI HAR Dataset"


if(!file.exists(fileName)){
  download.file(url,fileName, mode = "wb") 
}


if(!file.exists(dir)){
  unzip("UCIdata.zip", files = NULL, exdir=".")
}

features<-read.table("UCI HAR Dataset/features.txt", col.names = c("S.n", "Columnnames"))
x_test<-read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$Columnnames)
y_test<-read.table("UCI HAR Dataset/test/Y_test.txt", col.names=c("Code"))
x_train<-read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$Columnnames)
y_train<-read.table("UCI HAR Dataset/train/Y_train.txt", col.names=c("Code"))
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt", col.names=c("Subject"))
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt",col.names=c("Subject"))
activities<-read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
X<-rbind(x_test, x_train)
Y<-rbind(y_test, y_train)
subject<-rbind(subject_test, subject_train)

library(dplyr)

code<-grep("mean()|sd()", features[,2])
final<-X[,code]


final1<-cbind(final,Y,subject)
final1$Code<-activities[final1$Code, 2]

colnames(final1)[47] = "activity"
colnames(final1)<-gsub("Acc", "Accelerometer", colnames(final1),ignore.case = TRUE)
colnames(final1)<-gsub("Gyro", "Gyroscope", colnames(final1),ignore.case = TRUE)
colnames(final1)<-gsub("BodyBody", "Body", colnames(final1),ignore.case = TRUE)
colnames(final1)<-gsub("Mag", "Magnitude", colnames(final1),ignore.case = TRUE)
colnames(final1)<-gsub("^t", "Time", colnames(final1))
colnames(final1)<-gsub("^f", "Frequency", colnames(final1))
colnames(final1)<-gsub("tBody", "TimeBody", colnames(final1),ignore.case = TRUE)
colnames(final1)<-gsub("-mean()", "Mean", colnames(final1), ignore.case = TRUE)
colnames(final1)<-gsub("-std()", "STD", colnames(final1), ignore.case = TRUE)
colnames(final1)<-gsub("-freq()", "Frequency", colnames(final1), ignore.case = TRUE)
colnames(final1)<-gsub("angle", "Angle", colnames(final1),ignore.case = TRUE)
colnames(final1)<-gsub("gravity", "Gravity", colnames(final1),ignore.case = TRUE)


FinalData <- final1 %>%
  group_by(activity,Subject) %>%
  summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=F)


