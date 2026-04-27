-- ENUMS
CREATE TYPE user_role_enum AS ENUM ('admin', 'user', 'company_admin');

CREATE TYPE gender_enum AS ENUM ('male', 'female', 'other', 'prefer_not_to_say');

CREATE TYPE objective_enum AS ENUM ('weight_loss', 'muscle_gain', 'endurance', 'flexibility', 'maintenance');

CREATE TYPE difficulty_enum AS ENUM ('beginner', 'intermediate', 'advanced');

CREATE TYPE recipe_type_enum AS ENUM ('breakfast', 'lunch', 'dinner', 'snack', 'dessert', 'pleasure', 'muscle_gain', 'weight_loss');

CREATE TYPE ingredient_type_enum AS ENUM ('vegetable', 'fruit', 'meat', 'fish', 'dairy', 'grain', 'legume', 'other');

CREATE TYPE allergy_enum AS ENUM (
   'gluten', 'crustaceans', 'eggs', 'fish', 'peanuts',
   'soybeans', 'milk', 'nuts', 'celery', 'mustard',
   'sesame', 'sulphites', 'lupin', 'molluscs'
);

CREATE TYPE food_diet_enum AS ENUM ('vegan', 'vegetarian', 'pescatarian', 'gluten_free', 'lactose_free', 'halal', 'kosher', 'none');

CREATE TYPE activity_level_enum AS ENUM ('sedentary', 'lightly_active', 'moderately_active', 'very_active', 'extra_active');

CREATE TYPE authorization_type_enum AS ENUM ('Freemium', 'Premium', 'Premium+');

CREATE TYPE subscription_name_enum AS ENUM ('Freemium', 'Premium', 'Premium+', 'B2B');

CREATE TYPE muscle_group_enum AS ENUM ('chest', 'back', 'shoulders', 'biceps', 'triceps', 'forearms', 'abs', 'glutes', 'quadriceps', 'hamstrings', 'calves', 'full_body');

-- Tables

CREATE TABLE company(
   company_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   company_name VARCHAR(50) NOT NULL,
   company_email VARCHAR(255) NOT NULL,
   company_inscription DATE NOT NULL,
   UNIQUE(company_name),
   UNIQUE(company_email)
);

CREATE TABLE subscription(
   subscription_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   subscription_price DECIMAL(5,2) NOT NULL,
   subscription_name subscription_name_enum NOT NULL,
   company_id INT,
   subscription_company_end DATE, 
   FOREIGN KEY(company_id) REFERENCES company(company_id)
);

CREATE TABLE sport_program(
   sport_program_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   sport_program_name VARCHAR(255) NOT NULL,
   sport_program_objective objective_enum NOT NULL,
   sport_program_sessions INT,
   sport_program_duration INT,
   sport_program_is_active BOOLEAN NOT NULL,
   UNIQUE(sport_program_name)
);

CREATE TABLE recipe(
   recipe_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   recipe_image VARCHAR(255),
   recipe_name VARCHAR(255) NOT NULL,
   recipe_description TEXT,
   recipe_preparation TEXT,
   recipe_type recipe_type_enum,
   UNIQUE(recipe_name)
);

CREATE TABLE ingredient(
   ingredient_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   ingredient_name VARCHAR(100) NOT NULL,
   ingredient_type ingredient_type_enum,
   ingredient_energy_100g DECIMAL(6,1),
   ingredient_protein_100g DECIMAL(6,2),
   ingredient_fiber_100g DECIMAL(6,2),
   ingredient_sugars_100g DECIMAL(6,2),
   ingredient_carbohydrate_100g DECIMAL(6,2),
   ingredient_salt_100g DECIMAL(6,2),
   ingredient_fats_100g DECIMAL(6,2),
   ingredient_saturated_fats_100g DECIMAL(6,2),
   UNIQUE(ingredient_name)
);

CREATE TABLE ingredient_allergy(
   ingredient_id INT NOT NULL,
   allergy allergy_enum NOT NULL,
   PRIMARY KEY(ingredient_id, allergy),
   FOREIGN KEY(ingredient_id) REFERENCES ingredient(ingredient_id)
);

CREATE TABLE sport_session(
   sport_session_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   sport_session_name VARCHAR(255) NOT NULL
);

CREATE TABLE sport_exercise(
   sport_exercise_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   sport_exercise_name VARCHAR(255) NOT NULL,
   sport_exercise_objective objective_enum,
   sport_exercise_difficulty difficulty_enum,
   sport_exercise_duration INTEGER,
   sport_exercise_muscle_group muscle_group_enum,
   sport_exercise_video VARCHAR(255),
   sport_exercise_instruction TEXT,
   sport_exercise_cal_burned INT,
   UNIQUE(sport_exercise_name)
);

CREATE TABLE sport_equipment(
   sport_equipment_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   sport_equipment_name VARCHAR(255) NOT NULL,
   UNIQUE(sport_equipment_name)
);

