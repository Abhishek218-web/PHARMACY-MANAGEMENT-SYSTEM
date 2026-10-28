# Pharmacy Management System Using Oracle PL/SQL

## 1. Project Overview

The Pharmacy Management System is an intermediate-level database mini-project developed using Oracle SQL and PL/SQL. It is designed to manage medicine details, maintain stock quantities, record sales, calculate total prices, and identify expired or low-stock medicines.

The project uses database tables, stored procedures, functions, triggers, and cursors to automate basic pharmacy operations and improve the accuracy of inventory management.

## 2. Objectives

- To store and manage medicine information in a database.
- To calculate the total cost of medicines sold.
- To record sales transactions.
- To automatically update medicine stock after a sale.
- To prevent the sale of expired medicines.
- To check whether sufficient stock is available.
- To identify expired and low-stock medicines.

## 3. Technologies Used

- **Database:** Oracle Database
- **Language:** SQL and PL/SQL
- **Database Tool:** Oracle SQL Developer
- **Concepts:** Tables, Functions, Procedures, Triggers, Cursors, Exception Handling

## 4. Features

1. **Medicine Management:** Stores medicine ID, name, category, price, stock quantity, and expiry date.
2. **Sales Management:** Records medicine sales and calculates the total amount.
3. **Automatic Stock Update:** Reduces available stock after a successful sale.
4. **Expiry Validation:** Prevents sales of medicines that have expired.
5. **Stock Validation:** Prevents sales when the requested quantity exceeds available stock.
6. **Low-Stock Report:** Displays medicines with fewer than 10 units remaining.
7. **Expired-Medicine Report:** Displays medicines whose expiry dates have passed.
8. **Error Handling:** Displays an error message when a sale cannot be completed.

## 5. Database Tables

### MEDICINES

| Column | Description |
|---|---|
| `medicine_id` | Unique ID of each medicine |
| `medicine_name` | Name of the medicine |
| `category` | Category of the medicine |
| `price` | Price per unit |
| `stock_quantity` | Available quantity |
| `expiry_date` | Expiry date of the medicine |

### SALES

| Column | Description |
|---|---|
| `sale_id` | Unique ID of each sale |
| `medicine_id` | ID of the medicine sold |
| `quantity` | Number of units sold |
| `total_amount` | Total cost of the sale |
| `sale_date` | Date and time of the sale |

The `medicine_id` column in the `SALES` table references the `MEDICINES` table.

## 6. PL/SQL Components

| Component | Purpose |
|---|---|
| `calculate_total` | Calculates the total price of a sale |
| `add_medicine` | Adds a new medicine record |
| `sell_medicine` | Processes a medicine sale |
| `validate_pharmacy_sale` | Validates expiry date, quantity, and stock before a sale |
| `deduct_pharmacy_stock` | Automatically updates stock after a sale |
| `show_low_stock` | Displays medicines with low stock |
| `show_expired_medicines` | Displays expired medicines |

## 7. How to Run the Project

1. Install or access an Oracle Database.
2. Open Oracle SQL Developer.
3. Connect to your database using a valid account.
4. Open the file `pharmacy_management_system.sql`.
5. Enable the **DBMS Output** panel if you want to see program messages.
6. Execute the script using **F5 (Run Script)**.
7. Check the output and verify the database records using the provided SQL queries.

**Important:** Run the script in a fresh schema or remove existing project objects before running it again. The script creates tables and inserts sample records, so a second execution may cause errors.

## 8. Example Execution

The following PL/SQL block processes a sale of five units of Paracetamol:

```sql
BEGIN
    sell_medicine(1, 101, 5);
END;
/
```

Expected output on the first successful execution:

```text
Sale completed successfully.
Total amount: Rs. 12.50
```

Paracetamol costs ₹2.50 per unit. Therefore, five units cost ₹12.50, and the stock decreases from 100 to 95.

The expected output assumes that sale ID `1` has not already been used and the medicine is not expired.

## 9. Sample SQL Queries

Display all medicines:

```sql
SELECT * FROM medicines;
```

Display all sales:

```sql
SELECT * FROM sales;
```

Display medicines with low stock:

```sql
BEGIN
    show_low_stock;
END;
/
```

Display expired medicines:

```sql
BEGIN
    show_expired_medicines;
END;
/
```

## 10. Advantages

- Reduces manual calculations.
- Maintains organized medicine and sales records.
- Automatically updates stock quantities.
- Helps identify expired and low-stock medicines.
- Demonstrates practical applications of Oracle PL/SQL.

## 11. Limitations and Future Scope

The current project focuses on database-level operations and does not include a graphical user interface, login system, supplier management, or barcode scanning.

Future improvements could include:
- A graphical interface for pharmacy staff.
- Automatic generation of medicine and sale IDs.
- Supplier and purchase management.
- Daily and monthly sales reports.
- User authentication and role-based access.
- Billing and invoice generation.

## 12. Conclusion

The Pharmacy Management System demonstrates the use of Oracle SQL and PL/SQL for managing medicine inventory and sales. It combines tables, functions, procedures, triggers, and cursors to perform essential pharmacy operations. The project provides practical experience in database programming and can be extended with additional features in the future.

## 13. Author

**Project Title:** Pharmacy Management System Using Oracle PL/SQL  
**Project Type:** Database Mini-Project  
**Difficulty Level:** Intermediate
