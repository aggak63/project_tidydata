## Project Work for Getting and Cleaning Data
fileURL<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "dataset.zip", method = "curl")
## Following unzip functions didnot work and returned error 1. Checked from stackoverflow,
##but found many others have same problem and could not solve

##unzip("dataset.zip", files = NULL, list = FALSE, overwrite = TRUE,
      ##junkpaths = FALSE, exdir = ".", unzip = "internal",
      ##setTimes = FALSE)
##unzip("dataset.zip")

## Therefoe, unzipped locally in my folder.
## Read everything about processing text files 
## https://en.wikibooks.org/wiki/R_Programming/Text_Processing
setwd("~/Desktop/R/UCI/test")
##t1<-scan("subject_test.txt",sep ="\n")
##t2<- scan("x_test.txt", quote = NULL)
##t2<- scan("x_test.txt", sep = "\n")
### test outputs

## class(t1)
## [1] "numeric"
## > length(t1)
## [1] 2947
## > str(t1)
## num [1:2947] 2 2 2 2 2 2 2 2 2 2 ...

## length(t2)
## [1] 1653267
## > class(t2)
## [1] "numeric"
## > str(t2)
## num [1:1653267] 0.2572 -0.0233 -0.0147 -0.9384 -0.9201 ..

## above outputs were not correct. thus used readLines function
t1<-readLines("subject_test.txt")
t2<- readLines("x_test.txt")
t3<- scan("y_test.txt")

## output of above
##head(t1)
##[1] "2" "2" "2" "2" "2" "2"
##> class(t1)
##[1] "character"
##> length(t1)
##[1] 2947
##> length(t2)
##[1] 2947
##> t1<-readLines("subject_test.txt")
##> t3<- readLines("y_test.txt")
##> head(t3)
##[1] "5" "5" "5" "5" "5" "5"
##> length(t3)
##[1] 2947

## strategy that worked finally for TEST DATA
## read test data file in table, form groups based on mean and Sd data and then join groups

setwd("~/Desktop/R/UCI/test")
testdata = read.table("x_test.txt")
t1gp<- testdata[, 1:6]
t2gp<- testdata[, 41:46]
t3gp<- testdata[, 81:86]
t4gp<- testdata[, 121:126]
t5gp<- testdata[, 161:166]
t6gp<- testdata[, 227:228]
t7gp<- testdata[, 266:271]
t8gp<- testdata[, 345:350]
t9gp<- testdata[, 424:429]
t10gp<- testdata[, 503:504]
t11gp<- testdata[, 529:530]
t12gp<- testdata[, 542:543]
t13gp<- testdata[, 556:561]
tgp<-data.table(t1gp, t2gp, t3gp,t4gp,t5gp,t6gp,t7gp,t8gp,t9gp,t10gp,t11gp,t12gp,t13gp)

## Read subject data and rename the column name from V1 to testsubID
test_sub<-read.table("subject_test.txt")
test_sub<-select(test_sub, ID = V1)

## read y_test text and rename the variable V1
test_yID<-read.table("y_test.txt")
test_yID<-select(test_yID, ActivityID = V1)

## join all test files
test <- data.table(test_yID, test_sub,tgp)

### For training data, read file and and extract columns with means and SD and join gps
setwd("~/Desktop/R/UCI/train")
traindata = read.table("x_train.txt")
tr1gp<- traindata[, 1:6]
tr2gp<- traindata[, 41:46]
tr3gp<- traindata[, 81:86]
tr4gp<- traindata[, 121:126]
tr5gp<- traindata[, 161:166]
tr6gp<- traindata[, 227:228]
tr7gp<- traindata[, 266:271]
tr8gp<- traindata[, 345:350]
tr9gp<- traindata[, 424:429]
tr10gp<- traindata[, 503:504]
tr11gp<- traindata[, 529:530]
tr12gp<- traindata[, 542:543]
tr13gp<- traindata[, 556:561]
trgp<-data.table(tr1gp, tr2gp, tr3gp,tr4gp,tr5gp,tr6gp,tr7gp,tr8gp,tr9gp,tr10gp,tr11gp,tr12gp,tr13gp)

## Read subject data and rename the column name from V1 to subID
tr_sub<-read.table("subject_train.txt")
tr_sub<-select(tr_sub, ID = V1)

## read y_train text and rename the variable
tr_yID<-read.table("y_train.txt")
tr_yID<-select(tr_yID, ActivityID = V1)

## join all training files
train <- data.table(tr_yID, tr_sub, trgp)

## merge test and traintables() dataset
merged<- merge(test, train, by.x = "ID", by.y = "ID", all = TRUE)

## activity labels
activity<- read.table("activity_labels.txt")

## recoding for activity codes for test data in x
merged$ActivityID.x[merged$ActivityID.x ==1]<-"Walking"
merged$ActivityID.x[merged$ActivityID.x ==2]<-"Walking_upstairs"
merged$ActivityID.x[merged$ActivityID.x ==3]<-"Walking_Downstairs"
merged$ActivityID.x[merged$ActivityID.x ==4]<-"Sitting"
merged$ActivityID.x[merged$ActivityID.x ==5]<-"Standing"
merged$ActivityID.x[merged$ActivityID.x ==6]<-"Laying"

