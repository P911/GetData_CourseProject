
# Preparation: Get the meta-information

# Read the feature description
features <- read.table("UCI HAR Dataset/features.txt",
                sep="", header=F, stringsAsFactors=F,
                col.names = c("feature.id", "feature.name"))
# Select only the mean() and std() measure (requirement 2.)
feature.selection <- features[grepl('mean\\(|std\\(', features$feature.name),]

# Read the activity labels
activities <- read.table("UCI HAR Dataset/activity_labels.txt",
                         sep="", header=F, stringsAsFactors=F,
                         col.names=c("activity.id", "activity"))

# Procedure / function to read a data set (either test or train) with
# the components a) Features b) Subjects c) Activity
read.activity.data <- function(type) {
        # a) Features / Measures
        d <- read.table(paste("UCI HAR Dataset/", type, "/X_", type, ".txt", sep=""),
                        sep="", header=F)
        # keep only the relevant measures (mean(), std(); requirement 2.)
        dsel <- d[,feature.selection$feature.id]
        # set column names according to meta-information (requirement 4.)
        names(dsel) <- feature.selection$feature.name
        
        # b) Subjects
        s <- read.table(paste("UCI HAR Dataset/", type, "/subject_", type, ".txt", sep=""),
                        sep="", header=F, col.names=c("subject"))
        # c) Activity
        a <- read.table(paste("UCI HAR Dataset/", type, "/y_", type, ".txt", sep=""),
                       sep="", header=F, col.names=c("activity"))
        # convert the activity ID vector to a factor (requirement 3.)
        a$activity <- factor(a$activity, activities$activity.id, activities$activity)
        # add columns from the different data frames and return the data frame
        cbind(s, a, dsel)
}

# read test and training data
testdata <- read.activity.data("test")
traindata <- read.activity.data("train")
# combine the data sets (requirement 1.)
activity.data <- rbind(testdata, traindata)

# create summary dataset (requirement 5.)

# functions to build the summary data frame
library(reshape2)

# melt for subject/activity and each variable
d_melt <- melt(activity.data, id=c("subject", "activity"),
               measure.vars=feature.selection$feature.name)
# aggregate via mean for subject/activity for each variable
activity.average <- dcast(d_melt, subject + activity ~ variable, mean)

# write the aggregated data used to submit to a text file
write.table(activity.average, "activity_average.txt", row.name=F)



