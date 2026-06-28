-- =============================================================================
-- HealthAI — Données de démonstration
-- Chargé après 01-init.sql (ordre alphabétique garanti par le préfixe)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Équipements sportifs
-- -----------------------------------------------------------------------------
INSERT INTO sport_equipment (sport_equipment_name) VALUES
  ('Haltères'),
  ('Barre de traction'),
  ('Tapis de sol'),
  ('Vélo stationnaire'),
  ('Corde à sauter')
ON CONFLICT (sport_equipment_name) DO NOTHING;

-- -----------------------------------------------------------------------------
-- Exercices
-- -----------------------------------------------------------------------------
INSERT INTO sport_exercise (sport_exercise_name, sport_exercise_objective, sport_exercise_difficulty, sport_exercise_duration, sport_exercise_muscle_group, sport_exercise_cal_burned, sport_exercise_instruction) VALUES
  ('Pompes',           'muscle_gain',  'beginner',     15, 'chest',       100, 'Position planche, mains écartées à la largeur des épaules. Descendre jusqu''à ce que la poitrine frôle le sol, puis repousser.'),
  ('Squat',            'muscle_gain',  'beginner',     20, 'quadriceps',  150, 'Pieds écartés à la largeur des épaules. Fléchir les genoux en gardant le dos droit jusqu''à la position assise, puis se relever.'),
  ('Planche',          'maintenance',  'beginner',     10, 'abs',          80, 'Position planche sur les avant-bras, corps bien aligné. Maintenir la position en contractant les abdominaux.'),
  ('Course à pied',    'weight_loss',  'beginner',     30, 'full_body',   300, 'Courir à allure modérée. Maintenir une respiration régulière. Adapter la vitesse pour tenir la durée prévue.'),
  ('Tractions',        'muscle_gain',  'intermediate', 20, 'back',        120, 'Saisir la barre, mains en pronation. Tirer le corps vers le haut jusqu''au menton au-dessus de la barre, puis redescendre lentement.'),
  ('Développé couché', 'muscle_gain',  'intermediate', 25, 'chest',       130, 'Allongé sur le banc, saisir la barre à largeur d''épaules. Descendre la barre vers la poitrine puis repousser.'),
  ('Burpees',          'weight_loss',  'intermediate', 20, 'full_body',   200, 'Position debout, s''accroupir, placer les mains au sol, sauter en position planche, faire une pompe, revenir, sauter avec les bras levés.'),
  ('Fentes',           'weight_loss',  'beginner',     15, 'quadriceps',  120, 'Faire un grand pas en avant, fléchir les deux genoux à 90°. Le genou arrière ne doit pas toucher le sol. Alterner les jambes.'),
  ('Gainage latéral',  'maintenance',  'beginner',     10, 'abs',          60, 'Allongé sur le côté, s''appuyer sur l''avant-bras. Soulever le bassin pour aligner tête, épaules et pieds. Maintenir.'),
  ('Rowing haltères',  'muscle_gain',  'intermediate', 20, 'back',        100, 'Un genou et une main sur le banc, tenir l''haltère dans l''autre main. Tirer l''haltère vers la hanche en gardant le coude près du corps.')
ON CONFLICT (sport_exercise_name) DO NOTHING;

-- Équipements associés aux exercices
INSERT INTO sport_exercise_equipment (sport_exercise_id, sport_equipment_id)
SELECT e.sport_exercise_id, eq.sport_equipment_id
FROM sport_exercise e, sport_equipment eq
WHERE (e.sport_exercise_name = 'Pompes'           AND eq.sport_equipment_name = 'Tapis de sol')
   OR (e.sport_exercise_name = 'Planche'          AND eq.sport_equipment_name = 'Tapis de sol')
   OR (e.sport_exercise_name = 'Tractions'        AND eq.sport_equipment_name = 'Barre de traction')
   OR (e.sport_exercise_name = 'Développé couché' AND eq.sport_equipment_name = 'Haltères')
   OR (e.sport_exercise_name = 'Rowing haltères'  AND eq.sport_equipment_name = 'Haltères')
   OR (e.sport_exercise_name = 'Gainage latéral'  AND eq.sport_equipment_name = 'Tapis de sol')
   OR (e.sport_exercise_name = 'Course à pied'    AND eq.sport_equipment_name = 'Corde à sauter');

