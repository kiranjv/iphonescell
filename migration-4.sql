CREATE TABLE IF NOT EXISTS "emergency_contacts" ("id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , "name" VARCHAR, "number" VARCHAR);

DROP TABLE IF EXISTS "fake_location_manager_settings";

CREATE TABLE IF NOT EXISTS  "fake_location_manager_settings" ("id" INTEGER PRIMARY KEY  NOT NULL ,"item" TEXT NOT NULL ,"value" TEXT);

INSERT INTO "fake_location_manager_settings" VALUES(1,'last_used_data_file','');

CREATE TABLE IF NOT EXISTS  "interruptions" ("id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , "started_at" DATETIME, "ended_at" DATETIME, "journey_id" INTEGER, "latitude" FLOAT, "longitude" FLOAT, "estimated_speed" FLOAT, "paused" BOOL, "terminated_app" BOOL);

CREATE TABLE IF NOT EXISTS  "journey_events" ("id" INTEGER PRIMARY KEY  NOT NULL ,"journey_id" INTEGER NOT NULL ,"points" FLOAT NOT NULL ,"near" VARCHAR,"description" VARCHAR,"timestamp" DATETIME);

CREATE TABLE IF NOT EXISTS  "rules" ("rule_id" INTEGER PRIMARY KEY  NOT NULL ,"zone_id" INTEGER,"bus_driver" BOOL,"novice" BOOL,"primary_rule" BOOL,"crash_collection" BOOL,"preemption" BOOL,"all_drivers" BOOL,"rule_type" VARCHAR,"label" VARCHAR,"created_at" DATETIME,"updated_at" DATETIME,"active" BOOL);

CREATE TABLE IF NOT EXISTS  "school_proximity_data" ("id" INTEGER PRIMARY KEY  NOT NULL ,"latitude" VARCHAR,"longitude" VARCHAR,"found_schools" BOOL);

CREATE TABLE IF NOT EXISTS  "trip_journeys_temp" ("trip_journey_id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , "points" INTEGER NOT NULL , "miles" FLOAT NOT NULL , "trip_date" DATETIME NOT NULL , "checks" INTEGER NOT NULL , "estimated_speed" FLOAT, "trip_id" INTEGER);

INSERT INTO trip_journeys_temp (trip_journey_id, points, miles, trip_date, checks, estimated_speed, trip_id) 
SELECT trip_journey_id, points, miles, trip_date, checks, estimated_speed, trip_id FROM trip_journeys;

DROP TABLE trip_journeys;

CREATE TABLE  IF NOT EXISTS "trip_journeys" ("trip_journey_id" INTEGER PRIMARY KEY  NOT NULL ,"points" INTEGER NOT NULL ,"miles" FLOAT NOT NULL ,"trip_date" DATETIME NOT NULL ,"estimated_speed" FLOAT,"trip_id" INTEGER);

INSERT INTO trip_journeys (trip_journey_id, points, miles, trip_date,  estimated_speed, trip_id) SELECT trip_journey_id, points, miles, trip_date, estimated_speed, trip_id FROM trip_journeys_temp;

DROP TABLE trip_journeys_temp;
