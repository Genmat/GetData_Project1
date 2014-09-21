setwd("D:/R/getdata")
dir()
library(data.table)
library(reshape2)
trainX <- read.table("./UCI HAR Dataset/train/X_train.txt")
trainY <- read.table("./UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
testX <- read.table("./UCI HAR Dataset/test/X_test.txt")
testY <- read.table("./UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
#Combine 
dataX <- rbind(testX, trainX)
dataY <- rbind(testY, trainY)
dataSub <- rbind(subject_test, subject_train)
#Extract mean and std
mestd<-sapply(c("mean()", "std()"), grep, features[,2], ignore.case=1)
mInd <-unlist(mestd)
#Rename
colnames(dataX) <- features[ ,2]
colnames(dataY) <- "Activity"
colnames(dataSub) <- "Subject"
#Filter X 
smdata <- dataX[ ,mInd]
activ <- c("Walking", "Walking UP", "Walking DOWN", "Sitting",
                "Standing", "Laying")
dataNameY <- dataY
colnames(dataNameY) <- "Activity"

for (i in 1:nrow(dataY)) {
  dataNameY[[1]][i] <- activ[dataY[[1]][i]]
}

dset <- cbind(dataSub, dataNameY, smdata)
dmelt <- melt(dset, id.vars = c("Activity", "Subject"))
datcast <- dcast(dmelt, Subject + Activity ~ variable, mean)

tidyData<- datcast
write.table(tidyData, "./tidyData.txt", sep="\t", row.name=FALSE)
