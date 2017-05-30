# make sure environment is clean
rm(list = ls())
#load used libraries
library(dplyr)
library(tidyr)


## load reference data frames
features <- read.csv("features.txt", header = FALSE, sep=" ")
nrow(features)
names(features) <- c("id", "feature")
activities <- read.csv("activity_labels.txt", head=FALSE, sep=" ")
names(activities) <- c("id", "activity")

## load a given file into a data table
load_table <- function (file) {
    tbl_df(read.table(file))
}

## loading of experiments
X_train <- load_table("train/X_train.txt")
X_test <- load_table("test/X_test.txt")

# give significant names to variables 
# columns are actually features in the same order
names(X_train) <- features$feature 
names(X_test) <- features$feature


# we want to focus on mean() and std() variables
variables_of_interest <- function(X_ds) {
    X_ds[, grep("mean\\(\\)|std\\(\\)", names(X_ds), value = TRUE)]
}
X_train <- variables_of_interest(X_train)
X_test <- variables_of_interest(X_test)

# rearrange names to be more readable or ease further operations
# remove parenthesis
rename_columns <- function (X_ds) {
    cnames <- names(X_ds)
    # replace "()" with ""
    cnames <- gsub("\\(\\)","", cnames)
    # replace "-" with "dots"."
    cnames <- gsub("-",".", cnames)
    # replace "," with "_"
    cnames <- gsub(",","_", cnames)
    names(X_ds) <- cnames
    X_ds
}
X_train <- rename_columns(X_train)
X_test <- rename_columns(X_test)

# at this point, it appears that some columns are duplicated : remove dusplicates
# df is any dataframe whose columns are potentially duplicated
#deduplicate_columns <- function(df) {
#    df[, !duplicated(names(df))]
#}
#X_train <- deduplicate_columns(X_train)
#X_test <- deduplicate_columns(X_test)


# add the subject of the experiment
# X_ds the given test or train dataset
# subject_file the path of the matching subject file
add_subject <- function (X_ds, subject_file) {
    subjects <- load_table(subject_file)
    names(subjects) <- "subject.id"
    cbind (subjects, X_ds)
}
X_train <- add_subject(X_train, "train/subject_train.txt")
X_test <- add_subject(X_test, "test/subject_test.txt")



## add activity label column to a train or test dataset
# X_ds is the train or test dataset
# y_file is the name of the matching y_file
add_activity_label <- function (X_ds, y_file) {
    # join the activity label of each experiment
    y_ds <- load_table(y_file)
    names(y_ds) <- "activity.id"

    # add columns from both tables
    X_ds <- cbind(y_ds, X_ds)
    
    # add label activity to X_ds by merging with table activities
    X_ds <- merge(X_ds, activities, by.x = "activity.id", by.y="id")

    select(X_ds, -activity.id)
}
X_train <- add_activity_label(X_train, "train/y_train.txt")
X_test <- add_activity_label(X_test, "test/y_test.txt")


## merge datasets in a new measures datasets
measures <- X_train
measures <- rbind(measures, X_test)

# free some memory
free_workspace <- function() {
    rm(X_train)
    rm(X_test)
    rm(features)
    rm(activities)
    
}
#free_workspace()


## create a summary_measures that summarize the average of measurements per activity and subjects
summary_measures <- measures %>% 
    group_by(activity, subject.id) %>%
    summarise_all(mean)

# write down the dataset to a file
write.table(summary_measures, file = "summary_measures.txt", row.names = FALSE)