-- -----------------------------------------------------------------------------
-- Séances d'entraînement
-- -----------------------------------------------------------------------------
INSERT INTO sport_session (sport_session_name) VALUES
  ('Cardio brûle-graisse'),
  ('Renforcement haut du corps'),
  ('Jambes et fessiers'),
  ('Abdos et gainage')
ON CONFLICT DO NOTHING;

-- Exercices dans chaque séance
INSERT INTO sport_session_exercise (sport_session_id, sport_exercise_id, sport_session_exercise_rank)
SELECT s.sport_session_id, e.sport_exercise_id, mapping.rank
FROM (VALUES
  ('Cardio brûle-graisse',        'Course à pied',    1),
  ('Cardio brûle-graisse',        'Burpees',          2),
  ('Cardio brûle-graisse',        'Fentes',           3),
  ('Renforcement haut du corps',  'Pompes',           1),
  ('Renforcement haut du corps',  'Développé couché', 2),
  ('Renforcement haut du corps',  'Rowing haltères',  3),
  ('Renforcement haut du corps',  'Tractions',        4),
  ('Jambes et fessiers',          'Squat',            1),
  ('Jambes et fessiers',          'Fentes',           2),
  ('Abdos et gainage',            'Planche',          1),
  ('Abdos et gainage',            'Gainage latéral',  2)
) AS mapping(session_name, exercise_name, rank)
JOIN sport_session  s ON s.sport_session_name  = mapping.session_name
JOIN sport_exercise e ON e.sport_exercise_name = mapping.exercise_name;

-- -----------------------------------------------------------------------------
-- Programmes sportifs
-- -----------------------------------------------------------------------------
INSERT INTO sport_program (sport_program_name, sport_program_objective, sport_program_sessions, sport_program_duration, sport_program_is_active) VALUES
  ('Perte de poids débutant',   'weight_loss',  3, 4,  true),
  ('Prise de masse intermédiaire', 'muscle_gain', 4, 8, true),
  ('Endurance et cardio',       'endurance',    3, 6,  true)
ON CONFLICT (sport_program_name) DO NOTHING;

-- Séances dans chaque programme
INSERT INTO program_sport_session (sport_program_id, sport_session_id, program_sport_session_rank)
SELECT p.sport_program_id, s.sport_session_id, mapping.rank
FROM (VALUES
  ('Perte de poids débutant',      'Cardio brûle-graisse',       1),
  ('Perte de poids débutant',      'Jambes et fessiers',         2),
  ('Perte de poids débutant',      'Abdos et gainage',           3),
  ('Prise de masse intermédiaire', 'Renforcement haut du corps', 1),
  ('Prise de masse intermédiaire', 'Jambes et fessiers',         2),
  ('Prise de masse intermédiaire', 'Abdos et gainage',           3),
  ('Prise de masse intermédiaire', 'Renforcement haut du corps', 4),
  ('Endurance et cardio',          'Cardio brûle-graisse',       1),
  ('Endurance et cardio',          'Jambes et fessiers',         2),
  ('Endurance et cardio',          'Abdos et gainage',           3)
) AS mapping(program_name, session_name, rank)
JOIN sport_program p ON p.sport_program_name  = mapping.program_name
JOIN sport_session  s ON s.sport_session_name = mapping.session_name;

-- -----------------------------------------------------------------------------
-- Abonnements et autorisations
-- -----------------------------------------------------------------------------
INSERT INTO authorization_ (authorization_type) VALUES
  ('Freemium'),
  ('Premium'),
  ('Premium+')
ON CONFLICT (authorization_type) DO NOTHING;

INSERT INTO subscription (subscription_price, subscription_name) VALUES
  (0.00,  'Freemium'),
  (9.99,  'Premium'),
  (19.99, 'Premium+')
