library(tidyverse)
library(lubridate)

set.seed(789)
loan_data <- data.frame(
  Loan_ID = paste0("LN", 1001:1010),
  Customer_Name = c("  Arif Khan", "Sumaiya Akter  ", "Rahim Uddin", "  Nabil Ahmed", "Sajid ", "Farhana", "Alex ", "  Maria", "John Doe", "Unknown"),
  Age = c(25, 32, 110, 45, 19, NA, 38, -5, 50, 29),
  Annual_Income = c("50000", "65000", "NA", "80000", "45000", "72000", "0", "95000", "120000", "55000"),
  Loan_Amount = c(15000, 20000, 20000, 35000, NA, 25000, 50000, 10000, 15000, 22000),
  Interest_Rate = c("10%", "12%", "11.5%", "9%", "NA", "10.5%", "15%", "11%", "NA", "12%"),
  Loan_Status = c("Approved", "apprvd", "Rejected", "REJECTED", "Approved", "pending", "Approved", "rejected", "Approved", "Approved")
)


loan_data <- loan_data %>%
  mutate(
    Customer_Name = str_trim(Customer_Name),
    
    Loan_Status = str_to_title(str_trim(Loan_Status)),
    Loan_Status = ifelse(Loan_Status == "Apprvd", "Approved", Loan_Status),
    ) %>%
  
  mutate(
    Interest_Rate = as.numeric(str_remove(Interest_Rate, "%")),
    Annual_Income = as.numeric(Annual_Income)
  ) %>% 
  
  mutate(
    Age = ifelse(Age < 18 | Age > 80 | is.na(Age), 
                 median(Age, na.rm = TRUE),
                 Age),
    
    Annual_Income = ifelse(is.na(Annual_Income) | Annual_Income <= 0,
                           median(Annual_Income, na.rm = TRUE),
                           Annual_Income),
    
    Loan_Amount = ifelse(is.na(Loan_Amount),
                         median(Loan_Amount, na.rm = TRUE),
                         Loan_Amount),
    
    Interest_Rate = ifelse(is.na(Interest_Rate),
                           median(Interest_Rate, na.rm = TRUE),
                           Interest_Rate),
    DTI_Ratio = round(Loan_Amount / Annual_Income, 2)
  )
  
view(loan_data)

# Visualization: DTI Ratio based on Loan Status
ggplot(loan_data, aes(x = Loan_Status, y = DTI_Ratio, fill = Loan_Status)) +
  geom_boxplot(alpha = 0.6, outlier.shape = NA) +
  geom_jitter(width = 0.2, alpha= 0.5, color = "darkblue") +
  theme_minimal() + 
  labs(
    title = "Impact of Debt-to-Income (DTI) Ratio on Loan Status",
    subtitle = "Higher DTI ratios often correlate with higher rejection rates",
    x = "Loan Approval Status",
    y = "DTI Ratio (Loan / Income)",
    fill = "Status"
  ) + 
  scale_fill_brewer(palette = "Set2")





