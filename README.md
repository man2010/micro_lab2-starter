# Script de génération du TP2 - Communication entre microservices

Ce dépôt contient le script de génération pour le TP2 sur la communication entre microservices.

## Présentation

Le TP vise à faire comprendre et mettre en œuvre différentes stratégies de communication entre microservices :

- Communication synchrone (REST)
- Communication asynchrone (Messaging avec RabbitMQ)
- API Gateway
- Mécanismes de résilience

## Script d'initialisation

Le fichier `setup-microservices-tp.sh` est un script qui génère automatiquement tout le code de base nécessaire pour le TP, comprenant :

- Service d'événements (Java/Spring Boot)
- Service de réservations (Node.js/Express)
- Service de notifications (Python/Flask)
- API Gateway (Node.js/Express)
- Frontend React
- Configuration Docker Compose

## Comment utiliser ce script

1. Téléchargez le script `setup-microservices-tp.sh`
2. Rendez-le exécutable :
   ```bash
   chmod +x setup-microservices-tp.sh
   ```
3. Exécutez-le :
   ```bash
   ./setup-microservices-tp.sh
   ```
4. Accédez au répertoire créé :
   ```bash
   cd microservices-events
   ```

Le script crée une structure complète de projet avec tous les fichiers nécessaires et place des marqueurs TODO aux endroits où les étudiants doivent implémenter des fonctionnalités spécifiques.

## Structure générée

Le script génère la structure suivante :

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

## Exercices du TP

Les étudiants doivent compléter les parties marquées avec les TODOs suivants :

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

## Prérequis pour les étudiants

Pour compléter ce TP, les étudiants auront besoin de :

- Docker et Docker Compose
- JDK 17+ (pour le développement du service Événements)
- Node.js 18+ (pour le développement des services en JavaScript)
- Python 3.9+ (pour le développement du service Notifications)

## Support pédagogique

Un fichier PDF détaillé (`lab2.pdf`) contenant les instructions complètes, les explications théoriques et les checkpoints de validation est fourni séparément aux étudiants.
