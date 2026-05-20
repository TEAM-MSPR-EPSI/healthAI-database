// Script d'initialisation Mongo execute au premier demarrage du conteneur.
// Il cree la base, la collection principale et les index utiles pour le fil social.

db = db.getSiblingDB('healthai_social');

db.createCollection('social_posts');

db.social_posts.createIndex({ authorUserId: 1 });
db.social_posts.createIndex({ createdAt: -1 });

db.social_posts.insertMany([
  {
    authorUserId: 1,
    authorName: 'HealthAI',
    authorHandle: '@healthai',
    content: 'Bienvenue sur le fil social HealthAI.',
    mediaUrl: null,
    mediaType: null,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    authorUserId: 1,
    authorName: 'HealthAI',
    authorHandle: '@healthai',
    content: 'Tu peux partager du texte, une photo ou une video.',
    mediaUrl: null,
    mediaType: null,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
]);