## recoding for activity codes for training  data in y

merged$ActivityID.x[merged$ActivityID.y ==1]<-"Walking"
merged$ActivityID.x[merged$ActivityID.y ==2]<-"Walking_upstairs"
merged$ActivityID.x[merged$ActivityID.y ==3]<-"Walking_Downstairs"
merged$ActivityID.x[merged$ActivityID.y ==4]<-"Sitting"
merged$ActivityID.x[merged$ActivityID.y ==5]<-"Standing"
merged$ActivityID.x[merged$ActivityID.y ==6]<-"Laying"

### renaming headers
##tba
a<-select(merged, mean_tBA_xx =V1.x , mean_tBA_xy =V1.y, mean_tBA_yx =V2.x ,
          mean_tBA_yy =V2.y , mean_tBA_zx =V3.x, mean_tBA_zy =V3.y, std_tBA_xx =V4.x ,
          std_tBA_xy =V4.y, std_tBA_yx = V5.x, std_tBA_yy =V5.y, std_tBA_zx =V6.x, std_tBA_zy =V6.y, 
          mean_tgA_xx =V41.x , mean_tgA_xy = V41.y,  mean_tgA_yx = V42.x , mean_tgA_yy = V42.y , 
          mean_tgA_zx = V43.x,  mean_tgA_zy = V43.y ,  std_tgA_xx = V44.x ,  std_tgA_xy = V44.y, 
           std_tgA_yx = V45.x,  std_tgA_yy = V45.y , std_tgA_zx = V46.x , std_tgA_zy = V46.y)

###select ID columns from merged file of all variables
a1<-select(merged, c(1:2))

### make a small tidy data set
aa1<- data.table(a1,a)
final<-aa1


### NOT tobe used
##jerk
#merged<-select(merged, mean_jerk_xx = V81.x)
#merged<-select(merged, mean_jerk_xy = V81.y)

#merged<-select(merged, mean_jerk_yx = V82.x)
#merged<-select(merged, mean_jerk_yy = V82.y)

#merged<-select(merged, mean_jerk_zx = V83.x)
#merged<-select(merged, mean_jerk_zy = V83.y)

#merged<-select(merged, std_jerk_xx = V84.x)
#merged<-select(merged, std_jerk_xy = V84.y)

#merged<-select(merged, std_jerk_yx = V85.x)
#merged<-select(merged, std_jerk_yy = V85.y)

#merged<-select(merged, std_jerk_zx = V86.x)
#merged<-select(merged, std_jerk_zy = V86.y)

###
##tbg
#merged<-select(merged, mean_tbg_xx = V121.x)
#merged<-select(merged, mean_tbg_xy = V121.y)

#merged<-select(merged, mean_tbg_yx = V122.x)
#merged<-select(merged, mean_tbg_yy = V122.y)

#merged<-select(merged, mean_tbg_zx = V123.x)
#merged<-select(merged, mean_tbg_zy = V123.y)

#merged<-select(merged, std_tbg_xx = V124.x)
#merged<-select(merged, std_tbg_xy = V124.y)

#merged<-select(merged, std_tbg_yx = V125.x)
#merged<-select(merged, std_tbg_yy = V125.y)

#merged<-select(merged, std_tbg_zx = V126.x)
#merged<-select(merged, std_tbg_zy = V126.y)


###

## tbgjerk
#merged<-select(merged, mean_tbgjerk_xx = V161.x)
#merged<-select(merged, mean_tbgjerk_xy = V161.y)

#merged<-select(merged, mean_tbgjerk_yx = V162.x)
#merged<-select(merged, mean_tbgjerk_yy = V162.y)

#merged<-select(merged, mean_tbgjerk_zx = V163.x)
#merged<-select(merged, mean_tbgjerk_zy = V163.y)

#merged<-select(merged, std_tbgjerk_xx = V164.x)
#merged<-select(merged, std_tbgjerk_xy = V164.y)

#merged<-select(merged, std_tbgjerk_yx = V165.x)
#merged<-select(merged, std_tbgjerk_yy = V165.y)

#merged<-select(merged, std_tbgjerk_zx = V166.x)
#merged<-select(merged, std_tbgjerk_zy = V166.y)

###
## tbam
#merged<-select(merged, mean_tbam_x = V201.x)
#merged<-select(merged, mean_tbam_y = V201.y)
#merged<-select(merged, std_tbam_x = V202.x)
#merged<-select(merged, std_tbam_y = V202.y)

###
##similar labelling can be done for all cariables

### Melting and decasting data for only two mesure varibaes

finalMelt<- melt(final,id=c("ID", "ActivityID.x"), measure.vars= c("mean_tBA_xx", "mean_tBA_xy") )
IDData<-dcast(finalMelt, ID ~ variable, mean)
ActivityData<-dcast(finalMelt, ActivityID.x ~ variable, mean, na.rm=T)


