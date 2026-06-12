db = db.getSiblingDB('healthai_social');

db.createCollection('social_posts');
db.createCollection('user_profiles');

db.social_posts.createIndex({ authorUserId: 1 });
db.social_posts.createIndex({ createdAt: -1 });
db.user_profiles.createIndex({ userId: 1 }, { unique: true });
