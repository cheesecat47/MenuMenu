CREATE TABLE "recipe_basic" (
	"recipe_id"	INTEGER,
	"food_name"	TEXT NOT NULL,
	"summary"	TEXT,
	"serving"	INTEGER,
	"food_image_URL"	TEXT NOT NULL,
	PRIMARY KEY("recipe_id")
);

CREATE TABLE "recipe_ingredient" (
	"recipe_id"	INTEGER NOT NULL,
	"ingredient_id"	INTEGER,
	"ingredient_name"	TEXT NOT NULL,
	"amount"	TEXT,
	PRIMARY KEY("ingredient_id")
    FOREIGN KEY("recipe_id") REFERENCES recipe_basic("recipe_id")
);

CREATE TABLE "recipe_process" (
	"recipe_id"	INTEGER,
	"process_order"	INTEGER,
	"description"	TEXT NOT NULL,
	"process_image_URL"	TEXT,
	PRIMARY KEY("recipe_id","process_order")
    FOREIGN KEY("recipe_id") REFERENCES recipe_basic("recipe_id")
);

CREATE VIEW "recipe_summary_view" AS
SELECT recipe_id, food_name, food_image_URL
FROM recipe_basic;
