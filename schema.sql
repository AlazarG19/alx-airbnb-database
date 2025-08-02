CREATE TYPE user_role AS ENUM ('guest', 'host', 'admin');
CREATE TYPE payment_status AS ENUM ('credit_card', 'paypal', 'stripe');
CREATE TYPE booking_status AS ENUM ('pending', 'confirmed', 'canceled');

CREATE TABLE "User" (
  "user_id" UUID UNIQUE PRIMARY KEY NOT NULL,
  "first_name" VARCHAR NOT NULL,
  "last_name" VARCHAR NOT NULL,
  "email" VARCHAR UNIQUE NOT NULL,
  "password_hash" VARCHAR NOT NULL,
  "phone_number" VARCHAR,
  "role" user_role NOT NULL,
  "created_at" TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "Property" (
  "property_id" UUID UNIQUE PRIMARY KEY,
  "host_id" UUID,
  "name" varchar NOT NULL,
  "description" text NOT NULL,
  "location" varchar NOT NULL,
  "price_per_night" decimal NOT NULL,
  "created_at" TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" TIMESTAMP DEFAULT NOW()
);

CREATE TABLE "Booking" (
  "booking_id" UUID UNIQUE PRIMARY KEY,
  "property_id" UUID,
  "user_id" UUID,
  "start_date" date NOT NULL,
  "end_date" date NOT NULL,
  "total_price" decimal NOT NULL,
  "status" booking_status NOT NULL,
  "created_at" timestamp NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "Payment" (
  "payment_id" UUID UNIQUE PRIMARY KEY,
  "booking_id" UUID,
  "amount" decimal NOT NULL,
  "payment_date" timestamp DEFAULT (CURRENT_TIMESTAMP),
  "payment_method" payment_status NOT NULL
);

CREATE TABLE "Review" (
  "review_id" UUID UNIQUE PRIMARY KEY,
  "property_id" UUID,
  "user_id" UUID,
  "rating" INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  "comment" text NOT NULL,
  "created_at" timestamp NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "Message" (
  "message_id" UUID UNIQUE PRIMARY KEY,
  "sender_id" UUID,
  "recipient_id" UUID,
  "message_body" text NOT NULL,
  "sent_at" timestamp DEFAULT (CURRENT_TIMESTAMP)
);

ALTER TABLE "Property" ADD FOREIGN KEY ("host_id") REFERENCES "User" ("user_id");

ALTER TABLE "Booking" ADD FOREIGN KEY ("property_id") REFERENCES "Property" ("property_id");

ALTER TABLE "Booking" ADD FOREIGN KEY ("user_id") REFERENCES "User" ("user_id");

ALTER TABLE "Payment" ADD FOREIGN KEY ("booking_id") REFERENCES "Booking" ("booking_id");

ALTER TABLE "Review" ADD FOREIGN KEY ("property_id") REFERENCES "Property" ("property_id");

ALTER TABLE "Review" ADD FOREIGN KEY ("user_id") REFERENCES "User" ("user_id");

ALTER TABLE "Message" ADD FOREIGN KEY ("sender_id") REFERENCES "User" ("user_id");

ALTER TABLE "Message" ADD FOREIGN KEY ("recipient_id") REFERENCES "User" ("user_id");

-- Index on email in User table
CREATE INDEX idx_user_email ON "User" (email);

-- Index on property_id in Property table
CREATE INDEX idx_property_property_id ON "Property" (property_id);

-- Index on property_id in Booking table
CREATE INDEX idx_booking_property_id ON "Booking" (property_id);

-- Index on booking_id in Booking table
CREATE INDEX idx_booking_booking_id ON "Booking" (booking_id);

-- Index on booking_id in Payment table
CREATE INDEX idx_payment_booking_id ON "Payment" (booking_id);

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_updated_at BEFORE UPDATE ON "Property"
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
