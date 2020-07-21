library(dplyr)
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
file_name<-"course3_project.zip"
# Folder download from web
download.file(url,file_name)

# Unzip the folder
unzip(file_name)

feature_tbl<-read.table("features.txt",col.names=c("num","feature"))
activity<-read.table("activity_labels.txt",col.name=c("code","activity_name"))
subject_test<-read.table("test/subject_test.txt",col.names="subject")
x_test_tbl<-read.table("test/X_test.txt",header=FALSE,col.names =feature_tbl$feature )

y_test_tbl<-read.table("test/y_test.txt",col.names = "code")
#train data
subject_train<-read.table("train/subject_train.txt",col.names="subject")
x_train_tbl<-read.table("train/X_train.txt",header=FALSE,col.names =feature_tbl$feature )
y_train_tbl<-read.table("train/y_train.txt",col.names = "code")


# Added all rows of  test and train data 
x<-rbind(x_test_tbl,x_train_tbl) 
y<-rbind(y_test_tbl,y_train_tbl)
subject<-rbind(subject_test,subject_train)

# To merge X,Y and subject files
complete_data<-cbind(x,y,subject)

#Select only mean and standard division variables
final_data <- complete_data %>% select(subject, code, contains("mean"), contains("std"))

# Replace activity code with activity name from activity labels
final_data<-left_join(final_data,activity_tbl,by="code")
final_data<-select(final_data,-code)


#To give descriptive names to variables
names(final_data)<-gsub("Acc", "Accelerometer", names(final_data))
names(final_data)<-gsub("^t", "Time", names(final_data))
names(final_data)<-gsub("Gyro", "Gyroscope", names(final_data))
names(final_data)<-gsub("BodyBody", "Body", names(final_data))
names(final_data)<-gsub("Mag", "Magnitude", names(final_data))
names(final_data)<-gsub("angle", "Angle", names(final_data))
names(final_data)<-gsub("^f", "Frequency", names(final_data))
names(final_data)<-gsub("tBody", "TimeBody", names(final_data))
names(final_data)<-gsub("-std()", "STD", names(final_data))
names(final_data)<-gsub("-freq()", "Frequency", names(final_data))
names(final_data)<-gsub("-mean()", "Mean", names(final_data))
names(final_data)<-gsub("gravity", "Gravity", names(final_data))

#Mean of each variable for each activity and subject
mean_dataset<-group_by(final_data,subject,activity_name)
mean_dataset<-mean_dataset %>% summarise_all(funs(mean))
write.table(mean_dataset, "Result.txt", row.name=FALSE)                                            
