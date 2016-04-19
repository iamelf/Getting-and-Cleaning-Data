# run_analysis.R
# Clean workspace
rm(list=ls())
# Clean console
cat("\014") 

# Step Download files 
# setwd("C:/Users/Jie/Google Drive/Data Science/Course 3. Getting and Cleaning Data")
# fileUrl="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# download.file(fileUrl,destfile="Dataset.zip",method="libcurl")

# Set path
path<-file.path(getwd(),"UCI HAR Dataset")

# Read data
# Y consists of "Y_test" and "Y_train"
Y_test<-read.table(file.path(path, "test" , "Y_test.txt" ),header = FALSE)
Y_train<-read.table(file.path(path, "train" , "Y_train.txt" ),header = FALSE)

# X consists of "X_test" and "X_train"
X_test<-read.table(file.path(path, "test" , "X_test.txt" ),header = FALSE)
X_train<-read.table(file.path(path, "train" , "X_train.txt" ),header = FALSE)

# Subject consists of "Subject_test" and "Subject_train"
Subject_test<-read.table(file.path(path, "test" , "Subject_test.txt" ),header = FALSE)
Subject_train<-read.table(file.path(path, "train" , "Subject_train.txt" ),header = FALSE)

# Merge data
Y<-rbind(Y_train,Y_test)
X<-rbind(X_train,X_test)
Subject<-rbind(Subject_train,Subject_test)

rm(Y_test)
rm(Y_train)
rm(X_test)
rm(X_train)
rm(Subject_test)
rm(Subject_train)

# Name the variables
names(Subject)<-"Subject"
names(Y)<-"Activity"
X_Name<-read.table(file.path(path, "features.txt" ),header = FALSE)
names(X)<-X_Name$V2

# Subsetting columns with mean and std
X_Mean_STd<-X[,grep("mean\\(\\)|std\\(\\)",names(X))]
str(X_Mean_STd)
# Add column
X_Mean_STd<-cbind(X_Mean_STd,Subject)
X_Mean_STd<-cbind(X_Mean_STd,Y)

str(X_Mean_STd)

# Read activity labels
activityLabels <- read.table(file.path(path, "activity_labels.txt"),header = FALSE)
Data<-X_Mean_STd
rm(X_Mean_STd)

names(Data)<-gsub("^(t)", "time", names(Data))
names(Data)<-gsub("^(f)", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data) = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",names(Data))
names(Data)<-gsub("\\()","", names(Data))
names(Data)<-gsub("([Gg]ravity)","Gravity", names(Data))
names(Data)<-gsub("[-()]", '', names(Data))


# Create tidy data
tidyData<-aggregate(. ~Subject + Activity, Data, mean)
tidyData<-tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "tidydata.txt",row.name=FALSE)

library(knitr)
render("codebook.Rmd")
