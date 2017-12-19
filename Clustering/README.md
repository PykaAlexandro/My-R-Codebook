# Clustering-with-R

A basic procedure for Clustering in R, applied to a filtered data table obtained from https://www.consumerfinance.gov/.

The goal of this procedure is to find the best segmentation of a dataframe composed of non HOEPA loan for mortgages for first-lien, 1-4 family homes. 

The segmented dataframe can then be used to improve the predictive accuracy of a Machine Learning algorithm of choice. 

The observations were filtered by year (2016), county (San Francisco County, California) and loan action (loan originated or application denied by financial institution).

The data were further polished eliminating redundant variables, missing values and informations of no use or service for the purpose of this analsys.

The R file Clustering contains the script describing the proceeding, the .csv file contains the dataframe.

The final dataframe consisted of 20941 observation of 7 variables with "loan_granted" as our dependent variable of interest, with the values 0 for loan denied and 1 for loan granted

sources:

data table https://www.consumerfinance.gov/data-research/hmda/explore#!/as_of_year=2016&state_code-1=6&county_code-1=075&property_type=1,2,3&owner_occupancy=1,2&action_taken=1,3&loan_purpose=1,2,3&lien_status=1&section=filters

code sheet: https://www.ffiec.gov/HMDA/pdf/code2011.pdf

required R packages:

caTools / caret / flexclust