ON CONFLICT DO NOTHING;

INSERT INTO subscription_authorization (subscription_id, authorization_id)
SELECT s.subscription_id, a.authorization_id
FROM (VALUES
  ('Freemium', 'Freemium'),
  ('Premium',  'Freemium'),
  ('Premium',  'Premium'),
  ('Premium+', 'Freemium'),
  ('Premium+', 'Premium'),
  ('Premium+', 'Premium+')
) AS mapping(sub_name, auth_type)
JOIN subscription   s ON s.subscription_name   = mapping.sub_name::subscription_name_enum
JOIN authorization_ a ON a.authorization_type  = mapping.auth_type::authorization_type_enum;

-- Abonnement actif pour l'utilisateur de démo
INSERT INTO user_subscription (user_id, subscription_id, user_subscription_start, user_subscription_end, user_subscription_is_active)
SELECT
  u.user_id,
  s.subscription_id,
  CURRENT_DATE - INTERVAL '30 days',
  CURRENT_DATE + INTERVAL '335 days',
  true
FROM user_ u, subscription s
WHERE u.user_email = 'user@user.fr'
  AND s.subscription_name = 'Premium';

-- -----------------------------------------------------------------------------
-- Ingrédients (avec valeurs nutritionnelles pour 100g)
-- -----------------------------------------------------------------------------
INSERT INTO ingredient (ingredient_name, ingredient_type, ingredient_energy_100g, ingredient_protein_100g, ingredient_carbohydrate_100g, ingredient_fats_100g, ingredient_saturated_fats_100g, ingredient_fiber_100g, ingredient_sugars_100g, ingredient_salt_100g) VALUES
  ('Poulet (blanc)',        'meat',       165.0, 31.0,  0.0,  3.6, 1.0, 0.0,  0.0, 0.07),
  ('Saumon',                'fish',       208.0, 20.0,  0.0, 13.0, 3.1, 0.0,  0.0, 0.06),
  ('Riz blanc cuit',        'grain',      130.0,  2.7, 28.2,  0.3, 0.1, 0.4,  0.1, 0.01),
  ('Tomate',                'vegetable',   18.0,  0.9,  3.9,  0.2, 0.0, 1.2,  2.6, 0.01),
  ('Banane',                'fruit',       89.0,  1.1, 23.0,  0.3, 0.1, 2.6, 12.2, 0.01),
  ('Lait demi-écrémé',      'dairy',       46.0,  3.2,  4.8,  1.5, 1.0, 0.0,  4.8, 0.10),
  ('Lentilles cuites',      'legume',     116.0,  9.0, 20.0,  0.4, 0.1, 7.9,  1.8, 0.01),
  ('Épinards',              'vegetable',   23.0,  2.9,  3.6,  0.4, 0.1, 2.2,  0.4, 0.07),
  ('Flocons d''avoine',     'grain',      389.0, 17.0, 66.0,  7.0, 1.4, 10.6, 1.1, 0.01),
  ('Amandes',               'other',      579.0, 21.0, 22.0, 50.0, 3.8, 12.5, 4.4, 0.01),
  ('Œuf entier',            'dairy',      155.0, 13.0,  1.1, 11.0, 3.3, 0.0,  1.1, 0.37),
  ('Brocoli',               'vegetable',   34.0,  2.8,  7.0,  0.4, 0.0, 2.6,  1.7, 0.03),
  ('Pâtes complètes cuites','grain',      124.0,  5.3, 23.0,  1.1, 0.2, 3.7,  0.6, 0.01),
  ('Yaourt nature 0%',      'dairy',       35.0,  5.3,  4.8,  0.1, 0.1, 0.0,  4.8, 0.06)
ON CONFLICT (ingredient_name) DO NOTHING;

