CREATE  TABLE IF NOT EXISTS "resolved_locations" ("id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , "latitude" VARCHAR, "longitude" VARCHAR, "sublocality" VARCHAR, "city" VARCHAR, "state" VARCHAR);

CREATE TABLE IF NOT EXISTS "app_settings_items" ("id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , "settings_item" VARCHAR, "value" VARCHAR);

INSERT INTO "app_settings_items" VALUES(1,'gameplay','1');