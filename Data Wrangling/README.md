# Data-Wrangling-with-R

Where we apply some common strategies to prepare a dataframe in a way to apply with success subsequents machine learning techniques.

The data table is about non HOEPA loans for mortgages for first-lien, 1-4 family homes and was obtained from https://www.consumerfinance.gov/, with observations filtered by year (2016), county (San Francisco County, California) and loan action (loan originated or application denied by financial institution).

The R file DataWrangling contains the script describing the proceeding, the .csv file contains the dataframe.

sources:

data table https://www.consumerfinance.gov/data-research/hmda/explore#!/as_of_year=2016&state_code-1=6&county_code-1=075&property_type=1,2,3&owner_occupancy=1,2&action_taken=1,3&loan_purpose=1,2,3&lien_status=1&section=filters

code sheet: https://www.ffiec.gov/HMDA/pdf/code2011.pdf

required R package(s):

mice
