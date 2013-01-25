DELETE FROM "resolved_locations" WHERE 1;
ALTER TABLE "resolved_locations" ADD COLUMN "zip_code" VARCHAR;