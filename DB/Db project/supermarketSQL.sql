#1. Some retailers believe that there is more money to be made in selling fashion accessories to men than sports and travel to women.Is this true?
# Translation: Compare money from fashion accessories where gender is Male with money from sports and travel where gender is Female from invoice_details and customers tables
# Clean-up: Select ProductLine, Gender and sum(TotalAmount) from invoice_details and customers 
# where (ProductLine fashion accessories and Gender= Male) or (ProductLine = sports and travel and Gender= Female)

SELECT ProductLine, customers.CustGender, sum(TotalAmount) as Total
FROM invoice_details id
JOIN customers ON id.CustomerID= customers.CustomerID
WHERE (ProductLine= "Fashion accessories" AND customers.CustGender= "Male")
OR (ProductLine= "Sports and travel" AND customers.CustGender= "Female")
GROUP BY id.ProductLine, customers.CustGender;

#Sports and Travel to women earns more revenue(Total Amount)

# Alternate solution
SELECT S.ProductLine, S.CustGender,S.Total
FROM (SELECT ProductLine, customers.CustGender, sum(TotalAmount) Total
FROM invoice_details id
JOIN customers ON id.CustomerID= customers.CustomerID
WHERE (ProductLine= "Fashion accessories" AND customers.CustGender= "Male")
OR (ProductLine= "Sports and travel" AND customers.CustGender= "Female")
GROUP BY id.ProductLine, customers.CustGender) S
order by S.Total DESC
LIMIT 1  ;



#2.Some retailers believe that revenue in food and beverages can be increased amongst women by focusing on Ewallets, while others believe eWallets are more popular with men buying electronic accessories. Who is right?
#Do ewallets have the highest revenue among women for food and beverages? Or do ewallets have highest count among men for electronic accessories?
#Translation: Select ProductLine, Gender, PaymentMode and its count, sum and average of TotalAmount from invoice_details joined with customers where
# ProductLine is Food and beverages, Gender= Female or ProductLine is Electronic accessories, Gender is Male, PaymentMode is Ewallet
# Clean-up: Select ProductLine, Gender, PaymentMode and its count, sum and average of TotalAmount, from invoice_details joined with customers where
# (ProductLine = Food and beverages, Gender=Female) or (ProductLine = Electronic accessories, Gender=Male, PaymentMode=Ewallet)

SELECT ProductLine, customers.CustGender, PaymentMode, COUNT('PaymentMode'),sum(TotalAmount) Revenue, avg(TotalAmount) AvgRevenue
FROM invoice_details id
JOIN customers ON id.CustomerID= customers.CustomerID
WHERE (ProductLine = "Food and beverages" AND customers.CustGender= "Female"   ) 
OR (ProductLine = "Electronic accessories" AND customers.CustGender= "Male" AND PaymentMode="Ewallet")
GROUP BY ProductLine, customers.CustGender, PaymentMode
ORDER BY ProductLine;

#Ewallets are more popular with men buying Electronic Accessories than with women buying food and beverages. The latter claim is right.
#For the first claim however, we can see that the revenue generated from ewallet is the lowest among women buying Food and beverages. 
#Looking the average purchases for every mode of payment shows that cash is the most preferred mode which means that the first claim is not correct. 


#3.Some retailers believe payment method is a bigger indicator of health and beauty purchases while other retailers believe gender is a bigger factor. Who is right?
# Is payment method a bigger indicator of health and beauty purchases than gender?
# Translation: Select ProductLine, PaymentMode, and sum of the total amount from invoice_details table where product line starts with "Health", grouped by payment mode
# Also select ProductLine, Gender and sum of the total amount where ProductLine starts with "Health", grouped by Gender
#Clean-up: Select ProductLine, PaymentMode, sum(TotalAmount) from invoice_details where ProductLine LIKE "Health", group by PaymentMode. Union all.
# Select ProductLine, PaymentMode, sum(TotalAmount) where ProductLine LIKE "Health", group by gender 

SELECT ProductLine, PaymentMode as Indicator ,sum(TotalAmount) Revenue
FROM invoice_details id
WHERE ProductLine LIKE "Health%"
GROUP BY ProductLine, PaymentMode
UNION ALL
SELECT ProductLine, CustGender as Indicator, sum(TotalAmount) Revenue
FROM invoice_details id
JOIN customers ON id.CustomerID= customers.CustomerID
WHERE ProductLine LIKE "Health%"
GROUP BY ProductLine, customers.CustGender;

#Upon comparing the two kinds of indicators- Revenue by the payment mode and revenue by customer's gender
# We can see that with revenue by gender there's a stark difference between Male (30633) and Female (18561)
# Whereas under revenue by payment mode there is no significant variation among the 3 modes.

#4.Some retailers believe that their members are spending more per purchase while customers believe they are spending less per purchase. Who is right?
#Retailers: members are spending more per purchase. Customers: Members are spending less per purchase.
#Are members spending more per purchase than non-members

#Translation: Select Customer type and average of Total amount from invoice_details table joined with customers table and grouped by customer type
#Clean-up : Select CustomerType, AVG(TotalAmount) from invoice_details, joined with customers group by CustomerType



SELECT CustomerType, AVG(TotalAmount) AmtPerPurchase
FROM invoice_details id
JOIN customers ON id.CustomerID= customers.CustomerID
GROUP BY CustomerType;

# Per Purchase spending for members are more than that by non-members. Hence the retailers are correct.  


#5. Some retailers believe that their male members are bringing in more overall revenue per purchase while others believe female non-members are bringing in more revenue per purchase of fashion accessories. Who is right?
#Do male members bring more revenue per purchase? Do female non-members bring more revenue per purchase of fashion accessories

#Translation: Select  customer type, Gender, and average of the total amount from invoice_details table 
#joined with customers where customer type is member and the gender is male or, product line starts with "Fashion", customer type is normal and gender is female
# Clean-up: Select CustomerType,CustGender, AVG(TotalAmount) from invoice_details joined with customers
# where CustomerType= "Member", CustGender= "Male" or ProductLine LIKE "Fashion%", CustomerType= Normal AND CustGender= Female

SELECT CustomerType,CustGender, AVG(TotalAmount) AmtPerPurchase
FROM invoice_details id
JOIN customers ON id.CustomerID= customers.CustomerID
WHERE (CustomerType= "Member" AND CustGender= "Male")
OR (ProductLine LIKE "Fashion%" AND CustomerType= "Normal" AND CustGender= "Female")
GROUP BY CustomerType, CustGender;

#male members: overall average revenue is $317. Female non-members: Fashion accessories revenue per purchase is $312.54
# male members are bringing more overall revenue per purchase 

#6.Is overall spending per city more based on payment type, gender, product line or customer type?
# Spending per city based more on mode, gender, productline or customer type 