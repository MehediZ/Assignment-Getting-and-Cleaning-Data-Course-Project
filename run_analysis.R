library(dplyr)

# Read the training data

x_train <-read.table("./train/X_train.txt", header = FALSE, sep = "", dec = ".")
y_train <- read.table("./train/y_train.txt", header = FALSE, sep = "", dec = ".")
subj_train <-read.table("./train/subject_train.txt", header = FALSE, sep = "", dec = ".")

## Read the test data
x_test <-read.table("./test/X_test.txt", header = FALSE, sep = "", dec = ".")
y_test <- read.table("./test/y_test.txt", header = FALSE, sep = "", dec = ".")
subj_test <-read.table("./test/subject_test.txt", header = FALSE, sep = "", dec = ".")

## part 1: marging the training and test data to create one dataset

x_marged <- rbind(x_train, x_test)
y_marged <- rbind(y_train, y_test)
sub_marged <- rbind(subj_train, subj_test)

## part 2: Extracts only the measurements on the mean and standard deviation for each measurement

## Read features and activity labels
features <- read.table("./features.txt")
act_labels <- read.table("./activity_labels.txt")

## creating feature list having mean and stdev for each measurement

features_list <- features[grep("\\bmean()\\b|\\bstd()\\b", features[, 2]), ]
x_marged <- x_marged[, features_list[, 1]]

## part - 3: Uses descriptive activity names to name the activities in the data set

colnames(y_marged) <- "activity"
y_marged$activity <- factor(y_marged$activity, labels = act_labels[, 2])


## part - 4: Appropriately labels the data set with descriptive variable names. 
colnames(x_marged) <- features_list[, 2]

## part - 5: From the data set in step 4, creates a second, independent
## tidy data set with the average of each variable for each activity and each subject.
colnames(sub_marged) <- "subject_id"
final_data <- cbind(sub_marged, y_marged, x_marged)

final_mean <- final_data %>% group_by(subject_id, activity) %>%
        summarize_each(funs(mean))

write.table(final_mean, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE)

list_columns <- colnames(final_mean)
write.table(list_columns, file = "./list_columns.txt", row.names = FALSE, col.names = TRUE)







































