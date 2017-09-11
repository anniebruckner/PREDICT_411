* Andrea Bruckner
  PREDICT 411, Sec 55
  Spring 2016
  Unit 00
;

********************************************************************;
* SAS Tutorial 01: The SAS Data Step;
********************************************************************;

* Part 1: Creating SAS Data Sets Using the DATALINES Statement;

data temp1;
length dimkey $2;
length x 8.0;
length y 8.0;
input dimkey $ x y ;
datalines;
01 100 12.2
02 300 7.45
03 200 10.0
04 500 5.67
05 300 4.55
;
run;

data temp2;
length dimkey $2;
length Z 8.0;
length first_name $10;
length last_name $10;
input dimkey $ z first_name $ last_name $;
datalines;
01 100 steve    miller
02 300 Steve    Utrup
04 500 JacK     wilsoN
05 300 AbRAham  LINcoln
06 100 JackSON  SmiTH
07 200 EarL     Campbell
08 400 WiLLiam  Right
;
run;

* Part 2: Print Your Data for Viewing;

title 'Data = temp1';
proc print data=temp1; run; quit;

title 'Data = temp2';
proc print data=temp2; run; quit;

* Part 3: Print a PROC CONTENTS;

title ;
proc contents data=temp1; run; quit;
proc contents data=temp2; run; quit;

* Part 4: Manipulating SAS Data Sets;

data temp1;
set temp1;
w = 2*y + 1;
if (x < 150) then segment=1;
else if (x < 250) then segment=2;
else segment=3;
run;

data temp2;
set temp2;
proper_first_name = propcase(first_name);
upper_last_name = upcase(last_name);
first_initial = substr(upcase(first_name),1,1);
last_initial = substr(upcase(last_name),1,1);
initials = compress(first_initial||last_initial);
run;

title 'Data = temp1';
proc print data=temp1; run; quit;

title 'Data = temp2';
proc print data=temp2(obs=15); run; quit;

* Part 5: Subsetting SAS Data Sets;

data s1;
set temp1;
if (segment=1);
run;

data s2;
set temp1;
if (segment ne 1) then delete;
run;

data s3;
set temp1;
where (segment=1);
run;

data s4;
set temp1 (where=(segment=1));
run;

title ;
proc print data=s1; run; quit;
proc print data=s2; run; quit;
proc print data=s3; run; quit;
proc print data=s4; run; quit;

* Part 6: Combining SAS Data Sets;

data stacked_data;
set temp1 temp2;
run;

title 'Data = stacked_data';
proc print data=stacked_data; run; quit;

proc sort data=temp1; by dimkey; run; quit;
proc sort data=temp2; by dimkey; run; quit;

data ordered_stack;
set temp1 temp2;
by dimkey;
run;

title 'Data = ordered_stack';
proc print data=ordered_stack; run; quit;

data merged_data;
merge temp1 temp2;
by dimkey;
run;

title 'Data = merged_data';
proc print data=merged_data; run; quit;

title 'LEFT JOIN OUTPUT';
data left_join;
merge temp1 (in=a) temp2 (in=b);
by dimkey;
if (a=1);
run;

proc print data=left_join; run; quit;

title 'RIGHT JOIN OUTPUT';
data right_join;
merge temp1 (in=a) temp2 (in=b);
by dimkey;
if (b=1);
run;

proc print data=right_join; run; quit;

title 'INNER JOIN OUTPUT';
data inner_join;
merge temp1 (in=a) temp2 (in=b);
by dimkey;
if (a=1) and (b=1);
run;

proc print data=inner_join; run; quit;

********************************************************************;
* SAS Tutorial 02: The Scatter Plot;
********************************************************************;

* Preliminary Steps;

* Access library where data sets are stored;
libname mydata '/folders/myfolders/PREDICT_411/Week00/data' access=readonly;

* Part 1: PROC CORR;

TITLE "PROC CORR Example: Anscombe Quartet";
ods graphics on;

PROC CORR DATA=mydata.anscombe;
VAR X1;
WITH Y1;
TITLE2 "X1 and Y1 Correlation";
run;

PROC CORR DATA=mydata.anscombe;
VAR X2;
WITH Y2;
TITLE2 "X2 and Y2 Correlation";
run;

PROC CORR DATA=mydata.anscombe;
VAR X3;
WITH Y3;
TITLE2 "X3 and Y3 Correlation";
run;

PROC CORR DATA=mydata.anscombe;
VAR X4;
WITH Y4;
TITLE2 "X4 and Y4 Correlation";
run;

ods graphics off;

* Part 2: PROC SGPLOT;

ods graphics on;

PROC SGPLOT DATA=mydata.anscombe;
LOESS X=X1 Y=Y1 / NOMARKERS;;
REG X=X1 Y=Y1;
Title2 "X1 and Y1 Scatter Plot with LOESS and Regression";
run;

PROC SGPLOT DATA=mydata.anscombe;
LOESS X=X2 Y=Y2 / NOMARKERS;;
REG X=X2 Y=Y2;
Title2 "X2 and Y2 Scatter Plot with LOESS and Regression";
run;