CREATE TABLE authorization_(
   authorization_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   authorization_type authorization_type_enum NOT NULL,
   UNIQUE(authorization_type)
);

CREATE TABLE user_(
   user_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   user_username VARCHAR(50) NOT NULL,
   user_firstname VARCHAR(50) NOT NULL,
   user_lastname VARCHAR(50) NOT NULL,
   user_birth DATE NOT NULL,
   user_role user_role_enum NOT NULL,
   user_gender gender_enum NOT NULL,
   user_city VARCHAR(50),
   user_country VARCHAR(50),
   user_phone VARCHAR(50) NOT NULL,
   user_size INT NOT NULL,
   user_weight DECIMAL(4,1) NOT NULL,
   user_last_weight DECIMAL(4,1),
   user_email VARCHAR(255) NOT NULL,
   user_hashpwd VARCHAR(255) NOT NULL,
   user_inscription DATE NOT NULL,
   sport_program_id INT,
   company_id INT,
   UNIQUE(user_email),
   FOREIGN KEY(sport_program_id) REFERENCES sport_program(sport_program_id),
   FOREIGN KEY(company_id) REFERENCES company(company_id)
);


CREATE TABLE user_health_profile(
   users_health_profile_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   user_health_profile_objective objective_enum,
   user_health_profile_activity activity_level_enum,
   user_health_profile_food_diet food_diet_enum,
   user_id INT NOT NULL,
   FOREIGN KEY(user_id) REFERENCES user_(user_id)
);

CREATE TABLE user_allergy(
   user_id INT NOT NULL,
   allergy allergy_enum NOT NULL,
   PRIMARY KEY(user_id, allergy),
   FOREIGN KEY(user_id) REFERENCES user_(user_id)
);

CREATE TABLE user_biometric(
   biometric_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   biometric_date DATE NOT NULL,
   biometric_sleep INT,
   biometric_steps INT,
   biometric_weight DECIMAL(4,1),
   user_id INT NOT NULL,
   FOREIGN KEY(user_id) REFERENCES user_(user_id)
);

CREATE TABLE session_progress(
   session_progress_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   session_progress_start DATE NOT NULL,
   session_progress_end DATE,
   sport_session_id INT NOT NULL,
   user_id INT NOT NULL,
   FOREIGN KEY(sport_session_id) REFERENCES sport_session(sport_session_id),
   FOREIGN KEY(user_id) REFERENCES user_(user_id)
);

CREATE TABLE user_subscription(
   user_subscription_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   user_id INT,
   subscription_id INT,
   user_subscription_start DATE NOT NULL,
   user_subscription_end DATE,
   user_subscription_is_active BOOLEAN NOT NULL,
   FOREIGN KEY(user_id) REFERENCES user_(user_id),
   FOREIGN KEY(subscription_id) REFERENCES subscription(subscription_id)
);

CREATE TABLE recipe_ingredient(
   recipe_ingredient_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   recipe_id INT,
   ingredient_id INT,
   ingredient_quantity DECIMAL(6,1) NOT NULL,
   FOREIGN KEY(recipe_id) REFERENCES recipe(recipe_id),
   FOREIGN KEY(ingredient_id) REFERENCES ingredient(ingredient_id)
);

CREATE TABLE program_sport_session(
   program_sport_session_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   sport_program_id INT,
   sport_session_id INT,
   program_sport_session_rank INT NOT NULL,
   FOREIGN KEY(sport_program_id) REFERENCES sport_program(sport_program_id),
   FOREIGN KEY(sport_session_id) REFERENCES sport_session(sport_session_id)
);

CREATE TABLE sport_session_exercise(
   sport_session_exercise_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   sport_session_id INT,
   sport_exercise_id INT,
   sport_session_exercise_rank INT NOT NULL,
   FOREIGN KEY(sport_session_id) REFERENCES sport_session(sport_session_id),
   FOREIGN KEY(sport_exercise_id) REFERENCES sport_exercise(sport_exercise_id)
);

CREATE TABLE sport_exercise_equipment(
   sport_exercise_equipment_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   sport_exercise_id INT,
   sport_equipment_id INT,
   FOREIGN KEY(sport_exercise_id) REFERENCES sport_exercise(sport_exercise_id),
   FOREIGN KEY(sport_equipment_id) REFERENCES sport_equipment(sport_equipment_id)
);

CREATE TABLE subscription_authorization(
   subscription_authorization_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   subscription_id INT,
   authorization_id INT,
   FOREIGN KEY(subscription_id) REFERENCES subscription(subscription_id),
   FOREIGN KEY(authorization_id) REFERENCES authorization_(authorization_id)
);

CREATE TABLE consume(
   consume_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   user_id INT,
   ingredient_id INT,
   ingredient_quantity DECIMAL(6,1) NOT NULL,
   consume_date DATE NOT NULL,
   FOREIGN KEY(user_id) REFERENCES user_(user_id),
   FOREIGN KEY(ingredient_id) REFERENCES ingredient(ingredient_id)
);