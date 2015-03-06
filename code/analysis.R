# CRD Analysis
## Query: 
# 1. Whether or not we have these indicators in HDX from the original source.
# 2. Whether or not we have data (latest year) for the 25 OCHA country offices
# 3. Whether or not we have a complete metadata

## Indicators:
# o GDP per capita (PSE030) ✓
# o Children under 5 mortality rate (PVH140) ✓
# o Malnutrition | Prevalence of undernourishment (PVN010) ✓
# o Fertility rate ✗ (but available in World Bank)
# o Life expectancy (PVH010) ✓
# o Gini coefficient (PSE210) ✓

# Dependencies.
library(countrycode)
library(rjson)
library(RCurl)

# Helpers.
source("code/querycps.R")
source("code/facetplot.R")
source("code/assessment.R")

# Reading the country list.
f = read.csv("data/crd-field-operations.csv")
f$iso <- countrycode(f$field_operations, "country.name", "iso3c")

# Country list + indicator list
country_list = f$iso
ind_list = c("PSE030", "PVH140", "PVN010", "PVH010", "PSE210")

# Collecting data
data <- queryCPS(indicator = ind_list, location = country_list)

# Generating plots.
facetPlotIndicator(data,"PSE030")
facetPlotIndicator(data,"PVH140")
facetPlotIndicator(data,"PVN010")
facetPlotIndicator(data,"PVH010")
facetPlotIndicator(data,"PSE210")

# Generate result table with assessments.
a = makeCountryAssessment(data)
write.csv(a, "assessment.csv", row.names = FALSE)