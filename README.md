# Penguin Bookstore & Cafe Management System – Final Project

**Student Name:** Hatice Özateş  
**Student ID:** 22040102033

---

##  Project Files

- `Project.sql`  
  - **Phase 2:** Table creation and sample data insertion  
  - **Phase 3:** Complex SQL queries, user-defined functions, stored procedures, and triggers  
- `Report.pdf`  
  - Full documentation for all three phases  
- `README.md`  
  - This explanation file  

---

## How to Run

### Recommended Environment

- **Database:** MySQL 8.x

### Step-by-Step Execution

1. **Create and select the database:**

   ```sql
   CREATE DATABASE penguin_bookstore;
   USE penguin_bookstore;
   ```

2. **Run the script file: `Project.sql`**

   - **Phase 2:**
     - `-- Phase 2: Create Tables` → Contains all table definitions  
     - `-- Phase 2: Insert Sample Data` → Adds sample records
   - **Phase 3:**
     - `-- Phase 3: Complex Queries`  
     - `-- Phase 3: User-Defined Functions`  
     - `-- Phase 3: Stored Procedures`  
     - `-- Phase 3: Triggers`  

The script can be executed all at once or in parts.

---

## Script Details (`Project.sql`)

### A. Conceptual Modeling (Phase 1)

- Created a detailed **EER Diagram** including:
  - Entities, relationships, weak entities
  - Many-to-many relationships
  - ISA hierarchy (supertypes and subtypes)

> The EER diagram can be found inside `Report.pdf`.

---

### B. Database & Table Creation (Phase 2)

Key tables created:

- `Customer`, `Product`, `Book`, `CafeProduct`, `Order`, `OrderDetail`, `Author`, `Publisher`, `Event`, `DiscountCampaign`, etc.

Key integrity and design techniques used:

- **Primary & Foreign Keys (PK, FK)**
- **Constraints:** `NOT NULL`, `UNIQUE`, `CHECK`
- **ISA Relationship:** `Product` as supertype, `Book` and `CafeProduct` as subtypes
- **M:N Relationships:** Handled via junction tables like `Book_Author_Writes`

---

### C. Sample Data Insertion (Phase 2)

- Each table includes at least **2 sample records**
- Insertion follows **parent-to-child** order to maintain referential integrity
- Data reflects realistic bookstore & café scenarios

---

###D. SQL Operations & Business Logic (Phase 3)

#### Complex SQL Queries (x5)

1. Top 3 most ordered products  
2. Total spending of each customer  
3. Authors with the most books  
4. Customers with more than 2 orders  
5. Discounted books and their authors  

> Techniques: `JOIN`, `GROUP BY`, `HAVING`, `ORDER BY`, `LIMIT`, `SUBQUERY`, `SUM`, `COUNT`

---

#### User-Defined Functions (UDFs)

- `fn_GetCustomerEventCount(custID INT)`  
  → Returns the number of events a customer joined  
- `fn_GetCustomerTotalSpent(custID INT)`  
  → Returns the total spending of a customer (handles `NULL` as 0)

---

#### Stored Procedures

- `UpdateCustomerEmail(IN p_CustomerID, IN p_NewEmail, OUT p_Message)`  
  → Updates email, triggers logging in audit table  
- `AddNewBook(...)`  
  → Inserts into `Product` then into `Book`

---

#### Triggers

- `trg_CustomerEmail_Update`  
  → Logs old & new email into `CustomerEmailAudit` on update  
- `trg_Set_VIP_Status`  
  → Auto-sets customer status to `VIP` if spending > 500 TL after an order

---

## Testing & Validation

- All functions, procedures, triggers, and queries were tested with the sample data.
- Each result is included with screenshots and explanations in `Report.pdf`.
- The entire script runs **without errors** when executed in correct order.

---

## GitHub Repository

You can access the full project and documentation at:

[GitHub Repository](https://github.com/haticeozates/penguin_bookstore)