PROC SGPLOT DATA=mydata.anscombe;
LOESS X=X3 Y=Y3 / NOMARKERS;;
REG X=X3 Y=Y3;
Title2 "X3 and Y3 Scatter Plot with LOESS and Regression";
run;

PROC SGPLOT DATA=mydata.anscombe;
LOESS X=X4 Y=Y4 / NOMARKERS;
REG X=X4 Y=Y4;
Title2 "X4 and Y4 Scatter Plot with LOESS and Regression";
run;

ods graphics off;

* Part 3: PROC SGSCATTER;

ods graphics on;

PROC SGSCATTER data=mydata.anscombe;
compare X=X1 Y=Y1 / loess reg;
Title2 "X1 and Y1 Scatter with Loess and Regression";
run;

PROC SGSCATTER data=mydata.anscombe;
compare X=X2 Y=Y2 / loess reg;
Title2 "X2 and Y2 Scatter with Loess and Regression";
run;

PROC SGSCATTER data=mydata.anscombe;
compare X=X3 Y=Y3 / loess reg;
Title2 "X3 and Y3 Scatter with Loess and Regression";
run;

PROC SGSCATTER data=mydata.anscombe;
compare X=X4 Y=Y4 / loess reg;
Title2 "X4 and Y4 Scatter with Loess and Regression";
run;

ods graphics off;

********************************************************************;
* SAS Tutorial 03: OLS Regression;
********************************************************************;

* Preliminary Steps;

* Access library where data sets are stored;
libname mydata '/folders/myfolders/PREDICT_411/Week00/data' access=readonly;

* Part 1: PROC CORR;

Title "OLS Regression SAS Tutorial";
ods graphics on;

Title2 "Scatterplot Matrix";
proc corr data= mydata.cigarette_consumption plot=matrix(histogram nvar=all);
run;

ods graphics off;

* Part 2: PROC REG to produce single variable model;

ods graphics on;
proc reg data= mydata.cigarette_consumption PLOTS(ONLY)=(DIAGNOSTICS FITPLOT RESIDUALS);
model sales = income;
title2 'Base Model';
run;
ods graphics off;

* Part 3: PROC REG to produce multiple variable model;

ods graphics on;
proc reg data= mydata.cigarette_consumption PLOTS(ONLY)=(diagnostics residuals fitplot);
model sales = age income price / vif;
title2 'Optimal Model';
output out=fitted_model pred=yhat residual=resid ucl=ucl lcl=lcl;
run;
ods graphics off;

********************************************************************;
* SAS Tutorial 04: Logistic Regression;
********************************************************************;

* Preliminary Steps -- had to skip because of errors below;

* Access library where data sets are stored;
libname mydata '/folders/myfolders/PREDICT_411/Week00/data' access=readonly;

* ERROR: Unable to clear or re-assign the library MYDATA because it is still in use.
* ERROR: Error in the LIBNAME statement.

* Part 1: PROC MEANS to produce simple univariate descriptive statistics for numeric variables;

* examine means of continuous variables for predictive relevance to response variable;
Title "Logistic Regression EDA - Examine Means";
* examine means at min, 25th, 50th, 75th, and max percentile;
proc means data= mydata.financial_ratios min p25 p50 p75 max ndec=2;
class Y;
var X1 X2 X3;
run;

* examine means at 5th, 10th, 25th, 50th, 75th, 90th, and 95th percentile;
proc means data= mydata.financial_ratios p5 p10 p25 p50 p75 p90 p95 ndec=2;
class Y;
var X1 X2 X3;
run;

* Part 2: DATA statement to create discrete variables from the continuous variables, then PROC FREQ;

data bankrupt;
set mydata.financial_ratios;
* example of discretizing continuous variables;
if (X1<0) then X1_discrete=0;
else X1_discrete=1;
if (X2<0) then X2_discrete=0;
else X2_discrete=1;
if (X3<1.7) then X3_discrete=0;
else X3_discrete=1;
run;

* examine frequencies of discretized continuous variables for predictive relavance to response variable;
Title "Logistic Regression EDA - Examine Frequencies";
proc freq data=bankrupt;
table (X1_discrete X2_discrete X3_discrete)*Y
/missing;
run;

* Part 3: PROC LOGISTIC to produce single variable or multiple variable logistic regressions;

* logistic regression using all variables;
Title "Logistic Regression - All Continuous Variables";
proc logistic data=bankrupt descending;
model Y = X1 X2 X3;
run;

* Part 4: PROC LOGISTIC to perform variable selection;

* logistic regression to identify best predictor variables by backward selection;
Title "Logistic Regression - All Variables Backward Selection";
proc logistic data=bankrupt descending;
model Y = X1 X2 X3 X1_discrete X2_discrete X3_discrete /selection=backward;
run;

* Part 5: Evaluation of the fit of a logistic regression;

* Part 6: Include plot of Receiver Operating Characteristic (ROC) curve to PROC LOGISTIC output;

* logistic regression of single predictor variable;
* includes ROC curve with cut-points;
Title "Logistic Regression - Select Single Predictor";
ods graphics on;
proc logistic data=bankrupt descending plots(only)=roc(id=prob);
model Y = X1 / outroc=roc;
run;
ods graphics off;
proc print data=roc; run; quit;
