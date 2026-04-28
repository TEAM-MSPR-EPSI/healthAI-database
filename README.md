# healthAI-database

Schéma PostgreSQL et données initiales pour l'application healthAI.

## Fichiers du dossier

- **`init.sql`** : Schéma complet de la base de données (enums, tables, données initiales)

## Structure de la base de données

### Entités principales

| Entité | Description |
|--------|-------------|
| **users_** | Utilisateurs de l'application |
| **companies** | Organisations (B2B) |
| **subscriptions** | Plans d'abonnement |
| **sport_program** | Programmes d'entraînement |
| **sport_session** | Sessions d'exercices |
| **sport_exercise** | Exercices individuels |
| **recipes** | Recettes de cuisine |
| **ingredients** | Ingrédients alimentaires |

## Types énumérés

- **Rôles** : admin, user, company_admin
- **Objectifs** : weight_loss, muscle_gain, endurance, flexibility, maintenance
- **Allergies** : gluten, crustaceans, eggs, fish, milk, nuts, etc.
- **Régimes** : vegan, vegetarian, kosher, halal, etc.
- **Niveaux** : beginner, intermediate, advanced

## Utilisation

La base de données est initialisée automatiquement au démarrage du conteneur PostgreSQL grâce au volume :

```yaml
volumes:
  - ./healthAI-database/init.sql:/docker-entrypoint-initdb.d/init.sql
```

## Connexion via DBeaver

DBeaver est une interface graphique pour gérer les bases de données facilement.

### Configuration de la connexion

1. **Ouvrir DBeaver** et cliquer sur `Database` → `New Database Connection`
2. Sélectionner **PostgreSQL** et cliquer `Next`
3. **Paramètres de connexion** :
   - **Server Host** : `localhost`
   - **Port** : `POSTGRES_PORT`
   - **Database** : `POSTGRES_DB`
   - **Username** : `POSTGRES_USER`
   - **Password** : `POSTGRES_PASSWORD`

## Données d'exemple

Le fichier init.sql contient des données de démonstration :
- 2 utilisateurs test
- 1 administrateur
- 3 programmes d'entraînement
- 4 exercices
- 2 recettes
- 4 ingrédients