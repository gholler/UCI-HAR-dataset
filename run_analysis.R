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
names(activities) <- c("id", "label")

## load a given file into a data table
load_table <- function (file) {
    tbl_df(read.table(file))
}

## loading of experiments
X_train <- load_table("train/X_train.txt")
X_test <- load_table("test/X_test.txt")

## give significant names to columns of training or test dataset
# columns are actually features in the same order
cnames <- features$feature 
## rearrange names to ease further operations
# remove parenthesis
cnames <- gsub("\\(\\)","", cnames)
# replace "-" with "dots"."
cnames <- gsub("-",".", cnames)
# replace "," with "_"
cnames <- gsub(",","_", cnames)
# replace reamining "\\(" with "." like in angle(...,...)
cnames <- gsub("\\(",".", cnames)
# replace remaining "\\)" with ""
cnames <- gsub("\\)","", cnames)
names(X_train) <- cnames
names(X_test) <- cnames

# at this point, it appears that some columns are duplicated : remove dusplicates
# df is any dataframe whose columns are potentially duplicated
deduplicate_columns <- function(df) {
    df[, !duplicated(names(df))]
}
X_train <- deduplicate_columns(X_train)
X_test <- deduplicate_columns(X_test)

# then, we want to focus on mean and std variables
variables_of_interest <- function(X_ds) {
    X_ds[, grep("\\.mean|Mean|\\.std|Std", names(X_ds), value = TRUE)]
}
X_train <- variables_of_interest(X_train)
X_test <- variables_of_interest(X_test)


## identify each test or train dataset row by an unique sequential id. The resulting column is named row.id
add_seq_id <- function (X_ds) {
    cbind(X_ds, row.id=seq(1, nrow(X_ds), 1))
}
X_train <- add_seq_id(X_train)
X_test <- add_seq_id(X_test)

## add activity label column to a train or test dataset
# X_ds is the train or test dataset
# y_file is the name of the matching y_file
add_activity_label <- function (X_ds, y_file) {
    # join the activity label of each experiment
    y_ds <- load_table(y_file)
    names(y_ds) <- "activity.id"
    # each row of y_ds identies the activity on the matching row of X_ds
    y_ds <- cbind(y_ds, row.id=seq(1, nrow(y_ds), 1)) 
    # add label activity to y_ds by merging with table activities
    y_ds <- merge(y_ds, activities, by.x = "activity.id", by.y="id")
    #merge/join X_ds and y_ds on row.id to add label activity to each experiment
    merge(X_ds, y_ds)
    
}
X_train <- add_activity_label(X_train, "train/y_train.txt")
X_test <- add_activity_label(X_test, "test/y_test.txt")

# add the subject of the experiment
# X_ds the given test or train dataset
# subject_file the path of the matching subject file
add_subject <- function (X_ds, subject_file) {
    subjects <- load_table(subject_file)
    names(subjects) <- "subject.id"
    subjects <- cbind(subjects, row.id=seq(1, nrow(subjects), 1))
    # merge on row.id to add subject.id to X_ds
    merge(X_ds, subjects, by.x="row.id", by.y="row.id")
}
X_train <- add_subject(X_train, "train/subject_train.txt")
X_test <- add_subject(X_test, "test/subject_test.txt")

## add a type column that identifies if a given experiment is a test or training
# X_ds is the given dataset
# type is the type of experiment that this dataset records. Either "test" or "train"
add_type <- function (X_ds, type) {
    cbind(X_ds, type=rep(type,nrow(X_ds)))
}
X_train <- add_type(X_train, "train")
X_test <- add_type(X_test, "test")

# reorder columns and rename some so that measurements are on the right
reorder_columns <- function(X_ds) {
    # rename activity label,  drop redundant activity.id. Columns 2 to 87 are measurements
    select(X_ds, type, row.id,activity=label,subject.id, 2:87)
}

X_train <- reorder_columns(X_train)
X_test <- reorder_columns(X_test)

## merge datasets in a new measures datasets
measures <- X_train
measures <- rbind(measures, X_test)


## create a summary_measures that summarize the average of measurements per activity and subjects
# we have to get rid of type and row.id that uniquely identify each row 
summary_measures <- measures %>% select(-row.id, -type) %>% group_by(activity, subject.id) %>% summarise_all(mean)

# write down the dataset to a file
write.table(summary_measures, file = "summary_measures.txt", row.names = FALSE)