-- Allergènes
INSERT INTO ingredient_allergy (ingredient_id, allergy)
SELECT i.ingredient_id, mapping.allergy::allergy_enum
FROM (VALUES
  ('Lait demi-écrémé',  'milk'),
  ('Yaourt nature 0%',  'milk'),
  ('Flocons d''avoine', 'gluten'),
  ('Amandes',           'nuts'),
  ('Œuf entier',        'eggs'),
  ('Pâtes complètes cuites', 'gluten')
) AS mapping(ingredient_name, allergy)
JOIN ingredient i ON i.ingredient_name = mapping.ingredient_name
ON CONFLICT DO NOTHING;

-- -----------------------------------------------------------------------------
-- Recettes
-- -----------------------------------------------------------------------------
INSERT INTO recipe (recipe_name, recipe_type, recipe_description, recipe_preparation) VALUES
  ('Salade de poulet grillé',
   'lunch',
   'Une salade légère et protéinée, idéale pour la perte de poids.',
   '1. Griller le blanc de poulet 15 min. 2. Couper les tomates et laver les épinards. 3. Assembler et assaisonner d''huile d''olive et citron.'),
  ('Bowl riz-saumon',
   'dinner',
   'Bowl équilibré riche en oméga-3, parfait après l''entraînement.',
   '1. Cuire le riz. 2. Faire revenir le saumon 10 min. 3. Disposer dans un bol avec les épinards. 4. Assaisonner de sauce soja.'),
  ('Porridge banane-amandes',
   'breakfast',
   'Petit-déjeuner énergétique pour bien commencer la journée.',
   '1. Faire chauffer les flocons d''avoine avec le lait 5 min. 2. Couper la banane en rondelles. 3. Ajouter les amandes concassées.'),
  ('Omelette aux épinards',
   'breakfast',
   'Omelette protéinée pour un déjeuner rapide et nutritif.',
   '1. Battre les œufs. 2. Faire revenir les épinards. 3. Cuire l''omelette à feu moyen 5 min.'),
  ('Lentilles au brocoli',
   'dinner',
   'Plat végétarien complet, riche en fibres et en protéines végétales.',
   '1. Cuire les lentilles 20 min. 2. Cuire le brocoli à la vapeur. 3. Mélanger et assaisonner.')
ON CONFLICT (recipe_name) DO NOTHING;

-- Ingrédients des recettes
INSERT INTO recipe_ingredient (recipe_id, ingredient_id, ingredient_quantity)
SELECT r.recipe_id, i.ingredient_id, mapping.quantity
FROM (VALUES
  ('Salade de poulet grillé',  'Poulet (blanc)',       150.0),
  ('Salade de poulet grillé',  'Tomate',               100.0),
  ('Salade de poulet grillé',  'Épinards',              80.0),
  ('Bowl riz-saumon',          'Saumon',               120.0),
  ('Bowl riz-saumon',          'Riz blanc cuit',       100.0),
  ('Bowl riz-saumon',          'Épinards',              60.0),
  ('Porridge banane-amandes',  'Flocons d''avoine',     60.0),
  ('Porridge banane-amandes',  'Banane',               100.0),
  ('Porridge banane-amandes',  'Lait demi-écrémé',     200.0),
  ('Porridge banane-amandes',  'Amandes',               20.0),
  ('Omelette aux épinards',    'Œuf entier',           150.0),
  ('Omelette aux épinards',    'Épinards',             100.0),
  ('Lentilles au brocoli',     'Lentilles cuites',     200.0),
  ('Lentilles au brocoli',     'Brocoli',              150.0)
) AS mapping(recipe_name, ingredient_name, quantity)
JOIN recipe     r ON r.recipe_name      = mapping.recipe_name
JOIN ingredient i ON i.ingredient_name  = mapping.ingredient_name;

-- -----------------------------------------------------------------------------
-- Profil de santé et programme pour l'utilisateur de démo
-- -----------------------------------------------------------------------------
UPDATE user_
SET sport_program_id = (SELECT sport_program_id FROM sport_program WHERE sport_program_name = 'Perte de poids débutant')
WHERE user_email = 'user@user.fr';

INSERT INTO user_health_profile (user_health_profile_objective, user_health_profile_activity, user_health_profile_food_diet, user_id)
SELECT 'weight_loss', 'moderately_active', 'none', user_id
FROM user_ WHERE user_email = 'user@user.fr';

