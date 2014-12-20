Description of the produced data frames
=======================================


data frame "activity.data"
--------------------------

The data consists of the following variables:

- subject: Subject number (1..30)
- activity: factor that describes the activity
- rest: mean()/std() measure from the original data files
  the units are standard gravity units 'g' for the acceleration measures
  and radians/second for the gyroscope measures. The measure type
  can be derived by the column names.


data frame "activity.average"
-----------------------------

The data is aggregated from "activity.data" with the same columns.
For the aggregation, the mean was used as the summary function.


Description of the procedure to produced the data frames
========================================================


Steps are taken to prepare the data frame "activity.data"
---------------------------------------------------------

- Read the feature description (column description) from the
  source data files.
- As the data frames should only include the mean "mean()" and
  standard deviation "std()"
  measures, those features are selected, using the feature names from
  the source file.
- Likewise, the mapping from activity class to activty name is read
  from the source file. This mapping is later used to cast the
  activty class numbers as a factor variable.

- Next, the actual data is read: For each sub data set ("test", "train"),
  three data files are used:
  - X_{test,train}.txt: The measures (alias features) for the observations.
  - subject_{test,train}.txt: The number (1..30) of the subject for
    the observation.
  - y_{test,train}.txt: The activity label.
- While the subject number can be used as is, the other two data sets
  are processed:
  - The measures are restricted to the mean()/std() measures.
  - The activity label is converted to a factor using the activity
    names provided in the source files.
- From those data sets, the script creates a column-combined data frame.
- When the steps above are executed for the test as well as the training
  data sets, the "activity.data" data frame is produced by combining
  the rows from the two data frames.


Steps are taken to prepare the data frame "activity.average"
---------------------------------------------------------

- The data frame "activity.data" is first melted. That means the
  data frame is transposed to contain the columns subject, activity,
  variable, and the value for the variable.
- This transpose data frame is then converted back into the
  form of "activity.data", but aggregated per subject and activity.
  - As aggregation/summary function, the mean of the values is used.
- For this two step procedure, the library "reshape2" is used.

