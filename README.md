# healthAI-database

Ce dossier regroupe les bases de données utilisées par healthAI, séparées par moteur de stockage :
- PostgreSQL pour les données relationnelles du coeur métier
- MongoDB pour les contenus sociaux et les publications multimédia

## PostgreSQL

### Fichiers du dossier

- **init.sql** : schéma complet de la base relationnelle, avec les enums, les tables et les données initiales

### Structure de la base

#### Entités principales

| Entité | Description |
|--------|-------------|
| users_ | Utilisateurs de l'application |
| companies | Organisations B2B |
| subscriptions | Plans d'abonnement |
| sport_program | Programmes d'entraînement |
| sport_session | Sessions d'exercices |
| sport_exercise | Exercices individuels |
| recipes | Recettes de cuisine |
| ingredients | Ingrédients alimentaires |

#### Types énumérés

- Rôles : admin, user, company_admin
- Objectifs : weight_loss, muscle_gain, endurance, flexibility, maintenance
- Allergies : gluten, crustaceans, eggs, fish, milk, nuts, etc.
- Régimes : vegan, vegetarian, kosher, halal, etc.
- Niveaux : beginner, intermediate, advanced

### Utilisation

La base PostgreSQL est initialisée automatiquement au démarrage du conteneur grâce au volume suivant :

```yaml
volumes:
  - ./healthAI-database/init.sql:/docker-entrypoint-initdb.d/init.sql
```

### Connexion via DBeaver

DBeaver est une interface graphique pratique pour administrer la base relationnelle.

1. Ouvrir DBeaver puis cliquer sur Database > New Database Connection
2. Sélectionner PostgreSQL puis cliquer Next
3. Renseigner les paramètres de connexion :
   - Server Host : localhost
   - Port : POSTGRES_PORT
   - Database : POSTGRES_DB
   - Username : POSTGRES_USER
   - Password : POSTGRES_PASSWORD

### Données d'exemple

Le fichier init.sql contient des données de démonstration :
- 2 utilisateurs test
- 1 administrateur
- 3 programmes d'entraînement
- 4 exercices
- 2 recettes
- 4 ingrédients

## MongoDB / NoSQL

La partie NoSQL sert au fil social de l'application : publications, commentaires, likes et médias.

### Utilisation dans l'application

- Connexion gérée côté backend par Mongoose
- Base par défaut : healthai_social
- URI par défaut : mongodb://mongodb:27017/healthai_social
- Collection principale : social_posts
- Modèle principal : SocialPost

### Contenu stocké

- auteur de la publication
- texte de l'actualité
- image ou vidéo associée
- likes
- commentaires imbriqués
- dates de création et de mise à jour

### Variables de configuration

- MONGO_URI : chaîne de connexion MongoDB personnalisée
- MONGO_DB_NAME : nom de la base MongoDB à utiliser

Cette base est utilisée par les routes du fil social du backend API et permet de séparer les contenus sociaux des données relationnelles PostgreSQL.