The below are the explanation for whether or not each table is in 3NF form or not
✅ User Table
Passes 3NF.

No repeating groups, all non-key attributes depend solely on user_id.

✅ Property Table
Passes 3NF.

host_id is a foreign key to User, and all other attributes depend on property_id.

✅ Booking Table
Passes 3NF.

All fields (e.g., start_date, total_price, status) depend on the primary key booking_id.

No transitive dependencies.

✅ Payment Table
Passes 3NF.

Everything depends on the payment_id.

booking_id is a foreign key; no derived or calculated fields from other non-key attributes.

✅ Review Table
Passes 3NF.

All fields depend directly on the review_id.

✅ Message Table
Passes 3NF.

No repeating groups or transitive dependencies. sender_id and recipient_id are FKs.