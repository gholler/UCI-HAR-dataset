


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
 s- replace "," with "_"
 - replace "(" with "." and ")" with ""
 
We remove duplicate columns, obtaining 477 column. As we are only interested on 'mean' and 'std' values, we only retain columns that have 'mean' and 'std', ignoring case. We finally 90 measurements columns.

To uniquely identify each row, we add a sequence column row.id on X_train, y_train and subject_train.
We merge together y_train and activity_labels on activity.id, and then y_train and X_train on row.id to add activity label to X_train.
We add a column type that is repeatedly filled with 'train' for X_train. We reorganise data a bit to have all factor columns on the left, starting with type, and all measurements on the right.

We do the same with test sets, and merge X_train and Y_train in a 10299 rows long and 90 columns wide measures dataset.

We finally compute the mean of each measurement grouping by activity and subject to obtain the summary_measures.txt dataset that summarizes the previous dataset.

**Variables of summary_measures**
The resulting dataset has 2 factors:

 - activity : the activity label, which is one of:
 - subject.id : id of the person that took the test
 
 Remaining columns are the average of corresponding features in original dataset:

3                      tBodyAcc.mean.X
4                      tBodyAcc.mean.Y
5                      tBodyAcc.mean.Z
6                       tBodyAcc.std.X
7                       tBodyAcc.std.Y
8                       tBodyAcc.std.Z
9                   tGravityAcc.mean.X
10                  tGravityAcc.mean.Y
11                  tGravityAcc.mean.Z
12                   tGravityAcc.std.X
13                   tGravityAcc.std.Y
14                   tGravityAcc.std.Z
15                 tBodyAccJerk.mean.X
16                 tBodyAccJerk.mean.Y
17                 tBodyAccJerk.mean.Z
18                  tBodyAccJerk.std.X
19                  tBodyAccJerk.std.Y
20                  tBodyAccJerk.std.Z
21                    tBodyGyro.mean.X
22                    tBodyGyro.mean.Y
23                    tBodyGyro.mean.Z
24                     tBodyGyro.std.X
25                     tBodyGyro.std.Y
26                     tBodyGyro.std.Z
27                tBodyGyroJerk.mean.X
28                tBodyGyroJerk.mean.Y
29                tBodyGyroJerk.mean.Z
30                 tBodyGyroJerk.std.X
31                 tBodyGyroJerk.std.Y
32                 tBodyGyroJerk.std.Z
33                    tBodyAccMag.mean
34                     tBodyAccMag.std
35                 tGravityAccMag.mean
36                  tGravityAccMag.std
37                tBodyAccJerkMag.mean
38                 tBodyAccJerkMag.std
39                   tBodyGyroMag.mean
40                    tBodyGyroMag.std
41               tBodyGyroJerkMag.mean
42                tBodyGyroJerkMag.std
43                     fBodyAcc.mean.X
44                     fBodyAcc.mean.Y
45                     fBodyAcc.mean.Z
46                      fBodyAcc.std.X
47                      fBodyAcc.std.Y
48                      fBodyAcc.std.Z
49                 fBodyAcc.meanFreq.X
50                 fBodyAcc.meanFreq.Y
51                 fBodyAcc.meanFreq.Z
52                 fBodyAccJerk.mean.X
53                 fBodyAccJerk.mean.Y
54                 fBodyAccJerk.mean.Z
55                  fBodyAccJerk.std.X
56                  fBodyAccJerk.std.Y
57                  fBodyAccJerk.std.Z
58             fBodyAccJerk.meanFreq.X
59             fBodyAccJerk.meanFreq.Y
60             fBodyAccJerk.meanFreq.Z
61                    fBodyGyro.mean.X
62                    fBodyGyro.mean.Y
63                    fBodyGyro.mean.Z
64                     fBodyGyro.std.X
65                     fBodyGyro.std.Y
66                     fBodyGyro.std.Z
67                fBodyGyro.meanFreq.X
68                fBodyGyro.meanFreq.Y
69                fBodyGyro.meanFreq.Z
70                    fBodyAccMag.mean
71                     fBodyAccMag.std
72                fBodyAccMag.meanFreq
73            fBodyBodyAccJerkMag.mean
74             fBodyBodyAccJerkMag.std
75        fBodyBodyAccJerkMag.meanFreq
76               fBodyBodyGyroMag.mean
77                fBodyBodyGyroMag.std
78           fBodyBodyGyroMag.meanFreq
79           fBodyBodyGyroJerkMag.mean
80            fBodyBodyGyroJerkMag.std
81       fBodyBodyGyroJerkMag.meanFreq
82          angle.tBodyAccMean_gravity
83  angle.tBodyAccJerkMean_gravityMean
84     angle.tBodyGyroMean_gravityMean
85 angle.tBodyGyroJerkMean_gravityMean
86                 angle.X_gravityMean
87                 angle.Y_gravityMean
88                 angle.Z_gravityMean

