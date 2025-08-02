# CREATING A AIRBNB TYPE APPLICATION

## Database Setup

This project uses PostgreSQL as the database management system. Follow the steps below to set up the database for the Airbnb clone application.

### Prerequisites

- PostgreSQL installed on your system
- psql command-line tool or a PostgreSQL GUI client (like pgAdmin)
- Basic knowledge of SQL and database management

### Installation Steps

#### 1. Install PostgreSQL

**Windows:**
- Download PostgreSQL from [postgresql.org](https://www.postgresql.org/download/windows/)
- Run the installer and follow the setup wizard
- Remember the password you set for the postgres user

**macOS:**
```bash
brew install postgresql
brew services start postgresql
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

#### 2. Create Database

1. Connect to PostgreSQL as the postgres user:
```bash
psql -U postgres
```

2. Create a new database for the Airbnb application:
```sql
CREATE DATABASE airbnb_clone;
```

3. Connect to the new database:
```sql
\c airbnb_clone
```

#### 3. Execute DDL Script

Run the schema.sql file to create all tables, types, and relationships:

```bash
psql -U postgres -d airbnb_clone -f schema.sql
```

Or if you're already connected to the database:
```sql
\i schema.sql
```

### Database Structure

The schema.sql file creates the following database components:

#### Custom Types
- `user_role`: ENUM ('guest', 'host', 'admin')
- `payment_status`: ENUM ('credit_card', 'paypal', 'stripe')
- `booking_status`: ENUM ('pending', 'confirmed', 'canceled')

#### Tables

1. **User Table**
   - Primary key: `user_id` (UUID)
   - Stores user information: name, email, password hash, phone, role
   - Includes timestamps for account creation

2. **Property Table**
   - Primary key: `property_id` (UUID)
   - Foreign key: `host_id` references User table
   - Stores property details: name, description, location, price
   - Includes automatic timestamp updates

3. **Booking Table**
   - Primary key: `booking_id` (UUID)
   - Foreign keys: `property_id`, `user_id`
   - Stores booking information: dates, total price, status

4. **Payment Table**
   - Primary key: `payment_id` (UUID)
   - Foreign key: `booking_id` references Booking table
   - Stores payment details: amount, date, payment method

5. **Review Table**
   - Primary key: `review_id` (UUID)
   - Foreign keys: `property_id`, `user_id`
   - Stores reviews: rating (1-5), comments, timestamp

6. **Message Table**
   - Primary key: `message_id` (UUID)
   - Foreign keys: `sender_id`, `recipient_id` (both reference User table)
   - Stores messages between users

#### Relationships

- **User → Property**: One-to-Many (A host can have multiple properties)
- **User → Booking**: One-to-Many (A user can make multiple bookings)
- **Property → Booking**: One-to-Many (A property can have multiple bookings)
- **Booking → Payment**: One-to-One (Each booking has one payment)
- **Property → Review**: One-to-Many (A property can have multiple reviews)
- **User → Review**: One-to-Many (A user can write multiple reviews)
- **User → Message**: One-to-Many (A user can send/receive multiple messages)

#### Indexes

The DDL includes performance indexes on:
- User email (for login lookups)
- Property IDs (for property queries)
- Booking IDs (for booking management)
- Payment booking IDs (for payment tracking)

#### Triggers

- Automatic `updated_at` timestamp updates on Property table modifications

### Verification

After running the DDL script, verify the setup:

```sql
-- List all tables
\dt

-- Check table structure
\d "User"
\d "Property"
\d "Booking"

-- Verify relationships
SELECT 
    tc.table_name, 
    kcu.column_name, 
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name 
FROM 
    information_schema.table_constraints AS tc 
    JOIN information_schema.key_column_usage AS kcu
      ON tc.constraint_name = kcu.constraint_name
      AND tc.table_schema = kcu.table_schema
    JOIN information_schema.constraint_column_usage AS ccu
      ON ccu.constraint_name = tc.constraint_name
      AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY';
```

### Troubleshooting

**Common Issues:**

1. **Permission Denied**: Ensure you're running psql as a user with sufficient privileges
2. **Database Already Exists**: Drop the existing database first: `DROP DATABASE airbnb_clone;`
3. **Connection Issues**: Check if PostgreSQL service is running
4. **Path Issues**: Use absolute paths when running the DDL file

**Useful Commands:**
```sql
-- List all databases
\l

-- List all tables in current database
\dt

-- Describe table structure
\d table_name

-- Exit psql
\q
```

### Next Steps

After setting up the database:
1. Configure your application's database connection settings
2. Set up environment variables for database credentials
3. Run any additional migration scripts if needed
4. Populate the database with sample data for testing
