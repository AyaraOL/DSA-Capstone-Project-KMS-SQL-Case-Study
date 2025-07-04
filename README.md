# DSA-Capstone-Project-KMS-SQL-Case-Study
## Introduction
Kultra Mega Stores (KMS), headquartered in Lagos, specialises in office supplies and furniture. Its customer base includes individual consumers, small businesses (retail), and large corporate clients (wholesale) across Lagos, Nigeria.
I have been engaged as a Business Intelligence Analyst to support the Abuja division of KMS. The Business Manager has shared an Excel file containing order data from 2009 to 2012 and has requested that I analyze the data and present my key insights and findings.

## Approch:
* Data exploration
* Data Cleaning
* Anaysis

## Tools:
* MS Excel
* SQL Sever

## Data Source
Two csv files were provided by DSA.

## Insights
### Critical/High Priority: 
Most orders use Express Air (50/60 for Critical, 80/110 for High), which aligns with fast shipping needs. However, 10 Critical and 30 High orders use Delivery Truck, which is inappropriate as it prioritizes cost over speed for urgent orders.
### Medium/Low Priority:
Most orders use Delivery Truck (100/140 for Medium, 150/170 for Low), which is cost-efficient. However, 40 Medium and 20 Low orders use Express Air, indicating overspending on non-urgent orders.
### The company’s shipping cost allocation is partially appropriate but shows inefficiencies:
Strengths: High/Critical orders mostly use Express Air, and Low/Medium orders mostly use Delivery Truck, aligning with priority needs.
Weaknesses: Some High/Critical orders use Delivery Truck, potentially delaying urgent deliveries, and some Low/Medium orders use Express Air, unnecessarily increasing costs.
## Recommendations
### Policy Adjustment: 
Enforce stricter rules to ensure High/Critical orders use Express Air unless cost savings are critical and delays are acceptable.
### Cost Optimization: 
Redirect Low/Medium orders using Express Air to Delivery Truck unless customers specifically request faster shipping.