INSERT INTO user_health_profile (user_health_profile_objective, user_health_profile_activity, user_health_profile_food_diet, user_id)
SELECT 'maintenance', 'very_active', 'none', user_id
FROM user_ WHERE user_email = 'admin@admin.fr';

-- -----------------------------------------------------------------------------
-- Historique biométrique (30 derniers jours) pour l'utilisateur de démo
-- -----------------------------------------------------------------------------
INSERT INTO user_biometric (biometric_date, biometric_sleep, biometric_steps, biometric_weight, user_id)
SELECT
  CURRENT_DATE - (n * INTERVAL '1 day'),
  (6 + (n % 3))::int,
  (6000 + (n * 137) % 6000)::int,
  (82.0 - n * 0.06)::decimal(4,1),
  (SELECT user_id FROM user_ WHERE user_email = 'user@user.fr')
FROM generate_series(0, 29) AS gs(n);

-- -----------------------------------------------------------------------------
-- Historique de consommation alimentaire (14 derniers jours)
-- -----------------------------------------------------------------------------
INSERT INTO consume (user_id, ingredient_id, ingredient_quantity, consume_date)
SELECT
  u.user_id,
  i.ingredient_id,
  mapping.quantity,
  CURRENT_DATE - mapping.days_ago * INTERVAL '1 day'
FROM (VALUES
  ('Poulet (blanc)',     150.0, 0), ('Riz blanc cuit',    100.0, 0), ('Épinards',  80.0, 0),
  ('Flocons d''avoine',  60.0, 0), ('Banane',            100.0, 0),
  ('Saumon',            120.0, 1), ('Riz blanc cuit',    100.0, 1), ('Brocoli',  150.0, 1),
  ('Œuf entier',        150.0, 1), ('Épinards',          100.0, 1),
  ('Poulet (blanc)',     150.0, 2), ('Tomate',            100.0, 2), ('Épinards',  80.0, 2),
  ('Flocons d''avoine',  60.0, 2), ('Lait demi-écrémé',  200.0, 2), ('Amandes',   20.0, 2),
  ('Lentilles cuites',  200.0, 3), ('Brocoli',           150.0, 3),
  ('Saumon',            120.0, 4), ('Pâtes complètes cuites', 150.0, 4),
  ('Œuf entier',        150.0, 5), ('Tomate',            100.0, 5),
  ('Poulet (blanc)',     150.0, 6), ('Riz blanc cuit',    100.0, 6), ('Épinards',  60.0, 6),
  ('Flocons d''avoine',  60.0, 7), ('Banane',            100.0, 7), ('Amandes',   20.0, 7)
) AS mapping(ingredient_name, quantity, days_ago)
JOIN user_     u ON u.user_email      = 'user@user.fr'
JOIN ingredient i ON i.ingredient_name = mapping.ingredient_name;

-- -----------------------------------------------------------------------------
-- Progression des séances (historique entraînements sur 14 jours)
-- -----------------------------------------------------------------------------
INSERT INTO session_progress (session_progress_start, session_progress_end, sport_session_id, user_id, sport_program_id, program_session_rank)
SELECT
  CURRENT_DATE - mapping.days_ago * INTERVAL '1 day',
  CURRENT_DATE - mapping.days_ago * INTERVAL '1 day',
  s.sport_session_id,
  u.user_id,
  p.sport_program_id,
  mapping.rank
FROM (VALUES
  ('Cardio brûle-graisse',    12, 1),
  ('Jambes et fessiers',       9, 2),
  ('Abdos et gainage',         6, 3),
  ('Cardio brûle-graisse',     3, 1),
  ('Jambes et fessiers',       1, 2)
) AS mapping(session_name, days_ago, rank)
JOIN sport_session s ON s.sport_session_name  = mapping.session_name
JOIN user_         u ON u.user_email          = 'user@user.fr'
JOIN sport_program p ON p.sport_program_name  = 'Perte de poids débutant';
