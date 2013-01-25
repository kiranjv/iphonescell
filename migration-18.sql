ALTER TABLE "accounts" ADD COLUMN "archived" BOOL DEFAULT 0;

ALTER TABLE "accounts" ADD COLUMN "point_balance" INTEGER DEFAULT 0;

ALTER TABLE "accounts" ADD COLUMN "chargify_id" VARCHAR DEFAULT 0;

ALTER TABLE "accounts" ADD COLUMN "status" VARCHAR DEFAULT "open";

ALTER TABLE "accounts" ADD COLUMN "perks_id" VARCHAR;

ALTER TABLE "profiles" ADD COLUMN "device_family" VARCHAR;

ALTER TABLE "profiles" ADD COLUMN "expires_on" DATETIME;

ALTER TABLE "profiles" ADD COLUMN "app_version" VARCHAR DEFAULT "1.0";

ALTER TABLE "profiles" ADD COLUMN "status" VARCHAR DEFAULT open;

ALTER TABLE "profiles" ADD COLUMN "points_earned" INTEGER DEFAULT 0;