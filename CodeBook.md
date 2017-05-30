


> Written with [StackEdit](https://stackedit.io/).

**Introduction**
This dataset is a tidier and summarised version of a dataset from  Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz ( *A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013). see http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones for details of original work.

This codebook explain how features were selected in original work, original dataset quality issues, transformations that where made, and variables of resulting dataset.

**Feature Selection in original dataset** 
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, the original research team captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation

Other variables where derived in original work that have been omitted in present work. We recall them just for the record :
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

The complete list of variables of each feature vector is available in 'features.txt' .

**Original Dataset Quality issues**

We can see that the unit of observation is a 2,56 sec sliding window of a specified activity of a given subject. These observations are split in 2 groups: one is a training group, one is a test group.
The first and perhaps biggest problem that we can see is that the set of all observations, for a given group (say the training group) is split in several dataset files:

 - X_train.txt provides all measurements for the train group
 - y_train.txt provides all matching activty ids (one for each observation)
 - subject_train.txt provides all matching subject id (one for each observation)
 
 Furthermore, one has to lookup to yet another file (actity_labels.txt) to have the label of each activity id.
 
Second problem is the X_train.txt, which captures the features in a simple space separated values file, has no header line that links values to features. We assume that the 561 columns correspond to each feature of the 561 lines long features.txt in corresponding order. We have to give a meaningful name to each measurement variable, and the obvious way would be to use the names found in features.txt. Some features have awkward notations, with ",",  and "(", that we will have to deal with to obtain an easy to manipulate dataset. 

Third, by counting unique features in features.txt, we can see that the 561 features correspond to 477 *unique* features, so we have to assume that matching columns are duplicated in X_train.txt.
 
Fourth, we can see that we have a separate sets of files for each group of observations of the same type. Overall dataset would be easier to analyse if we merge training and test data.  

**DataSet transformations**
The first step was to obtain a tidy dataset that merge all files together with the same level of details.

For this, we first use feature names for X_train.txt columns. To make column names easier to understand and manipulate, we do some transformations in order:

 - replace "()" with ""
 - replace "-" with "."
 - replace "," with "_"
 
As we are only interested on mean and std variables, we only retain columns that have 'mean()' and 'std()'. We finally get 66 measurements columns.
 
We bind together to X_train the columns of y_train and subject_train to add activity.id and subject.id to each row. We then join X_train and activity_labels on activitiy.id to get the activity label.

We do the same with test sets, and merge X_train and Y_train in a 10299 rows long and 68 columns wide measures dataset.

We finally compute the mean of each measurement grouping by activity and subject to obtain the summary_measures.txt dataset that summarizes the previous dataset.

**Variables of summary_measures**
The resulting dataset has 2 factors:

 - activity : the activity label, which is one of:
  -  WALKING
 -  WALKING_UPSTAIRS
 -  WALKING_DOWNSTAIRS
 -  SITTING
 -  STANDING
 -  LAYING
 
 - subject.id : id of the person that took the test. An integer between 1 and 30
 
 Remaining columns are the mean of corresponding features in original dataset:

-  tBodyAcc.mean.X
-  tBodyAcc.mean.Y
-  tBodyAcc.mean.Z
-  tBodyAcc.std.X
-  tBodyAcc.std.Y
-  tBodyAcc.std.Z
-  tGravityAcc.mean.X
-  tGravityAcc.mean.Y
-  tGravityAcc.mean.Z
-  tGravityAcc.std.X
-  tGravityAcc.std.Y
-  tGravityAcc.std.Z
-  tBodyAccJerk.mean.X
-  tBodyAccJerk.mean.Y
-  tBodyAccJerk.mean.Z
-  tBodyAccJerk.std.X
-  tBodyAccJerk.std.Y
-  tBodyAccJerk.std.Z
-  tBodyGyro.mean.X
-  tBodyGyro.mean.Y
-  tBodyGyro.mean.Z
-  tBodyGyro.std.X
-  tBodyGyro.std.Y
-  tBodyGyro.std.Z
-  tBodyGyroJerk.mean.X
-  tBodyGyroJerk.mean.Y
-  tBodyGyroJerk.mean.Z
-  tBodyGyroJerk.std.X
-  tBodyGyroJerk.std.Y
-  tBodyGyroJerk.std.Z
-  tBodyAccMag.mean
-  tBodyAccMag.std
-  tGravityAccMag.mean
-  tGravityAccMag.std
-  tBodyAccJerkMag.mean
-  tBodyAccJerkMag.std
-  tBodyGyroMag.mean
-  tBodyGyroMag.std
-  tBodyGyroJerkMag.mean
-  tBodyGyroJerkMag.std
-  fBodyAcc.mean.X
-  fBodyAcc.mean.Y
-  fBodyAcc.mean.Z
-  fBodyAcc.std.X
-  fBodyAcc.std.Y
-  fBodyAcc.std.Z
-  fBodyAccJerk.mean.X
-  fBodyAccJerk.mean.Y
-  fBodyAccJerk.mean.Z
-  fBodyAccJerk.std.X
-  fBodyAccJerk.std.Y
-  fBodyAccJerk.std.Z
-  fBodyGyro.mean.X
-  fBodyGyro.mean.Y
-  fBodyGyro.mean.Z
-  fBodyGyro.std.X
-  fBodyGyro.std.Y
-  fBodyGyro.std.Z
-  fBodyAccMag.mean
-  fBodyAccMag.std
-  fBodyBodyAccJerkMag.mean
-  fBodyBodyAccJerkMag.std
-  fBodyBodyGyroMag.mean
-  fBodyBodyGyroMag.std
-  fBodyBodyGyroJerkMag.mean
-  fBodyBodyGyroJerkMag.std
