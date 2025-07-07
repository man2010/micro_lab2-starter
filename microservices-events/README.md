# TP2: Communication entre microservices

Ce projet est une implémentation pratique des différentes stratégies de communication entre microservices, incluant des communications synchrones (REST) et asynchrones (messaging), ainsi que des mécanismes de résilience et une API Gateway.

## Architecture du système

L'application est composée de quatre microservices principaux :

1. **Service Événements** (Java/Spring Boot) : Gestion des événements (CRUD)
2. **Service Réservations** (Node.js/Express) : Gestion des réservations avec communication synchrone et asynchrone
3. **Service Notifications** (Python/Flask) : Envoi de notifications basé sur la réception de messages
4. **API Gateway** (Node.js/Express) : Centralisation des routes et point d'entrée unique pour le client

De plus, le système utilise :
- **MongoDB** comme base de données pour les services de réservations et de notifications
- **RabbitMQ** comme message broker pour la communication asynchrone
- **React Frontend** comme interface utilisateur pour interagir avec le système

## Structure du projet

```
microservices-events/
  ├── event-service/               # Service Événements (Java/Spring Boot)
  ├── reservation-service/         # Service Réservations (Node.js/Express)
  ├── notification-service/        # Service Notifications (Python/Flask)
  ├── api-gateway/                 # API Gateway (Node.js/Express)
  ├── frontend/                    # Interface utilisateur (React)
  ├── docker-compose.yml           # Orchestration de tous les services
  └── README.md                    # Documentation du projet
```

## Prérequis

Pour exécuter ce projet, vous aurez besoin de :

- Docker et Docker Compose
- JDK 17+ (pour le développement du service Événements)
- Node.js 18+ (pour le développement des services en JavaScript)
- Python 3.9+ (pour le développement du service Notifications)

## Démarrage rapide

1. Clonez ce dépôt :
```bash
git clone https://github.com/elbachir67/micro_lab2-starter.git
cd micro_lab2-starter
```

2. Lancez l'application complète avec Docker Compose :
```bash
docker-compose up -d
```

3. Accédez aux différents services :
   - Frontend: http://localhost:3001
   - API Gateway: http://localhost:8000
   - Service Événements: http://localhost:8080/api/events
   - Service Réservations: http://localhost:3000/api/reservations
   - Service Notifications: http://localhost:5000/api/notifications
   - Interface RabbitMQ: http://localhost:15672 (guest/guest)

## Exercices du TP

Ce projet contient plusieurs TODOs que vous devez implémenter pour compléter le TP :

### Partie 1: Communication REST
- `TODO-MS1`: Implémenter la méthode `bookSeats` dans `event-service/src/main/java/com/fst/dmi/eventservice/model/Event.java`
- `TODO-REST1`: Implémenter l'endpoint pour la réservation de places dans `event-service/src/main/java/com/fst/dmi/eventservice/controller/EventController.java`
- `TODO-REST2`: Implémenter la méthode `bookEventSeats` dans `reservation-service/src/services/event.service.js`

### Partie 2: Communication asynchrone avec RabbitMQ
- `TODO-MQ1`: Implémenter la fonction `publishMessage` dans `reservation-service/src/config/rabbitmq.config.js`
- `TODO-MQ2`: Implémenter l'envoi de message dans `reservation-service/src/services/reservation.service.js`
- `TODO-MQ3`: Implémenter le traitement des messages dans `notification-service/app.py`

### Partie 3: Configuration de l'API Gateway
- `TODO-GW1`: Configurer le proxy pour le service événements dans `api-gateway/src/app.js`
- `TODO-GW2`: Configurer le proxy pour le service réservations dans `api-gateway/src/app.js`
- `TODO-GW3`: Configurer le proxy pour le service notifications dans `api-gateway/src/app.js`

### Partie 4: Mécanismes de résilience
- `TODO-RESILIENCE1`: Implémenter la fonction de retry dans `reservation-service/src/utils/resilient-event-service.js`
- `TODO-RESILIENCE2`: Implémenter le circuit breaker dans `reservation-service/src/utils/circuit-breaker.js`
- `TODO-RESILIENCE3`: Implémenter la méthode avec circuit breaker dans `reservation-service/src/utils/event.service.with-circuit-breaker.js`

## Documentation des API

### Service Événements
- `GET /api/events` : Récupérer tous les événements
- `GET /api/events/:id` : Récupérer un événement par son ID
- `POST /api/events` : Créer un nouvel événement
- `PUT /api/events/:id` : Mettre à jour un événement
- `DELETE /api/events/:id` : Supprimer un événement
- `POST /api/events/:id/book` : Réserver des places pour un événement

### Service Réservations
- `GET /api/reservations` : Récupérer toutes les réservations
- `GET /api/reservations/:id` : Récupérer une réservation par ID
- `POST /api/reservations` : Créer une nouvelle réservation
- `PUT /api/reservations/:id/cancel` : Annuler une réservation
- `GET /api/reservations/user/:userId` : Récupérer les réservations d'un utilisateur

### Service Notifications
- `GET /api/notifications` : Récupérer toutes les notifications
- `GET /api/notifications/user/:userId` : Récupérer les notifications d'un utilisateur
- `PUT /api/notifications/:id/read` : Marquer une notification comme lue

## Tests et validation

Consultez le fichier `lab2.pdf` pour obtenir des instructions détaillées sur la façon de tester chaque partie du TP et de valider votre implémentation.
