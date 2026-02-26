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
   ingredient_type ingredient_type_enum NOT NULL,
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
   sport_session_rank INT NOT NULL
);

CREATE TABLE sport_exercise(
   sport_exercise_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   sport_exercise_name VARCHAR(255) NOT NULL,
   sport_exercise_objective objective_enum NOT NULL,
   sport_exercise_difficulty difficulty_enum NOT NULL,
   sport_exercise_duration INTEGER,
   sport_exercise_muscle_group muscle_group_enum NOT NULL,
   sport_exercise_video VARCHAR(255),
   sport_exercise_instruction TEXT,
   sport_exercise_cal_burned INT NOT NULL
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
   biometric_heart_rate INT,
   biometric_weight DECIMAL(4,1) NOT NULL,
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
   sport_program_session_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   sport_program_id INT,
   sport_session_id INT,
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

-- Initial data
INSERT INTO company (company_name, company_email, company_inscription) VALUES
('FitCorp', 'contact@fitcorp.com', '2020-01-15'),
('SportLife', 'info@sportlife.fr', '2019-06-01'),
('WellnessHub', 'hello@wellnesshub.io', '2021-03-22');

INSERT INTO subscription (subscription_price, subscription_name, company_id) VALUES
(0.00,  'Freemium', NULL),
(9.99,  'Premium',  NULL),
(19.99, 'Premium+', NULL),
(199.99, 'B2B', 1),
(199.99, 'B2B', 2);

INSERT INTO authorization_ (authorization_type) VALUES
('Freemium'),
('Premium'),
('Premium+');

INSERT INTO subscription_authorization (subscription_id, authorization_id) VALUES
(1, 1),
(2, 2),
(3, 3);

INSERT INTO sport_equipment (sport_equipment_name) VALUES
('Dumbbells'),
('Barbell'),
('Resistance Band'),
('Pull-up Bar'),
('Yoga Mat'),
('Kettlebell'),
('Treadmill'),
('Bench'),
('Cable Machine'),
('Jump Rope');

INSERT INTO sport_exercise (
   sport_exercise_name, sport_exercise_objective, sport_exercise_difficulty,
   sport_exercise_duration, sport_exercise_muscle_group,
   sport_exercise_video, sport_exercise_instruction, sport_exercise_cal_burned
) VALUES
('Push-up',          'muscle_gain', 'beginner',      30, 'chest',      NULL, 'Keep your body straight. Lower yourself until your chest nearly touches the floor.', 50),
('Pull-up',          'muscle_gain', 'intermediate',  30, 'back',       NULL, 'Grab the bar with palms facing away. Pull yourself up until chin clears the bar.', 80),
('Squat',            'muscle_gain', 'beginner',      40, 'quadriceps', NULL, 'Stand with feet shoulder-width apart. Lower your hips until thighs are parallel.', 70),
('Deadlift',         'muscle_gain', 'advanced',      45, 'back',       NULL, 'Keep your back flat. Drive hips forward as you lift the bar from the floor.', 120),
('Plank',            'endurance',   'beginner',      60, 'abs',        NULL, 'Hold your body in a straight line from head to heels. Engage your core.', 30),
('Running',          'endurance',   'beginner',      30, 'full_body',  NULL, 'Maintain a steady pace. Keep your breathing controlled.', 300),
('Bicep Curl',       'muscle_gain', 'beginner',      30, 'biceps',     NULL, 'Keep elbows close to your torso. Curl the weight toward your shoulder.', 40),
('Tricep Dip',       'muscle_gain', 'intermediate',  30, 'triceps',    NULL, 'Lower your body by bending your elbows. Push back up to the starting position.', 55),
('Shoulder Press',   'muscle_gain', 'intermediate',  35, 'shoulders',  NULL, 'Press the dumbbells overhead until arms are fully extended.', 65),
('Lunge',            'muscle_gain', 'beginner',      35, 'quadriceps', NULL, 'Step forward and lower your back knee toward the floor. Keep torso upright.', 60),
('Burpee',           'endurance',   'advanced',      20, 'full_body',  NULL, 'Drop to a push-up, jump feet to hands, then jump up with arms overhead.', 100),
('Mountain Climber', 'endurance',   'intermediate',  30, 'abs',        NULL, 'From plank position, alternate driving knees toward chest quickly.', 80),
('Hip Thrust',       'muscle_gain', 'intermediate',  40, 'glutes',     NULL, 'Drive your hips upward, squeezing glutes at the top of the movement.', 70),
('Calf Raise',       'muscle_gain', 'beginner',      30, 'calves',     NULL, 'Rise up onto the balls of your feet, hold briefly, then lower.', 35),
('Jump Rope',        'endurance',   'beginner',      20, 'full_body',  NULL, 'Keep elbows close to your sides. Jump just high enough to clear the rope.', 200);

INSERT INTO sport_exercise_equipment (sport_exercise_id, sport_equipment_id) VALUES
(1,  5),  -- Push-up -> Yoga Mat
(2,  4),  -- Pull-up -> Pull-up Bar
(3,  5),  -- Squat -> Yoga Mat
(4,  2),  -- Deadlift -> Barbell
(5,  5),  -- Plank -> Yoga Mat
(7,  1),  -- Bicep Curl -> Dumbbells
(8,  8),  -- Tricep Dip -> Bench
(9,  1),  -- Shoulder Press -> Dumbbells
(13, 8),  -- Hip Thrust -> Bench
(15, 10); -- Jump Rope -> Jump Rope

INSERT INTO sport_session (sport_session_rank) VALUES
(1), (2), (3),   -- Programme débutant full body (sessions 1-3)
(1), (2), (3),   -- Programme perte de poids (sessions 4-6)
(1), (2), (3);   -- Programme prise de masse (sessions 7-9)

INSERT INTO sport_session_exercise (sport_session_id, sport_exercise_id, sport_session_exercise_rank) VALUES
(1, 1,  1),  -- Push-up
(1, 3,  2),  -- Squat
(1, 5,  3),  -- Plank
(1, 10, 4),  -- Lunge
(1, 14, 5);  -- Calf Raise


INSERT INTO sport_session_exercise (sport_session_id, sport_exercise_id, sport_session_exercise_rank) VALUES
(2, 6,  1),  -- Running
(2, 7,  2),  -- Bicep Curl
(2, 8,  3),  -- Tricep Dip
(2, 9,  4),  -- Shoulder Press
(2, 12, 5);  -- Mountain Climber

INSERT INTO sport_session_exercise (sport_session_id, sport_exercise_id, sport_session_exercise_rank) VALUES
(3, 11, 1),  -- Burpee
(3, 15, 2),  -- Jump Rope
(3, 5,  3),  -- Plank
(3, 1,  4),  -- Push-up
(3, 3,  5);  -- Squat

INSERT INTO sport_session_exercise (sport_session_id, sport_exercise_id, sport_session_exercise_rank) VALUES
(4, 6,  1),  -- Running
(4, 11, 2),  -- Burpee
(4, 15, 3),  -- Jump Rope
(4, 12, 4),  -- Mountain Climber
(4, 5,  5);  -- Plank

INSERT INTO sport_program (sport_program_name, sport_program_objective, sport_program_sessions, sport_program_duration, sport_program_is_active) VALUES
('Full Body Beginner',    'maintenance',  3, 30, TRUE),
('Weight Loss Cardio',    'weight_loss',  3, 45, TRUE),
('Mass Gain Strength',    'muscle_gain',  3, 60, TRUE),
('Endurance Booster',     'endurance',    6, 50, TRUE),
('Flexibility & Balance', 'flexibility',  4, 40, FALSE);

INSERT INTO program_sport_session (sport_program_id, sport_session_id) VALUES
(1, 1), (1, 2), (1, 3),
(2, 3), (2, 1), (2, 2);

INSERT INTO ingredient (
   ingredient_name, ingredient_type,
   ingredient_energy_100g, ingredient_protein_100g, ingredient_fiber_100g,
   ingredient_sugars_100g, ingredient_carbohydrate_100g, ingredient_salt_100g,
   ingredient_fats_100g, ingredient_saturated_fats_100g
) VALUES
('Chicken Breast',  'meat',      165.0, 31.00, 0.00, 0.00, 0.00, 0.07, 3.60, 1.01),
('Brown Rice',      'grain',     370.0,  7.94, 3.50, 0.85, 77.24, 0.01, 2.92, 0.58),
('Broccoli',        'vegetable',  34.0,  2.82, 2.60, 1.70,  6.64, 0.04, 0.37, 0.04),
('Salmon',          'fish',      208.0, 20.42, 0.00, 0.00,  0.00, 0.06, 13.42, 3.05),
('Banana',          'fruit',      89.0,  1.09, 2.60, 12.23, 22.84, 0.01, 0.33, 0.11),
('Egg',             'dairy',     155.0, 12.56, 0.00, 1.12,  1.12, 0.37, 10.61, 3.27),
('Oats',            'grain',     389.0, 16.89, 10.60, 0.99, 66.27, 0.00, 6.90, 1.22),
('Almonds',         'other',     579.0, 21.15,  12.50, 4.35, 21.55, 0.01, 49.93, 3.80),
('Greek Yogurt',    'dairy',      59.0, 10.19,  0.00, 3.60,  3.60, 0.05,  0.39, 0.10),
('Sweet Potato',    'vegetable',  86.0,  1.57,  3.00, 4.18, 20.12, 0.07,  0.05, 0.02),
('Olive Oil',       'other',     884.0,  0.00,  0.00, 0.00,  0.00, 0.00, 100.00, 13.81),
('Spinach',         'vegetable',  23.0,  2.86,  2.20, 0.42,  3.63, 0.08,  0.39, 0.06),
('Lentils',         'legume',    353.0, 25.80, 10.70, 2.03, 60.08, 0.02,  1.06, 0.15),
('Cottage Cheese',  'dairy',      98.0, 11.12,  0.00, 3.38,  3.38, 0.37,  4.51, 1.71),
('Apple',           'fruit',      52.0,  0.26,  2.40, 10.39, 13.81, 0.00,  0.17, 0.03),
('Tuna',            'fish',      144.0, 23.65,  0.00, 0.00,  0.00, 0.08,  4.90, 1.26),
('Quinoa',          'grain',     368.0, 14.12,  7.00, 1.61, 64.16, 0.02,  6.07, 0.71),
('Blueberries',     'fruit',      57.0,  0.74,  2.40, 9.96, 14.49, 0.00,  0.33, 0.03),
('Black Beans',     'legume',    341.0, 21.60, 15.50, 0.32, 62.36, 0.00,  1.42, 0.36),
('Avocado',         'fruit',     160.0,  2.00,  6.70, 0.66,  8.53, 0.00, 14.66, 2.13);

INSERT INTO ingredient_allergy (ingredient_id, allergy) VALUES
(6,  'eggs'),
(7,  'gluten'),
(8,  'nuts'),
(9,  'milk'),
(14, 'milk');

INSERT INTO recipe (recipe_name, recipe_description, recipe_preparation, recipe_type, recipe_image) VALUES
('Chicken & Rice Bowl',
 'A high-protein post-workout meal with brown rice and steamed broccoli.',
 'Cook rice. Grill chicken breast with olive oil. Steam broccoli. Assemble in a bowl.',
 'lunch', NULL),

('Salmon Power Bowl',
 'Rich in omega-3, perfect for muscle recovery.',
 'Bake salmon at 180°C for 20min. Cook quinoa. Serve with spinach and avocado.',
 'dinner', NULL),

('Oat & Banana Smoothie',
 'Quick energy breakfast before training.',
 'Blend oats, banana, greek yogurt and a splash of water until smooth.',
 'breakfast', NULL),

('Lentil Veggie Soup',
 'High fiber vegetarian meal to support digestion and weight loss.',
 'Sauté onions. Add lentils, sweet potato, spinach. Simmer 30min.',
 'weight_loss', NULL),

('Tuna Salad',
 'Light and protein-packed lunch.',
 'Mix tuna, black beans, avocado and a drizzle of olive oil.',
 'lunch', NULL),

('Almond Blueberry Yogurt',
 'A healthy snack rich in antioxidants and healthy fats.',
 'Mix greek yogurt with blueberries and crushed almonds.',
 'snack', NULL),

('Quinoa Egg Bowl',
 'Balanced muscle-gain meal with complete proteins.',
 'Cook quinoa. Fry eggs in olive oil. Top with spinach.',
 'muscle_gain', NULL),

('Sweet Potato & Black Bean',
 'Vegan-friendly complex carb meal.',
 'Roast sweet potato cubes. Mix with black beans and olive oil.',
 'dinner', NULL);

 -- Chicken & Rice Bowl
INSERT INTO recipe_ingredient (recipe_id, ingredient_id, ingredient_quantity) VALUES
(1, 1, 150.0),
(1, 2, 100.0),  
(1, 3,  80.0), 
(1, 11, 10.0);

-- Salmon Power Bowl
INSERT INTO recipe_ingredient (recipe_id, ingredient_id, ingredient_quantity) VALUES
(2, 4,  130.0),
(2, 17, 80.0),
(2, 12, 50.0),
(2, 20, 50.0);

-- Oat & Banana Smoothie
INSERT INTO recipe_ingredient (recipe_id, ingredient_id, ingredient_quantity) VALUES
(3, 7, 60.0),  
(3, 5, 100.0),
(3, 9, 150.0);

-- Lentil Veggie Soup
INSERT INTO recipe_ingredient (recipe_id, ingredient_id, ingredient_quantity) VALUES
(4, 13, 100.0),
(4, 10, 120.0),
(4, 12, 60.0);

-- Tuna Salad
INSERT INTO recipe_ingredient (recipe_id, ingredient_id, ingredient_quantity) VALUES
(5, 16, 120.0),
(5, 19, 80.0),
(5, 20, 50.0),
(5, 11, 10.0);

-- Almond Blueberry Yogurt
INSERT INTO recipe_ingredient (recipe_id, ingredient_id, ingredient_quantity) VALUES
(6, 9,  150.0),
(6, 18,  60.0),
(6, 8,   20.0);

-- Quinoa Egg Bowl
INSERT INTO recipe_ingredient (recipe_id, ingredient_id, ingredient_quantity) VALUES
(7, 17, 80.0),
(7, 6,  100.0),
(7, 12, 50.0),
(7, 11, 10.0);

-- Sweet Potato & Black Bean
INSERT INTO recipe_ingredient (recipe_id, ingredient_id, ingredient_quantity) VALUES
(8, 10, 150.0),
(8, 19, 100.0),
(8, 11,  10.0);

INSERT INTO user_ (
   user_username, user_firstname, user_lastname, user_birth,
   user_role, user_gender, user_city, user_country,
   user_phone, user_size, user_weight,
   user_email, user_hashpwd, user_inscription,
   sport_program_id, company_id
) VALUES
('jdoe',      'John',    'Doe',      '1990-05-14', 'user',          'male',   'Paris',      'France',     '+33612345678', 178, 75.5, 'john.doe@email.com',      '$2b$12$examplehash1', '2024-01-10', 1, NULL),
('asmith',    'Alice',   'Smith',    '1995-08-22', 'user',          'female', 'Lyon',       'France',     '+33698765432', 165, 58.0, 'alice.smith@email.com',   '$2b$12$examplehash2', '2024-02-15', 2, NULL),
('bmartin',   'Bob',     'Martin',   '1988-11-03', 'user',          'male',   'Marseille',  'France',     '+33611223344', 182, 90.2, 'bob.martin@email.com',    '$2b$12$examplehash3', '2024-03-01', 3, 1),
('cdurand',   'Claire',  'Durand',   '2000-02-28', 'user',          'female', 'Bordeaux',   'France',     '+33655443322', 170, 62.5, 'claire.durand@email.com', '$2b$12$examplehash4', '2024-03-15', 2, 2),
('admin1',    'Admin',   'System',   '1985-01-01', 'admin',         'other',  'Paris',      'France',     '+33600000001', 175, 70.0, 'admin@fitapp.com',        '$2b$12$examplehash5', '2023-01-01', NULL, NULL),
('mlopez',    'Miguel',  'Lopez',    '1993-04-10', 'user',          'male',   'Toulouse',   'France',     '+33644556677', 175, 80.0, 'miguel.lopez@email.com',  '$2b$12$examplehash7', '2024-04-20', 1, NULL),
('nwong',     'Nina',    'Wong',     '1998-12-05', 'user',          'female', 'Strasbourg', 'France',     '+33688990011', 160, 55.0, 'nina.wong@email.com',     '$2b$12$examplehash8', '2024-05-05', 4, 2);

INSERT INTO user_health_profile (user_health_profile_objective, user_health_profile_activity, user_health_profile_food_diet, user_id) VALUES
('maintenance',  'moderately_active', 'none',         1),
('weight_loss',  'lightly_active',    'vegetarian',   2),
('muscle_gain',  'very_active',       'none',         3),
('weight_loss',  'moderately_active', 'gluten_free',  4),
('maintenance',  'extra_active',      'none',         5),
('muscle_gain',  'very_active',       'none',         6),
('endurance',    'moderately_active', 'vegan',        7);

INSERT INTO user_allergy (user_id, allergy) VALUES
(2, 'gluten'),
(4, 'gluten'),
(4, 'milk'),
(6, 'nuts');

INSERT INTO user_biometric (biometric_date, biometric_sleep, biometric_steps, biometric_heart_rate, biometric_weight, user_id) VALUES
('2024-06-01', 420, 8500,  72, 75.5, 1),
('2024-06-08', 390, 9200,  70, 75.2, 1),
('2024-06-15', 450, 10100, 68, 74.8, 1),
('2024-06-01', 480, 6000,  75, 58.0, 2),
('2024-06-08', 460, 6500,  74, 57.8, 2),
('2024-06-01', 360, 12000, 65, 90.2, 3),
('2024-06-08', 400, 13500, 62, 89.8, 3),
('2024-06-01', 420, 7800,  78, 62.5, 4),
('2024-06-01', 500, 5000,  80, 80.0, 7),
('2024-06-08', 480, 5500,  78, 79.5, 7);

INSERT INTO user_subscription (user_id, subscription_id, user_subscription_start, user_subscription_end, user_subscription_is_active) VALUES
(1, 2, '2024-01-10', NULL,         TRUE),   -- John -> Premium
(2, 1, '2024-02-15', NULL,         TRUE),   -- Alice -> Freemium
(3, 3, '2024-03-01', NULL,         TRUE),   -- Bob -> Premium+
(4, 2, '2024-03-15', NULL,         TRUE),   -- Claire -> Premium
(5, 3, '2023-01-01', NULL,         TRUE),   -- Admin -> Premium+
(6, 3, '2023-06-01', NULL,         TRUE),   -- Miguel -> Premium+
(7, 1, '2024-04-20', '2024-07-20', FALSE),  -- Nina -> Freemium expiré
(7, 2, '2024-07-21', NULL,         TRUE);   -- Nina -> Premium actif

INSERT INTO session_progress (session_progress_start, session_progress_end, sport_session_id, user_id) VALUES
('2024-06-01', '2024-06-01', 1, 1),
('2024-06-03', '2024-06-03', 2, 1),
('2024-06-05', '2024-06-05', 3, 1),
('2024-06-01', '2024-06-01', 4, 2),
('2024-06-04', NULL,         5, 2),
('2024-06-01', '2024-06-01', 7, 3),
('2024-06-03', '2024-06-03', 8, 3),
('2024-06-05', '2024-06-05', 9, 3),
('2024-06-02', '2024-06-02', 4, 4),
('2024-06-02', '2024-06-02', 1, 7);

INSERT INTO consume (user_id, ingredient_id, ingredient_quantity, consume_date) VALUES
(1, 1,  150.0, '2024-06-01'),  -- John -> Chicken Breast
(1, 2,  100.0, '2024-06-01'),  -- John -> Brown Rice
(1, 5,  120.0, '2024-06-01'),  -- John -> Banana
(2, 9,  150.0, '2024-06-01'),  -- Alice ->Greek Yogurt
(3, 1,  200.0, '2024-06-01'),  -- Bob -> Chicken Breast
(3, 17,  80.0, '2024-06-01'),  -- Bob -> Quinoa
(4, 13, 100.0, '2024-06-01'),  -- Claire -> Lentils
(4, 20,  50.0, '2024-06-01'),  -- Claire -> Avocado
(7, 1,  180.0, '2024-06-01'),  -- Nina -> Chicken Breast
(7, 10, 150.0, '2024-06-01');  -- Nina -> Sweet Potato