ALTER TABLE "trip_journey_waypoints" ADD COLUMN "background" BOOL NOT NULL  DEFAULT 0;

ALTER TABLE "interruptions" ADD COLUMN "school_zone_active" BOOL NOT NULL  DEFAULT 0;

ALTER TABLE "interruptions" ADD COLUMN "phone_rule_active" BOOL NOT NULL  DEFAULT 0;

ALTER TABLE "interruptions" ADD COLUMN "sms_rule_active" BOOL NOT NULL  DEFAULT 0;