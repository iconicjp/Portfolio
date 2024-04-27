> **NOTE:** This README.md file should be placed at the **root of each of your repos directories.**
>
>Also, this file **must** use Markdown syntax, and provide project documentation as per below--otherwise, points **will** be deducted.
>

# LIS3781 - Advanced Database Management

## Jevon Price

### Assignment 4 Requirements:

***Parts:***

1. Log into MS SQL Server
2. Create and Populuate Tables
3. Complete reports
4. Questions

#### README.md file should include the following items:

1. Screenshot of ERD
2. Screenshot of at least 1 report
4. Link to [SQL Code](lis3781_a4_code.sql)

**Business Rules**

A high-volume home office supply company contracts a database designer to develop a system in order to track its day-to-day business operations. The CFO needs an updated method for storing data, running reports, and making business decisions based upon trends and forecasts, as well as maintaining historical data due to new governmental regulations. Here are the mandatory business rules:

* A sales representative has at least one customer, and each customer has at least one sales rep on any given day (as it is a high-volume organization).
* A customer places at least one order. However, each order is placed by only one customer.
* Each order contains at least one order line. Conversely, each order line is contained in exactly one order.
* Each product may be on a number of order lines. Though, each order line contains exactly one product id (though, each product id may have a quantity of more than one included, e.g., “oln_qty”).
* Each order is billed on one invoice, and each invoice is a bill for exactly one order (by only one customer).
* An invoice can have one (full), or can have many payments (partial). Though, each payment is made to only one invoice.
* A store has many invoices, but each invoice is associated with only one store.
* A vendor provides many products, but each product is provided by only one vendor.
* Must track yearly history of sales reps, including (also, see Entity-specific attributes below): yearly sales goal, yearly total sales, yearly total commission (in dollars and cents).
* Must track history of products, including: cost, price, and discount percentage (if any).

Notes:

* A customer’s contact (in-store or online) is made through a sales rep.
* A customer buys or potentially buys products from the company, but does not have to.
* An order is a purchase of one or more products by a customer. If an order is cancelled, it is deleted (optional participation).
* An order line contains the details about each product sold on a particular customer order, and includes data such as quantity and price.
* A product is an item that the company sells that was initially bought from an outside vendor (which may also be the manufacturer).
* A sales rep receives a 3% commission based upon the amount of year-to-date sales.
* A sales reps’s current yearly sales goal is 8% more than their previous year’s total sales.

Additional Notes:

* Social security numbers, should be unique, and hashed and salted for security purposes.
* ERD MUST include relationships, though, not cardinalities.
* Appropriate attributes *are* required (e.g., name, ssn (for sales rep and customer), dob, address, phone, email, url... also, see Assignment Guidelines, and Notes above),


**A4 ERD**

![A4 ERD](img/a4_erd.png)

**Populated Person Table**

![Person Table Populated](img/person_table.png)

**Solution 5**

![A Sql Solution](img/solution5.png)

**Portion of the SQL Code**

![Code](img/code.png)