# Logistic-Regression-with-R
A basic procedure for Logistic Regression in R, applied to a filtered data table obtained from https://www.consumerfinance.gov/.

The goal of this procedure is to determine which factors can help or deter in granting a non HOEPA loan for mortgages for first-lien, 1-4 family homes.

The observations were filtered by year (2016), county (San Francisco County, California) and loan action (loan originated or application denied by financial institution).

The data were further polished eliminating redundant variables, missing values and informations of no use or service for the purpose of this analsys.

The R file LogisticRegression contains the script describing the proceeding, the .csv file contains the dataframe.

The final dataframe consisted of 20941 observation of  20 variables with "loan_granted" as our dependent variable of interest, with the values 0 for loan denied and 1 for loan granted

sources:

data table https://www.consumerfinance.gov/data-research/hmda/explore#!/as_of_year=2016&state_code-1=6&county_code-1=075&property_type=1,2,3&owner_occupancy=1,2&action_taken=1,3&loan_purpose=1,2,3&lien_status=1&section=filters

code sheet: https://www.ffiec.gov/HMDA/pdf/code2011.pdf

required R package(s):

caTools / ROCR
