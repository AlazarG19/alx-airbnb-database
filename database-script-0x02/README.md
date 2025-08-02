# Database Seed Data Documentation

## Overview

The `seed.sql` file contains sample data for the Airbnb clone database system. This file populates all tables with realistic test data to enable development, testing, and demonstration of the application's functionality.

## Purpose

- **Development Testing**: Provides realistic data for testing application features
- **Demo Environment**: Enables demonstration of the application with populated data
- **Database Validation**: Verifies that all relationships and constraints work correctly
- **User Experience**: Allows developers to see how the application looks with actual data

## Sample Data Structure

### Users (3 records)

The seed data includes three different user types:

1. **Alice Johnson** (`guest`)
   - Email: alice@example.com
   - Phone: 1234567890
   - Role: Guest user who can book properties

2. **Bob Smith** (`host`)
   - Email: bob@example.com
   - Phone: 0987654321
   - Role: Host who owns properties

3. **Carol Williams** (`admin`)
   - Email: carol@example.com
   - Phone: NULL (optional field)
   - Role: Administrator with system privileges

### Properties (2 records)

Two properties owned by Bob Smith:

1. **Cozy Cabin**
   - Location: Mountainville
   - Price: $100.00 per night
   - Description: "A cozy cabin in the woods"

2. **Beach House**
   - Location: Seaside
   - Price: $250.00 per night
   - Description: "Beautiful beach house with sea view"

### Bookings (2 records)

Alice Johnson has made two bookings:

1. **Cozy Cabin Booking**
   - Dates: August 10-15, 2025
   - Total Price: $500.00
   - Status: Confirmed

2. **Beach House Booking**
   - Dates: September 1-5, 2025
   - Total Price: $1000.00
   - Status: Pending

### Payments (2 records)

1. **Cozy Cabin Payment**
   - Amount: $500.00
   - Method: Credit Card
   - Status: Paid (confirmed booking)

2. **Beach House Payment**
   - Amount: $0.00
   - Method: PayPal
   - Status: Pending (pending booking)

### Reviews (2 records)

Alice Johnson has reviewed both properties:

1. **Cozy Cabin Review**
   - Rating: 5 stars
   - Comment: "Amazing stay! Highly recommended."

2. **Beach House Review**
   - Rating: 4 stars
   - Comment: "Great location but a bit noisy."

### Messages (2 records)

Sample conversation between Alice and Bob:

1. **Alice to Bob**: "Hi, is the cabin available for late check-in?"
2. **Bob to Alice**: "Yes, late check-in is possible."

## Data Relationships

The seed data demonstrates all key relationships:

- **User → Property**: Bob (host) owns 2 properties
- **User → Booking**: Alice (guest) has 2 bookings
- **Property → Booking**: Both properties have bookings
- **Booking → Payment**: Each booking has a corresponding payment
- **Property → Review**: Both properties have reviews from Alice
- **User → Message**: Alice and Bob have exchanged messages

## Usage Instructions

### Prerequisites

1. Ensure the database schema is created using the DDL script
2. Verify all tables exist and foreign key constraints are in place

### Running the Seed Script

```bash
# Connect to your database and run the seed script
psql -U postgres -d airbnb_clone -f seed.sql
```

Or if already connected to the database:
```sql
\i seed.sql
```

### Verification

After running the seed script, verify the data was inserted correctly:

```sql
-- Check record counts
SELECT 'Users' as table_name, COUNT(*) as count FROM "User"
UNION ALL
SELECT 'Properties', COUNT(*) FROM "Property"
UNION ALL
SELECT 'Bookings', COUNT(*) FROM "Booking"
UNION ALL
SELECT 'Payments', COUNT(*) FROM "Payment"
UNION ALL
SELECT 'Reviews', COUNT(*) FROM "Review"
UNION ALL
SELECT 'Messages', COUNT(*) FROM "Message";

-- Verify relationships
SELECT 
    u.first_name || ' ' || u.last_name as user_name,
    p.name as property_name,
    b.start_date,
    b.end_date,
    b.status
FROM "User" u
JOIN "Booking" b ON u.user_id = b.user_id
JOIN "Property" p ON b.property_id = p.property_id;
```

## Data Characteristics

### UUID Format
All primary keys use UUID format for consistency:
- User IDs: `11111111-1111-1111-1111-111111111111`
- Property IDs: `aaaaaaa1-aaaa-aaaa-aaaa-aaaaaaaaaaa1`
- Booking IDs: `bbbbbbb1-bbbb-bbbb-bbbb-bbbbbbbbbbb1`
- Payment IDs: `ccccccc1-cccc-cccc-cccc-ccccccccccc1`
- Review IDs: `ddddddd1-dddd-dddd-dddd-ddddddddddd1`
- Message IDs: `eeeeeee1-eeee-eeee-eeee-eeeeeeeeeee1`

### Realistic Scenarios
The data includes realistic scenarios:
- Confirmed and pending bookings
- Different payment methods
- Various review ratings
- Host-guest communication
- Different property types and locations

## Customization

To modify the seed data:

1. **Add more users**: Insert additional records in the User section
2. **Add properties**: Insert new properties with valid host_id references
3. **Create bookings**: Ensure user_id and property_id references exist
4. **Add reviews**: Reference existing users and properties
5. **Generate messages**: Use existing user IDs for sender and recipient

### Example: Adding a New Property

```sql
INSERT INTO "Property" (property_id, host_id, name, description, location, price_per_night)
VALUES (
    'aaaaaaa3-aaaa-aaaa-aaaa-aaaaaaaaaaa3',
    '22222222-2222-2222-2222-222222222222',  -- Bob's user_id
    'City Apartment',
    'Modern apartment in downtown',
    'Downtown',
    150.00
);
```

## Troubleshooting

### Common Issues

1. **Foreign Key Violations**: Ensure referenced records exist before inserting
2. **UUID Format**: Use proper UUID format for all ID fields
3. **Date Format**: Use YYYY-MM-DD format for dates
4. **Enum Values**: Use valid enum values for status and role fields

### Error Resolution

If you encounter errors:
1. Check that the schema is properly created
2. Verify all foreign key references exist
3. Ensure enum types are defined
4. Check for duplicate unique constraints

## Next Steps

After seeding the database:
1. Test application functionality with the sample data
2. Create additional test scenarios as needed
3. Develop application features using the populated data
4. Consider creating additional seed scripts for different scenarios
