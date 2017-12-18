# Linear Regression with R for a small dataset

A basic procedure for simple and multiple Linear Regression in R, applied to the popular mtcars dataframe, built-in in base R.

The goal for this procedure is to find which parameter(s) drive(s) the fuel consumption of a car, using a forward selection method.

The R file LinearRegression contains the script describing the proceeding.

The mtcars dataframe is composed of 32 observations of automobiles on the following 11 variables:

[, 1]	mpg	Miles/(US) gallon

[, 2]	cyl	Number of cylinders

[, 3]	disp	Displacement (cu.in.)

[, 4]	hp	Gross horsepower

[, 5]	drat	Rear axle ratio

[, 6]	wt	Weight (1000 lbs)

[, 7]	qsec	1/4 mile time

[, 8]	vs	V/S (0 = V-engine, 1 = straight engine)

[, 9]	am	Transmission (0 = automatic, 1 = manual)

[,10]	gear	Number of forward gears

[,11]	carb	Number of carburetors

source: http://stat.ethz.ch/R-manual/R-devel/library/datasets/html/mtcars.html
