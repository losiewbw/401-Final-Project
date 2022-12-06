# Load Required Packages
pacman::p_load(tidyquant, pointblank, DataExplorer)

# PUll Data from FRED Database
df = tq_get(x = c('CPILFESL', 'CORESTICKM159SFRBATL', 'FPCPITOTLZGUSA', 'CPIAUCSL', 'MEDCPIM158SFRBCLE', 'CURRCIR', 'EFFR', 'UNRATE'),
            get = 'economic.data',
            from = '2000-01-01')
View(df)
glimpse(df)
str(df)
# Check for missing data
plot_missing(df)
colSums(is.na(df))
## All of the missing price data comes from the EFFR data
## This is because the Federal Reserve does not always post data if nothing changes

# Save data as CSV for Tableau Workbook
write.csv(df, "inflation_data.csv")

# * Data Validation Reporting (Pointblank) --------------------------------

# Steps based on package repo: https://rich-iannone.github.io/pointblank/articles/VALID-I.html
# (A) set the action levels
# (B) create the agent for your data
# (C) Create all validation functions
# (D) interrogate to create your HTML report

# (A) action levels
# warn and notify if something >= 1% and do not stop
act = action_levels(warn_at = 0.01, notify_at = 0.01, stop_at = NULL) 
act

# (B) create the agent for your data
agent = create_agent(tbl = df, actions = act)
agent

# (C) Create Validation functions and use the concept of piping to chain them

agent %>%
  col_is_character(symbol) %>% 
  col_is_date(date) %>%
  col_is_numeric(price) -> agent # save it to agent
agent # overwriting the agent object

# (D) Evaluate Using the interrogate function
res = interrogate(agent)

res 

export_report(x = res, filename = '401_Final_Project_Pointblank.html')

