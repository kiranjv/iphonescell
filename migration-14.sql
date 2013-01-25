ALTER TABLE "profiles" ADD COLUMN "license_class_key" VARCHAR DEFAULT "class_c";

CREATE  TABLE  IF NOT EXISTS "license_classes" ("id" INTEGER PRIMARY KEY  NOT NULL , "key" VARCHAR, "name" VARCHAR, "description" VARCHAR);