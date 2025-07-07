Projet : Système de Microservices pour la Gestion d'Événements
Ce projet est une implémentation complète d'un système basé sur une architecture de microservices, mettant en œuvre des communications synchrones (REST) et asynchrones (messaging avec RabbitMQ), une API Gateway, et des mécanismes de résilience pour garantir la robustesse du système.
Architecture du système
L'application est composée de quatre microservices principaux :

Service Événements (Java/Spring Boot) : Gère les opérations CRUD pour les événements.
Service Réservations (Node.js/Express) : Gère les réservations avec des interactions synchrones et asynchrones.
Service Notifications (Python/Flask) : Envoie des notifications basées sur des messages reçus.
API Gateway (Node.js/Express) : Fournit un point d'entrée unique pour les clients et route les requêtes vers les services appropriés.

Le système intègre également :

MongoDB comme base de données pour les services de réservations et de notifications.
RabbitMQ comme message broker pour la communication asynchrone.
React Frontend comme interface utilisateur pour interagir avec le système.

Structure du projet
Le script setup.sh fourni dans ce dépôt génère la structure suivante :
microservices-events/
  ├── event-service/               # Service Événements (Java/Spring Boot)
  ├── reservation-service/         # Service Réservations (Node.js/Express)
  ├── notification-service/        # Service Notifications (Python/Flask)
  ├── api-gateway/                 # API Gateway (Node.js/Express)
  ├── frontend/                    # Interface utilisateur (React)
  ├── docker-compose.yml           # Orchestration de tous les services
  └── README.md                    # Documentation du projet

Prérequis
Pour exécuter ce projet, vous aurez besoin de :

Docker et Docker Compose
JDK 17+ (pour le service Événements)
Node.js 18+ (pour les services en JavaScript)
Python 3.9+ (pour le service Notifications)

Démarrage rapide

Clonez ce dépôt :
git clone https://github.com/man2010/micro_lab2-starter.git
cd microservices-events


Rendez le script exécutable :
chmod +x setup.sh


Exécutez le script pour générer la structure du projet :
./setup.sh


Accédez au répertoire généré :
cd microservices-events


Lancez l'application complète avec Docker Compose :
docker-compose up -d


Accédez aux différents services :

Frontend : http://localhost:3001
API Gateway : http://localhost:8000
Service Événements : http://localhost:8080/api/events
Service Réservations : http://localhost:3000/api/reservations
Service Notifications : http://localhost:5000/api/notifications
Interface RabbitMQ : http://localhost:15672 (identifiants : guest/guest)



Fonctionnalités implémentées
Communication REST

Le service Événements expose des endpoints REST pour la gestion des événements (création, lecture, mise à jour, suppression, et réservation de places).
Le service Réservations communique avec le service Événements via des appels REST pour gérer les réservations.
L'API Gateway route les requêtes REST vers les services appropriés.

Communication asynchrone avec RabbitMQ

Le service Réservations publie des messages dans RabbitMQ lors de la création ou de l'annulation d'une réservation.
Le service Notifications consomme ces messages pour générer et envoyer des notifications aux utilisateurs.

API Gateway

L'API Gateway centralise toutes les requêtes client et redirige vers les services correspondants.
Les routes sont configurées pour les services Événements, Réservations, et Notifications.

Mécanismes de résilience

Un mécanisme de retry est implémenté pour gérer les échecs temporaires lors des appels REST entre services.
Un circuit breaker protège le système contre les défaillances en cascade, en particulier pour les interactions entre le service Réservations et le service Événements.

Documentation des API
Service Événements

GET /api/events : Récupère tous les événements.
GET /api/events/:id : Récupère un événement par son ID.
POST /api/events : Crée un nouvel événement.
PUT /api/events/:id : Met à jour un événement.
DELETE /api/events/:id : Supprime un événement.
POST /api/events/:id/book : Réserve des places pour un événement.

Service Réservations

GET /api/reservations : Récupère toutes les réservations.
GET /api/reservations/:id : Récupère une réservation par ID.
POST /api/reservations : Crée une nouvelle réservation.
PUT /api/reservations/:id/cancel : Annule une réservation.
GET /api/reservations/user/:userId : Récupère les réservations d'un utilisateur.

Service Notifications

GET /api/notifications : Récupère toutes les notifications.
GET /api/notifications/user/:userId : Récupère les notifications d'un utilisateur.
PUT /api/notifications/:id/read : Marque une notification comme lue.

Tests et validation
Pour tester l'application, suivez les étapes du démarrage rapide. Vous pouvez interagir avec le frontend à l'adresse http://localhost:3001 ou envoyer des requêtes directement à l'API Gateway (http://localhost:8000). Consultez la documentation Swagger générée dans chaque service pour plus de détails sur les endpoints.