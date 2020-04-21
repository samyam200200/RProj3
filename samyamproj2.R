#Assigning variable names from downloaded files
features<-read.table("UCI HAR Dataset/features.txt", col.names = c("S.n", "Columnnames"))
x_test<-read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$Columnnames)
y_test<-read.table("UCI HAR Dataset/test/Y_test.txt", col.names=c("Code"))
x_train<-read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$Columnnames)
y_train<-read.table("UCI HAR Dataset/train/Y_train.txt", col.names=c("Code"))
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt", col.names=c("Subject"))
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt",col.names=c("Subject"))
activities<-read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

#Merges the training and the test sets to create one data set.
X<-rbind(x_test, x_train)
Y<-rbind(y_test, y_train)
subject<-rbind(subject_test, subject_train)

library(dplyr)

#Extracts only the measurements on the mean and standard deviation for each measurement.
code<-grep("mean()|std()", features[,2])
final<-X[,code]

#Uses descriptive activity names to name the activities in the data set
final1<-cbind(final,Y,subject)
final1$Code<-activities[final1$Code, 2]


#Appropriately labels the data set with descriptive variable names.
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

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
FinalData <- final1 %>%
  group_by(activity,Subject) %>%
  summarise_all(mean)
write.table(FinalData, "FinalData.txt", row.name=F)


