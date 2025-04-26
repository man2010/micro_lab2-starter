#!/bin/bash

# Script d'initialisation pour le TP2: Communication entre microservices
# Ce script crée l'arborescence complète du projet et tous les fichiers nécessaires
# Inclut une implémentation simple du frontend React

echo "🚀 Initialisation du projet TP2: Communication entre microservices"

# Création des répertoires principaux
mkdir -p microservices-events
cd microservices-events

echo "📁 Création de la structure des répertoires..."

# Service Événements (Java/Spring Boot)
mkdir -p event-service/src/main/java/com/fst/dmi/eventservice/{controller,model,repository,service}
mkdir -p event-service/src/main/resources

# Service Réservations (Node.js/Express)
mkdir -p reservation-service/src/{config,controllers,models,routes,services,utils}

# Service Notifications (Python/Flask)
mkdir -p notification-service

# API Gateway (Node.js/Express)
mkdir -p api-gateway/src

# Frontend (React)
mkdir -p frontend/{public,src/{components,services,pages,context}}

echo "📝 Création des fichiers du service Événements..."

# Fichiers du service Événements
cat > event-service/src/main/java/com/fst/dmi/eventservice/model/Event.java << 'EOF'
package com.fst.dmi.eventservice.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "events")
public class Event {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;
    
    @Column(nullable = false)
    private String description;
    
    @Column(nullable = false)
    private LocalDateTime date;
    
    @Column(nullable = false)
    private String location;
    
    @Column(nullable = false)
    private int totalCapacity;
    
    @Column(nullable = false)
    private int bookedSeats;
    
    // Constructeurs
    public Event() {
    }
    
    public Event(String name, String description, LocalDateTime date, String location, int totalCapacity) {
        this.name = name;
        this.description = description;
        this.date = date;
        this.location = location;
        this.totalCapacity = totalCapacity;
        this.bookedSeats = 0;
    }
    
    // Getters et setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalDateTime getDate() {
        return date;
    }

    public void setDate(LocalDateTime date) {
        this.date = date;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public int getTotalCapacity() {
        return totalCapacity;
    }

    public void setTotalCapacity(int totalCapacity) {
        this.totalCapacity = totalCapacity;
    }

    public int getBookedSeats() {
        return bookedSeats;
    }

    public void setBookedSeats(int bookedSeats) {
        this.bookedSeats = bookedSeats;
    }
    
    // Méthodes utilitaires importantes pour la réservation
    public int getAvailableSeats() {
        return totalCapacity - bookedSeats;
    }

    public boolean hasAvailableSeats(int requestedSeats) {
        return getAvailableSeats() >= requestedSeats;
    }

    // TODO-MS1: Implémentez la méthode bookSeats pour réserver des places si disponibles
    // Cette méthode doit vérifier si le nombre de places demandées est disponible
    // Si oui, elle incrémente bookedSeats et retourne true, sinon retourne false
    public boolean bookSeats(int seats) {
        // À implémenter
        return false; // Placeholder à remplacer par votre implémentation
    }
}
EOF

cat > event-service/src/main/java/com/fst/dmi/eventservice/controller/EventController.java << 'EOF'
package com.fst.dmi.eventservice.controller;

import com.fst.dmi.eventservice.model.Event;
import com.fst.dmi.eventservice.service.EventService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/events")
@CrossOrigin(origins = "*")
public class EventController {

    private final EventService eventService;

    @Autowired
    public EventController(EventService eventService) {
        this.eventService = eventService;
    }

    // Récupérer tous les événements
    @GetMapping
    public ResponseEntity<List<Event>> getAllEvents() {
        List<Event> events = eventService.getAllEvents();
        return ResponseEntity.ok(events);
    }

    // Récupérer un événement par son ID
    @GetMapping("/{id}")
    public ResponseEntity<?> getEventById(@PathVariable Long id) {
        Optional<Event> eventOpt = eventService.getEventById(id);
        if (eventOpt.isPresent()) {
            return ResponseEntity.ok(eventOpt.get());
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("error", "Event not found with ID: " + id));
        }
    }

    // Créer un nouvel événement
    @PostMapping
    public ResponseEntity<Event> createEvent(@RequestBody Event event) {
        Event savedEvent = eventService.saveEvent(event);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedEvent);
    }

    // Mettre à jour un événement existant
    @PutMapping("/{id}")
    public ResponseEntity<?> updateEvent(@PathVariable Long id, @RequestBody Event eventDetails) {
        Optional<Event> updatedEventOpt = eventService.updateEvent(id, eventDetails);
        if (updatedEventOpt.isPresent()) {
            return ResponseEntity.ok(updatedEventOpt.get());
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("error", "Event not found with ID: " + id));
        }
    }

    // Supprimer un événement
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteEvent(@PathVariable Long id) {
        boolean deleted = eventService.deleteEvent(id);
        if (deleted) {
            return ResponseEntity.ok(Map.of("message", "Event successfully deleted"));
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("error", "Event not found with ID: " + id));
        }
    }

    // TODO-REST1: Implémentez l'endpoint pour la réservation de places
    // Cet endpoint doit recevoir une requête POST avec le nombre de places à réserver
    // Il doit appeler eventService.bookEventSeats et retourner une réponse appropriée
    @PostMapping("/{id}/book")
    public ResponseEntity<?> bookEventSeats(@PathVariable Long id, @RequestBody Map<String, Integer> bookingRequest) {
        // À implémenter
        return null; // Placeholder à remplacer par votre implémentation
    }
}
EOF

cat > event-service/src/main/java/com/fst/dmi/eventservice/service/EventService.java << 'EOF'
package com.fst.dmi.eventservice.service;

import com.fst.dmi.eventservice.model.Event;
import com.fst.dmi.eventservice.repository.EventRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class EventService {

    private final EventRepository eventRepository;

    @Autowired
    public EventService(EventRepository eventRepository) {
        this.eventRepository = eventRepository;
    }

    public List<Event> getAllEvents() {
        return eventRepository.findAll();
    }

    public Optional<Event> getEventById(Long id) {
        return eventRepository.findById(id);
    }

    public Event saveEvent(Event event) {
        return eventRepository.save(event);
    }

    @Transactional
    public Optional<Event> updateEvent(Long id, Event eventDetails) {
        Optional<Event> eventOpt = eventRepository.findById(id);
        
        if (eventOpt.isPresent()) {
            Event existingEvent = eventOpt.get();
            existingEvent.setName(eventDetails.getName());
            existingEvent.setDescription(eventDetails.getDescription());
            existingEvent.setDate(eventDetails.getDate());
            existingEvent.setLocation(eventDetails.getLocation());
            existingEvent.setTotalCapacity(eventDetails.getTotalCapacity());
            // Ne pas mettre à jour bookedSeats directement pour éviter d'écraser les réservations existantes
            
            return Optional.of(eventRepository.save(existingEvent));
        }
        
        return Optional.empty();
    }

    public boolean deleteEvent(Long id) {
        if (eventRepository.existsById(id)) {
            eventRepository.deleteById(id);
            return true;
        }
        return false;
    }

    @Transactional
    public boolean bookEventSeats(Long eventId, int seats) {
        Optional<Event> eventOpt = eventRepository.findById(eventId);
        
        if (eventOpt.isPresent()) {
            Event event = eventOpt.get();
            if (event.bookSeats(seats)) {
                eventRepository.save(event);
                return true;
            }
        }
        
        return false;
    }
}
EOF

cat > event-service/src/main/java/com/fst/dmi/eventservice/repository/EventRepository.java << 'EOF'
package com.fst.dmi.eventservice.repository;

import com.fst.dmi.eventservice.model.Event;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface EventRepository extends JpaRepository<Event, Long> {
    // Méthodes additionnelles si nécessaire
}
EOF

cat > event-service/src/main/java/com/fst/dmi/eventservice/EventServiceApplication.java << 'EOF'
package com.fst.dmi.eventservice;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class EventServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(EventServiceApplication.class, args);
    }
}
EOF

cat > event-service/src/main/resources/application.properties << 'EOF'
# Configuration H2 Database
spring.datasource.url=jdbc:h2:mem:eventdb
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=password
spring.jpa.database-platform=org.hibernate.dialect.H2Dialect

# Console H2 (pour le développement uniquement)
spring.h2.console.enabled=true
spring.h2.console.path=/h2-console

# Hibernate configuration
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true

# Server configuration
server.port=8080
EOF

cat > event-service/build.gradle << 'EOF'
plugins {
    id 'org.springframework.boot' version '3.2.0'
    id 'io.spring.dependency-management' version '1.1.4'
    id 'java'
}

group = 'com.fst.dmi'
version = '0.0.1-SNAPSHOT'
sourceCompatibility = '17'

repositories {
    mavenCentral()
}

dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-data-jpa'
    implementation 'org.springframework.boot:spring-boot-starter-web'
    implementation 'org.springframework.boot:spring-boot-starter-validation'
    runtimeOnly 'com.h2database:h2'
    testImplementation 'org.springframework.boot:spring-boot-starter-test'
}

test {
    useJUnitPlatform()
}
EOF

cat > event-service/Dockerfile << 'EOF'
FROM gradle:7.6.1-jdk17 as build
WORKDIR /app
COPY . .
RUN gradle build --no-daemon -x test

FROM openjdk:17-slim
WORKDIR /app
COPY --from=build /app/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
EOF

echo "📝 Création des fichiers du service Réservations..."

# Fichiers du service Réservations
cat > reservation-service/src/services/event.service.js << 'EOF'
const axios = require('axios');

const EVENT_SERVICE_URL = process.env.NODE_ENV === 'production' 
  ? 'http://event-service:8080/api/events'
  : 'http://localhost:8080/api/events';

// Get all events
const getAllEvents = async () => {
  try {
    const response = await axios.get(`${EVENT_SERVICE_URL}`);
    return response.data;
  } catch (error) {
    console.error('Error fetching events:', error.message);
    throw new Error('Failed to fetch events');
  }
};

// Get an event by ID
const getEventById = async (eventId) => {
  try {
    const response = await axios.get(`${EVENT_SERVICE_URL}/${eventId}`);
    return response.data;
  } catch (error) {
    console.error(`Error fetching event with ID ${eventId}:`, error.message);
    if (error.response && error.response.status === 404) {
      throw new Error(`Event with ID ${eventId} not found`);
    }
    throw new Error('Failed to fetch event');
  }
};

// TODO-REST2: Implémentez la méthode bookEventSeats pour effectuer un appel REST
// Cette méthode doit envoyer une requête POST au service Événements pour réserver des places
// Elle doit gérer les erreurs appropriées et retourner la réponse du service Événements
const bookEventSeats = async (eventId, seats) => {
  try {
    // À implémenter
    
  } catch (error) {
    console.error(`Error booking seats for event ${eventId}:`, error.message);
    if (error.response) {
      throw new Error(error.response.data.error || 'Failed to book seats');
    }
    throw new Error('Failed to book seats');
  }
};

module.exports = {
  getAllEvents,
  getEventById,
  bookEventSeats
};
EOF

cat > reservation-service/src/config/rabbitmq.config.js << 'EOF'
const amqp = require('amqplib');

const RABBITMQ_URL = process.env.NODE_ENV === 'production'
  ? 'amqp://guest:guest@rabbitmq:5672'
  : 'amqp://guest:guest@localhost:5672';

const EXCHANGE_NAME = 'events_exchange';
const QUEUE_NAME = 'reservation_events';
const ROUTING_KEY = 'reservation.created';

let channel = null;

// Connect to RabbitMQ and create a channel
const connect = async () => {
  try {
    const connection = await amqp.connect(RABBITMQ_URL);
    
    // Create a channel
    const ch = await connection.createChannel();
    
    // Declare an exchange
    await ch.assertExchange(EXCHANGE_NAME, 'topic', { durable: true });
    
    // Declare a queue
    await ch.assertQueue(QUEUE_NAME, { durable: true });
    
    // Bind the queue to the exchange with routing key
    await ch.bindQueue(QUEUE_NAME, EXCHANGE_NAME, 'reservation.*');
    
    channel = ch;
    console.log('Connected to RabbitMQ');
    
    // Handle connection closure
    connection.on('close', () => {
      console.log('RabbitMQ connection closed, attempting to reconnect...');
      setTimeout(connect, 5000);
    });
    
    return ch;
  } catch (error) {
    console.error('Error connecting to RabbitMQ:', error.message);
    console.log('Retrying connection in 5 seconds...');
    setTimeout(connect, 5000);
  }
};

// Initialize the connection
connect();

// TODO-MQ1: Implémentez la fonction pour publier un message à l'exchange
// Cette fonction doit vérifier si le canal est disponible, reconnecter si nécessaire,
// puis publier le message à l'exchange avec la routing key fournie
const publishMessage = async (routingKey, message) => {
  try {
    if (!channel) {
      console.log('Channel not available, reconnecting...');
      await connect();
    }
    
    // À implémenter
    
    return true;
  } catch (error) {
    console.error('Error publishing message to RabbitMQ:', error.message);
    return false;
  }
};

module.exports = {
  connect,
  publishMessage,
  EXCHANGE_NAME,
  QUEUE_NAME,
  ROUTING_KEY
};
EOF

cat > reservation-service/src/models/reservation.model.js << 'EOF'
const mongoose = require('mongoose');

const reservationSchema = new mongoose.Schema({
  eventId: {
    type: Number,
    required: true
  },
  userId: {
    type: String,
    required: true
  },
  userName: {
    type: String,
    required: true
  },
  userEmail: {
    type: String,
    required: true
  },
  seats: {
    type: Number,
    required: true,
    min: 1
  },
  status: {
    type: String,
    enum: ['confirmed', 'pending', 'cancelled'],
    default: 'confirmed'
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

const Reservation = mongoose.model('Reservation', reservationSchema);

module.exports = Reservation;
EOF

cat > reservation-service/src/services/reservation.service.js << 'EOF'
const Reservation = require('../models/reservation.model');
const eventService = require('./event.service');
const rabbitmq = require('../config/rabbitmq.config');

// Create a new reservation with REST communication and messaging
const createReservation = async (reservationData) => {
  try {
    // First check if the event exists and has enough capacity via REST
    const event = await eventService.getEventById(reservationData.eventId);
    
    // Book the seats in the event service via REST
    const bookingResponse = await eventService.bookEventSeats(
      reservationData.eventId, 
      reservationData.seats
    );
    
    // If we successfully booked the seats, create the reservation
    const reservation = new Reservation({
      eventId: reservationData.eventId,
      userId: reservationData.userId,
      userName: reservationData.userName,
      userEmail: reservationData.userEmail,
      seats: reservationData.seats
    });
    
    // Save the reservation
    await reservation.save();
    
    // TODO-MQ2: Envoyez un message à RabbitMQ concernant la nouvelle réservation
    // Utilisez rabbitmq.publishMessage avec la ROUTING_KEY et les données de la réservation
    // À implémenter
    
    return {
      reservation,
      message: 'Reservation created successfully'
    };
  } catch (error) {
    throw new Error(error.message || 'Failed to create reservation');
  }
};

// Get all reservations
const getAllReservations = async () => {
  try {
    const reservations = await Reservation.find().sort({ createdAt: -1 });
    return reservations;
  } catch (error) {
    throw new Error('Failed to fetch reservations');
  }
};

// Get reservations by user ID
const getReservationsByUserId = async (userId) => {
  try {
    const reservations = await Reservation.find({ userId }).sort({ createdAt: -1 });
    return reservations;
  } catch (error) {
    throw new Error(`Failed to fetch reservations for user ${userId}`);
  }
};

// Get a reservation by ID
const getReservationById = async (id) => {
  try {
    const reservation = await Reservation.findById(id);
    if (!reservation) {
      throw new Error(`Reservation with ID ${id} not found`);
    }
    return reservation;
  } catch (error) {
    throw new Error(error.message || `Failed to fetch reservation with ID ${id}`);
  }
};

// Cancel a reservation
const cancelReservation = async (id) => {
  try {
    const reservation = await Reservation.findById(id);
    if (!reservation) {
      throw new Error(`Reservation with ID ${id} not found`);
    }
    
    reservation.status = 'cancelled';
    await reservation.save();
    
    // Here we could also implement logic to free up seats in the event service
    
    return {
      reservation,
      message: 'Reservation cancelled successfully'
    };
  } catch (error) {
    throw new Error(error.message || `Failed to cancel reservation with ID ${id}`);
  }
};

module.exports = {
  createReservation,
  getAllReservations,
  getReservationsByUserId,
  getReservationById,
  cancelReservation
};
EOF

cat > reservation-service/src/controllers/reservation.controller.js << 'EOF'
const reservationService = require('../services/reservation.service');
const eventService = require('../services/event.service');

// Create a new reservation
const createReservation = async (req, res) => {
  try {
    const result = await reservationService.createReservation(req.body);
    res.status(201).json(result);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Get all reservations
const getAllReservations = async (req, res) => {
  try {
    const reservations = await reservationService.getAllReservations();
    res.status(200).json(reservations);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get reservations by user ID
const getReservationsByUserId = async (req, res) => {
  try {
    const reservations = await reservationService.getReservationsByUserId(req.params.userId);
    res.status(200).json(reservations);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get a reservation by ID
const getReservationById = async (req, res) => {
  try {
    const reservation = await reservationService.getReservationById(req.params.id);
    res.status(200).json(reservation);
  } catch (error) {
    if (error.message.includes('not found')) {
      res.status(404).json({ error: error.message });
    } else {
      res.status(500).json({ error: error.message });
    }
  }
};

// Cancel a reservation
const cancelReservation = async (req, res) => {
  try {
    const result = await reservationService.cancelReservation(req.params.id);
    res.status(200).json(result);
  } catch (error) {
    if (error.message.includes('not found')) {
      res.status(404).json({ error: error.message });
    } else {
      res.status(500).json({ error: error.message });
    }
  }
};

// Proxy to events service (for convenience)
const getAllEvents = async (req, res) => {
  try {
    const events = await eventService.getAllEvents();
    res.status(200).json(events);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Proxy to events service (for convenience)
const getEventById = async (req, res) => {
  try {
    const event = await eventService.getEventById(req.params.id);
    res.status(200).json(event);
  } catch (error) {
    if (error.message.includes('not found')) {
      res.status(404).json({ error: error.message });
    } else {
      res.status(500).json({ error: error.message });
    }
  }
};

module.exports = {
  createReservation,
  getAllReservations,
  getReservationsByUserId,
  getReservationById,
  cancelReservation,
  getAllEvents,
  getEventById
};
EOF

cat > reservation-service/src/routes/reservation.routes.js << 'EOF'
const express = require('express');
const router = express.Router();
const reservationController = require('../controllers/reservation.controller');

// Réservation routes
router.post('/', reservationController.createReservation);
router.get('/', reservationController.getAllReservations);
router.get('/user/:userId', reservationController.getReservationsByUserId);
router.get('/:id', reservationController.getReservationById);
router.put('/:id/cancel', reservationController.cancelReservation);

module.exports = router;
EOF

cat > reservation-service/src/routes/event.routes.js << 'EOF'
const express = require('express');
const router = express.Router();
const reservationController = require('../controllers/reservation.controller');

// Ces routes sont des proxies vers le service d'événements
router.get('/', reservationController.getAllEvents);
router.get('/:id', reservationController.getEventById);

module.exports = router;
EOF

cat > reservation-service/src/app.js << 'EOF'
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const morgan = require('morgan');

const reservationRoutes = require('./routes/reservation.routes');
const eventRoutes = require('./routes/event.routes');

// Initialiser l'application Express
const app = express();
const PORT = process.env.PORT || 3000;
const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/reservations';

// Middleware
app.use(cors());
app.use(express.json());
app.use(morgan('dev'));

// Connexion à MongoDB
mongoose.connect(MONGODB_URI)
  .then(() => console.log('Connected to MongoDB'))
  .catch(err => console.error('Failed to connect to MongoDB:', err));

// Routes
app.use('/api/reservations', reservationRoutes);
app.use('/api/events', eventRoutes);

// Route de base
app.get('/', (req, res) => {
  res.json({
    message: 'Reservation Service API',
    endpoints: {
      reservations: '/api/reservations',
      events: '/api/events'
    }
  });
});

// Middleware d'erreur
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    error: 'Internal Server Error',
    message: err.message
  });
});

// Démarrer le serveur
app.listen(PORT, () => {
  console.log(`Reservation Service running on port ${PORT}`);
});

module.exports = app;
EOF

cat > reservation-service/src/utils/circuit-breaker.js << 'EOF'
class CircuitBreaker {
  constructor(options = {}) {
    this.failureThreshold = options.failureThreshold || 3;
    this.resetTimeout = options.resetTimeout || 30000; // 30 seconds
    this.failureCount = 0;
    this.isOpen = false;
    this.lastFailureTime = null;
  }

  // TODO-RESILIENCE2: Implémentez la méthode execute du circuit breaker
  // Cette méthode doit vérifier l'état du circuit avant d'exécuter la fonction
  // Si le circuit est ouvert, elle doit vérifier si le temps de reset est écoulé
  // Elle doit exécuter la fonction si le circuit est fermé ou semi-ouvert
  // Elle doit mettre à jour l'état du circuit en fonction du résultat
  async execute(fn) {
    // À implémenter
  }

  onSuccess() {
    this.failureCount = 0;
    this.isOpen = false;
  }

  onFailure() {
    this.failureCount += 1;
    this.lastFailureTime = Date.now();
    
    if (this.failureCount >= this.failureThreshold) {
      this.isOpen = true;
      console.log(`Circuit opened after ${this.failureCount} failures`);
    }
  }
}

module.exports = CircuitBreaker;
EOF

cat > reservation-service/src/utils/resilient-event-service.js << 'EOF'
const axios = require('axios');

const EVENT_SERVICE_URL = process.env.NODE_ENV === 'production' 
  ? 'http://event-service:8080/api/events'
  : 'http://localhost:8080/api/events';

// Configure axios with timeouts
const apiClient = axios.create({
  timeout: 3000  // 3 seconds timeout
});

// TODO-RESILIENCE1: Implémentez la fonction retryRequest pour réessayer les appels en cas d'échec
// Cette fonction doit prendre en charge une fonction à exécuter, le nombre de tentatives,
// le délai initial et un facteur de backoff exponentiel
const retryRequest = async (fn, retries = 3, delay = 1000, backoff = 2) => {
  // À implémenter
};

// Get all events with retry
const getAllEvents = async () => {
  try {
    return await retryRequest(async () => {
      const response = await apiClient.get(`${EVENT_SERVICE_URL}`);
      return response.data;
    });
  } catch (error) {
    console.error('Error fetching events:', error.message);
    throw new Error('Failed to fetch events');
  }
};

// Get an event by ID with retry
const getEventById = async (eventId) => {
  try {
    return await retryRequest(async () => {
      const response = await apiClient.get(`${EVENT_SERVICE_URL}/${eventId}`);
      return response.data;
    });
  } catch (error) {
    console.error(`Error fetching event with ID ${eventId}:`, error.message);
    if (error.response && error.response.status === 404) {
      throw new Error(`Event with ID ${eventId} not found`);
    }
    throw new Error('Failed to fetch event');
  }
};

// Book seats for an event with retry
const bookEventSeats = async (eventId, seats) => {
  try {
    return await retryRequest(async () => {
      const response = await apiClient.post(`${EVENT_SERVICE_URL}/${eventId}/book`, {
        seats: seats
      });
      return response.data;
    });
  } catch (error) {
    console.error(`Error booking seats for event ${eventId}:`, error.message);
    if (error.response) {
      throw new Error(error.response.data.error || 'Failed to book seats');
    }
    throw new Error('Failed to book seats');
  }
};

module.exports = {
  getAllEvents,
  getEventById,
  bookEventSeats,
  retryRequest
};
EOF

cat > reservation-service/src/utils/event.service.with-circuit-breaker.js << 'EOF'
const CircuitBreaker = require('./circuit-breaker');
const axios = require('axios');

const EVENT_SERVICE_URL = process.env.NODE_ENV === 'production' 
  ? 'http://event-service:8080/api/events'
  : 'http://localhost:8080/api/events';

// Configure axios with timeouts
const apiClient = axios.create({
  timeout: 3000  // 3 seconds timeout
});

// Create circuit breakers for different operations
const getEventsCircuitBreaker = new CircuitBreaker();
const getEventByIdCircuitBreaker = new CircuitBreaker();
const bookSeatsCircuitBreaker = new CircuitBreaker();

// Get all events with circuit breaker
const getAllEvents = async () => {
  try {
    return await getEventsCircuitBreaker.execute(async () => {
      const response = await apiClient.get(`${EVENT_SERVICE_URL}`);
      return response.data;
    });
  } catch (error) {
    console.error('Error fetching events:', error.message);
    if (error.message === 'Circuit is open, request rejected') {
      throw new Error('Events service is currently unavailable');
    }
    throw new Error('Failed to fetch events');
  }
};

// TODO-RESILIENCE3: Implémentez la méthode getEventById avec circuit breaker
// Cette méthode doit utiliser le circuit breaker pour protéger les appels au service d'événements
// Elle doit gérer les erreurs spécifiques au circuit breaker et les erreurs de l'API
const getEventById = async (eventId) => {
  // À implémenter
};

// Book seats for an event with circuit breaker
const bookEventSeats = async (eventId, seats) => {
  try {
    return await bookSeatsCircuitBreaker.execute(async () => {
      const response = await apiClient.post(`${EVENT_SERVICE_URL}/${eventId}/book`, {
        seats: seats
      });
      return response.data;
    });
  } catch (error) {
    console.error(`Error booking seats for event ${eventId}:`, error.message);
    if (error.message === 'Circuit is open, request rejected') {
      throw new Error('Event booking service is currently unavailable');
    }
    if (error.response) {
      throw new Error(error.response.data.error || 'Failed to book seats');
    }
    throw new Error('Failed to book seats');
  }
};

module.exports = {
  getAllEvents,
  getEventById,
  bookEventSeats
};
EOF

cat > reservation-service/package.json << 'EOF'
{
  "name": "reservation-service",
  "version": "1.0.0",
  "description": "Microservice pour la gestion des réservations",
  "main": "src/app.js",
  "scripts": {
    "start": "node src/app.js",
    "dev": "nodemon src/app.js",
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "dependencies": {
    "amqplib": "^0.10.3",
    "axios": "^1.5.0",
    "cors": "^2.8.5",
    "express": "^4.18.2",
    "mongoose": "^7.5.0",
    "morgan": "^1.10.0"
  },
  "devDependencies": {
    "nodemon": "^3.0.1"
  }
}
EOF

cat > reservation-service/Dockerfile << 'EOF'
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install --production

COPY src ./src

EXPOSE 3000

CMD ["npm", "start"]
EOF

echo "📝 Création des fichiers du service Notifications..."

# Fichiers du service Notifications
cat > notification-service/app.py << 'EOF'
from flask import Flask, jsonify, request
import pika
import json
import threading
import time
import os
from pymongo import MongoClient

app = Flask(__name__)

# MongoDB connection
client = MongoClient('mongodb://mongodb:27017/' if os.environ.get('FLASK_ENV') == 'production' else 'mongodb://localhost:27017/')
db = client.notification_db
notifications = db.notifications

# RabbitMQ Configuration
RABBITMQ_HOST = 'rabbitmq' if os.environ.get('FLASK_ENV') == 'production' else 'localhost'
RABBITMQ_QUEUE = 'reservation_events'

def connect_to_rabbitmq():
    """Create a connection to RabbitMQ"""
    try:
        connection = pika.BlockingConnection(pika.ConnectionParameters(host=RABBITMQ_HOST))
        channel = connection.channel()
        channel.queue_declare(queue=RABBITMQ_QUEUE, durable=True)
        print("Connected to RabbitMQ")
        return connection, channel
    except Exception as e:
        print(f"Error connecting to RabbitMQ: {e}")
        return None, None

def process_message(ch, method, properties, body):
    """Process a message from RabbitMQ"""
    try:
        # Parse the message
        message = json.loads(body)
        print(f"Received message: {message}")
        
        # TODO-MQ3: Traitez le message reçu et créez une notification
        # Extrayez les informations nécessaires du message (email, nom, événement, places)
        # Créez un document notification avec ces informations
        # Sauvegardez la notification dans MongoDB
        # À implémenter
        
        # Acknowledge the message
        ch.basic_ack(delivery_tag=method.delivery_tag)
    except Exception as e:
        print(f"Error processing message: {e}")
        # In case of error, requeue the message
        ch.basic_nack(delivery_tag=method.delivery_tag, requeue=True)

def start_consumer():
    """Start consuming messages from RabbitMQ"""
    def consumer_thread():
        while True:
            try:
                connection, channel = connect_to_rabbitmq()
                if channel:
                    # Set up the consumer
                    channel.basic_qos(prefetch_count=1)
                    channel.basic_consume(queue=RABBITMQ_QUEUE, on_message_callback=process_message)
                    
                    print("Starting to consume messages")
                    channel.start_consuming()
            except Exception as e:
                print(f"Consumer error: {e}")
                
            print("Consumer disconnected. Retrying in 5 seconds...")
            time.sleep(5)
    
    # Start the consumer in a separate thread
    thread = threading.Thread(target=consumer_thread)
    thread.daemon = True
    thread.start()
    print("Consumer thread started")

# Routes pour API
@app.route('/api/notifications', methods=['GET'])
def get_notifications():
    """Get all notifications"""
    try:
        result = list(notifications.find({}, {'_id': False}))
        return jsonify(result)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/notifications/user/<user_id>', methods=['GET'])
def get_user_notifications(user_id):
    """Get notifications for a specific user"""
    try:
        result = list(notifications.find({'userId': user_id}, {'_id': False}))
        return jsonify(result)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/notifications/<notification_id>/read', methods=['PUT'])
def mark_notification_read(notification_id):
    """Mark a notification as read"""
    try:
        notifications.update_one({'notificationId': notification_id}, {'$set': {'read': True}})
        return jsonify({'message': 'Notification marked as read'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/')
def index():
    """Home route"""
    return jsonify({
        'message': 'Notification Service API',
        'endpoints': {
            'notifications': '/api/notifications',
            'user_notifications': '/api/notifications/user/{user_id}',
            'mark_read': '/api/notifications/{notification_id}/read'
        }
    })

# Start the consumer when the app starts
start_consumer()

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=os.environ.get('FLASK_ENV') != 'production')
EOF

cat > notification-service/requirements.txt << 'EOF'
Flask==2.3.3
pika==1.3.2
pymongo==4.5.0
EOF

cat > notification-service/Dockerfile << 'EOF'
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 5000

CMD ["python", "app.py"]
EOF

echo "📝 Création des fichiers de l'API Gateway..."

# Fichiers de l'API Gateway
cat > api-gateway/src/app.js << 'EOF'
const express = require('express');
const morgan = require('morgan');
const cors = require('cors');
const { createProxyMiddleware } = require('http-proxy-middleware');

const app = express();
const PORT = process.env.PORT || 8000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(morgan('dev'));

// Service endpoints (for production environment)
const EVENTS_SERVICE = process.env.NODE_ENV === 'production' 
  ? 'http://event-service:8080' 
  : 'http://localhost:8080';

const RESERVATIONS_SERVICE = process.env.NODE_ENV === 'production' 
  ? 'http://reservation-service:3000' 
  : 'http://localhost:3000';

const NOTIFICATIONS_SERVICE = process.env.NODE_ENV === 'production' 
  ? 'http://notification-service:5000' 
  : 'http://localhost:5000';

// Welcome route
app.get('/', (req, res) => {
  res.json({
    message: 'Welcome to the Event Booking API Gateway',
    services: {
      events: '/api/events',
      reservations: '/api/reservations',
      notifications: '/api/notifications'
    }
  });
});

// TODO-GW1: Créez le middleware de proxy pour le service événements
// Utilisez createProxyMiddleware pour router les requêtes vers le service événements
// À implémenter

// TODO-GW2: Créez le middleware de proxy pour le service réservations
// Utilisez createProxyMiddleware pour router les requêtes vers le service réservations
// À implémenter

// TODO-GW3: Créez le middleware de proxy pour le service notifications
// Utilisez createProxyMiddleware pour router les requêtes vers le service notifications
// À implémenter

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    error: 'Internal Server Error',
    message: err.message
  });
});

// Start the server
app.listen(PORT, () => {
  console.log(`API Gateway running on port ${PORT}`);
});

module.exports = app;
EOF

cat > api-gateway/package.json << 'EOF'
{
  "name": "api-gateway",
  "version": "1.0.0",
  "description": "API Gateway pour le système de réservation d'événements",
  "main": "src/app.js",
  "scripts": {
    "start": "node src/app.js",
    "dev": "nodemon src/app.js",
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "dependencies": {
    "cors": "^2.8.5",
    "express": "^4.18.2",
    "http-proxy-middleware": "^2.0.6",
    "morgan": "^1.10.0"
  },
  "devDependencies": {
    "nodemon": "^3.0.1"
  }
}
EOF

cat > api-gateway/Dockerfile << 'EOF'
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install --production

COPY src ./src

EXPOSE 8000

CMD ["npm", "start"]
EOF

echo "📝 Création des fichiers du Frontend (React)..."

# Fichiers du Frontend
cat > frontend/public/index.html << 'EOF'
<!DOCTYPE html>
<html lang="fr">
  <head>
    <meta charset="utf-8" />
    <link rel="icon" href="%PUBLIC_URL%/favicon.ico" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="theme-color" content="#000000" />
    <meta
      name="description"
      content="Application de réservation d'événements - TP Microservices"
    />
    <link rel="apple-touch-icon" href="%PUBLIC_URL%/logo192.png" />
    <link rel="manifest" href="%PUBLIC_URL%/manifest.json" />
    <title>Réservation d'Événements</title>
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM"
      crossorigin="anonymous"
    />
  </head>
  <body>
    <noscript>Vous devez activer JavaScript pour exécuter cette application.</noscript>
    <div id="root"></div>
  </body>
</html>
EOF

cat > frontend/public/manifest.json << 'EOF'
{
  "short_name": "Reservations",
  "name": "Reservation d'Événements",
  "icons": [
    {
      "src": "favicon.ico",
      "sizes": "64x64 32x32 24x24 16x16",
      "type": "image/x-icon"
    }
  ],
  "start_url": ".",
  "display": "standalone",
  "theme_color": "#000000",
  "background_color": "#ffffff"
}
EOF

cat > frontend/src/index.js << 'EOF'
import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import App from './App';
import { BrowserRouter } from 'react-router-dom';

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <BrowserRouter>
      <App />
    </BrowserRouter>
  </React.StrictMode>
);
EOF

cat > frontend/src/index.css << 'EOF'
body {
  margin: 0;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen',
    'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue',
    sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

code {
  font-family: source-code-pro, Menlo, Monaco, Consolas, 'Courier New',
    monospace;
}

.notification {
  padding: 10px;
  margin-bottom: 10px;
  border-radius: 4px;
  background-color: #f8f9fa;
  border-left: 4px solid #007bff;
}

.notification-unread {
  background-color: #cfe2ff;
}

.event-card {
  transition: transform 0.3s;
}

.event-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 20px rgba(0,0,0,0.1);
}
EOF

cat > frontend/src/App.js << 'EOF'
import React, { useState, useEffect } from 'react';
import { Routes, Route, Link } from 'react-router-dom';
import { Container, Nav, Navbar, Badge } from 'react-bootstrap';
import EventList from './pages/EventList';
import EventDetails from './pages/EventDetails';
import NotificationList from './pages/NotificationList';
import apiService from './services/api.service';

function App() {
  const [notificationCount, setNotificationCount] = useState(0);

  useEffect(() => {
    const fetchNotifications = async () => {
      try {
        const data = await apiService.getNotifications();
        const unreadCount = data.filter(n => !n.read).length;
        setNotificationCount(unreadCount);
      } catch (error) {
        console.error('Failed to fetch notifications:', error);
      }
    };

    fetchNotifications();
    const interval = setInterval(fetchNotifications, 5000);
    
    return () => clearInterval(interval);
  }, []);

  return (
    <div className="d-flex flex-column min-vh-100">
      <Navbar bg="dark" variant="dark" expand="lg" className="mb-4">
        <Container>
          <Navbar.Brand as={Link} to="/">Réservation d'Événements</Navbar.Brand>
          <Navbar.Toggle aria-controls="basic-navbar-nav" />
          <Navbar.Collapse id="basic-navbar-nav">
            <Nav className="me-auto">
              <Nav.Link as={Link} to="/">Événements</Nav.Link>
              <Nav.Link as={Link} to="/notifications">
                Notifications
                {notificationCount > 0 && (
                  <Badge pill bg="danger" className="ms-1">
                    {notificationCount}
                  </Badge>
                )}
              </Nav.Link>
            </Nav>
          </Navbar.Collapse>
        </Container>
      </Navbar>

      <Container className="flex-grow-1">
        <Routes>
          <Route path="/" element={<EventList />} />
          <Route path="/events/:id" element={<EventDetails />} />
          <Route path="/notifications" element={<NotificationList />} />
        </Routes>
      </Container>

      <footer className="bg-light py-3 mt-4">
        <Container className="text-center">
          <p className="text-muted mb-0">
            TP2 - Communication entre microservices &copy; {new Date().getFullYear()}
          </p>
        </Container>
      </footer>
    </div>
  );
}

export default App;
EOF

cat > frontend/src/services/api.service.js << 'EOF'
import axios from 'axios';

const API_URL = process.env.NODE_ENV === 'production' 
  ? 'http://localhost:8000/api' 
  : 'http://localhost:8000/api';

const apiService = {
  // Events
  getEvents: async () => {
    const response = await axios.get(`${API_URL}/events`);
    return response.data;
  },
  
  getEvent: async (id) => {
    const response = await axios.get(`${API_URL}/events/${id}`);
    return response.data;
  },
  
  createEvent: async (eventData) => {
    const response = await axios.post(`${API_URL}/events`, eventData);
    return response.data;
  },
  
  // Reservations
  getReservations: async () => {
    const response = await axios.get(`${API_URL}/reservations`);
    return response.data;
  },
  
  createReservation: async (reservationData) => {
    const response = await axios.post(`${API_URL}/reservations`, reservationData);
    return response.data;
  },
  
  // Notifications
  getNotifications: async () => {
    const response = await axios.get(`${API_URL}/notifications`);
    return response.data;
  },
  
  markNotificationAsRead: async (id) => {
    const response = await axios.put(`${API_URL}/notifications/${id}/read`);
    return response.data;
  }
};

export default apiService;
EOF

cat > frontend/src/pages/EventList.js << 'EOF'
import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { Row, Col, Card, Button, Alert } from 'react-bootstrap';
import apiService from '../services/api.service';

const EventList = () => {
  const [events, setEvents] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchEvents = async () => {
      try {
        const data = await apiService.getEvents();
        setEvents(data);
        setLoading(false);
      } catch (error) {
        console.error('Error fetching events:', error);
        setError('Failed to load events. Please try again later.');
        setLoading(false);
      }
    };

    fetchEvents();
  }, []);

  const formatDate = (dateString) => {
    const options = { 
      year: 'numeric', 
      month: 'long', 
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    };
    return new Date(dateString).toLocaleDateString('fr-FR', options);
  };

  if (loading) {
    return <div className="text-center py-5">Chargement des événements...</div>;
  }

  if (error) {
    return (
      <Alert variant="danger" className="my-3">
        {error}
      </Alert>
    );
  }

  return (
    <div>
      <h1 className="mb-4">Événements à venir</h1>
      
      {events.length === 0 ? (
        <Alert variant="info">Aucun événement disponible pour le moment.</Alert>
      ) : (
        <Row xs={1} md={2} lg={3} className="g-4">
          {events.map((event) => (
            <Col key={event.id}>
              <Card className="h-100 event-card">
                <Card.Body>
                  <Card.Title>{event.name}</Card.Title>
                  <Card.Text className="text-muted mb-2">
                    {formatDate(event.date)}
                  </Card.Text>
                  <Card.Text>
                    {event.description.length > 100
                      ? `${event.description.substring(0, 100)}...`
                      : event.description}
                  </Card.Text>
                  <Card.Text>
                    <strong>Lieu :</strong> {event.location}
                  </Card.Text>
                  <Card.Text>
                    <strong>Places disponibles :</strong> {event.totalCapacity - event.bookedSeats} / {event.totalCapacity}
                  </Card.Text>
                </Card.Body>
                <Card.Footer className="bg-white">
                  <Button
                    as={Link}
                    to={`/events/${event.id}`}
                    variant="primary"
                    className="w-100"
                  >
                    Voir détails
                  </Button>
                </Card.Footer>
              </Card>
            </Col>
          ))}
        </Row>
      )}
    </div>
  );
};

export default EventList;
EOF

cat > frontend/src/pages/EventDetails.js << 'EOF'
import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { Card, Button, Form, Alert, ProgressBar } from 'react-bootstrap';
import apiService from '../services/api.service';

const EventDetails = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  
  const [event, setEvent] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [reservationData, setReservationData] = useState({
    userId: 'user123',  // Simplified for the example
    userName: 'Test User',
    userEmail: 'test@example.com',
    seats: 1
  });
  const [reservationError, setReservationError] = useState(null);
  const [reservationSuccess, setReservationSuccess] = useState(null);

  useEffect(() => {
    const fetchEvent = async () => {
      try {
        const data = await apiService.getEvent(id);
        setEvent(data);
        setLoading(false);
      } catch (error) {
        console.error('Error fetching event:', error);
        setError('Failed to load event details. Please try again later.');
        setLoading(false);
      }
    };

    fetchEvent();
  }, [id]);

  const handleReservation = async (e) => {
    e.preventDefault();
    setReservationError(null);
    setReservationSuccess(null);
    
    try {
      const data = await apiService.createReservation({
        ...reservationData,
        eventId: parseInt(id)
      });
      
      setReservationSuccess('Réservation effectuée avec succès!');
      
      // Refresh event data to update available seats
      const updatedEvent = await apiService.getEvent(id);
      setEvent(updatedEvent);
      
      // Reset form
      setReservationData({
        ...reservationData,
        seats: 1
      });
    } catch (error) {
      console.error('Error creating reservation:', error);
      setReservationError(error.message || 'Failed to create reservation. Please try again.');
    }
  };

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setReservationData({
      ...reservationData,
      [name]: name === 'seats' ? parseInt(value) : value
    });
  };

  const formatDate = (dateString) => {
    const options = { 
      year: 'numeric', 
      month: 'long', 
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    };
    return new Date(dateString).toLocaleDateString('fr-FR', options);
  };

  if (loading) {
    return <div className="text-center py-5">Chargement des détails de l'événement...</div>;
  }

  if (error) {
    return (
      <Alert variant="danger" className="my-3">
        {error}
      </Alert>
    );
  }

  if (!event) {
    return (
      <Alert variant="warning" className="my-3">
        Événement non trouvé.
      </Alert>
    );
  }

  const availableSeats = event.totalCapacity - event.bookedSeats;
  const occupancyRate = (event.bookedSeats / event.totalCapacity) * 100;

  return (
    <div>
      <Button 
        variant="outline-secondary" 
        onClick={() => navigate(-1)} 
        className="mb-3"
      >
        &larr; Retour
      </Button>
      
      <Card className="mb-4">
        <Card.Body>
          <Card.Title as="h1">{event.name}</Card.Title>
          <Card.Subtitle className="mb-3 text-muted">
            {formatDate(event.date)}
          </Card.Subtitle>
          
          <Card.Text>{event.description}</Card.Text>
          
          <div className="mb-3">
            <strong>Lieu :</strong> {event.location}
          </div>
          
          <div className="mb-3">
            <strong>Capacité :</strong> {event.totalCapacity} places
          </div>
          
          <div className="mb-3">
            <strong>Places réservées :</strong> {event.bookedSeats} / {event.totalCapacity}
            <ProgressBar 
              now={occupancyRate} 
              variant={occupancyRate > 80 ? "danger" : occupancyRate > 50 ? "warning" : "success"} 
              className="mt-2"
            />
          </div>
          
          <div className="mb-3">
            <strong>Places disponibles :</strong> {availableSeats}
          </div>
        </Card.Body>
      </Card>
      
      <Card>
        <Card.Header as="h5">Réserver des places</Card.Header>
        <Card.Body>
          {reservationSuccess && (
            <Alert variant="success" className="mb-3">
              {reservationSuccess}
            </Alert>
          )}
          
          {reservationError && (
            <Alert variant="danger" className="mb-3">
              {reservationError}
            </Alert>
          )}
          
          {availableSeats > 0 ? (
            <Form onSubmit={handleReservation}>
              <Form.Group className="mb-3">
                <Form.Label>Nom</Form.Label>
                <Form.Control
                  type="text"
                  name="userName"
                  value={reservationData.userName}
                  onChange={handleInputChange}
                  required
                />
              </Form.Group>
              
              <Form.Group className="mb-3">
                <Form.Label>Email</Form.Label>
                <Form.Control
                  type="email"
                  name="userEmail"
                  value={reservationData.userEmail}
                  onChange={handleInputChange}
                  required
                />
              </Form.Group>
              
              <Form.Group className="mb-3">
                <Form.Label>Nombre de places</Form.Label>
                <Form.Control
                  type="number"
                  name="seats"
                  value={reservationData.seats}
                  onChange={handleInputChange}
                  min="1"
                  max={availableSeats}
                  required
                />
                <Form.Text className="text-muted">
                  Maximum {availableSeats} places disponibles.
                </Form.Text>
              </Form.Group>
              
              <Button variant="primary" type="submit">
                Réserver
              </Button>
            </Form>
          ) : (
            <Alert variant="warning">
              Désolé, cet événement est complet. Aucune place n'est disponible.
            </Alert>
          )}
        </Card.Body>
      </Card>
    </div>
  );
};

export default EventDetails;
EOF

cat > frontend/src/pages/NotificationList.js << 'EOF'
import React, { useState, useEffect } from 'react';
import { ListGroup, Alert, Button } from 'react-bootstrap';
import apiService from '../services/api.service';

const NotificationList = () => {
  const [notifications, setNotifications] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchNotifications = async () => {
      try {
        const data = await apiService.getNotifications();
        setNotifications(data);
        setLoading(false);
      } catch (error) {
        console.error('Error fetching notifications:', error);
        setError('Failed to load notifications. Please try again later.');
        setLoading(false);
      }
    };

    fetchNotifications();
    
    // Poll for new notifications
    const interval = setInterval(fetchNotifications, 5000);
    
    return () => clearInterval(interval);
  }, []);

  const markAsRead = async (id) => {
    try {
      await apiService.markNotificationAsRead(id);
      setNotifications(
        notifications.map(notification =>
          notification.notificationId === id
            ? { ...notification, read: true }
            : notification
        )
      );
    } catch (error) {
      console.error('Error marking notification as read:', error);
    }
  };

  const formatTimestamp = (timestamp) => {
    const date = new Date(timestamp * 1000);
    return date.toLocaleString();
  };

  if (loading) {
    return <div className="text-center py-5">Chargement des notifications...</div>;
  }

  if (error) {
    return (
      <Alert variant="danger" className="my-3">
        {error}
      </Alert>
    );
  }

  return (
    <div>
      <h1 className="mb-4">Notifications</h1>
      
      {notifications.length === 0 ? (
        <Alert variant="info">Aucune notification pour le moment.</Alert>
      ) : (
        <ListGroup>
          {notifications.map((notification) => (
            <ListGroup.Item
              key={notification.notificationId}
              className={`notification ${!notification.read ? 'notification-unread' : ''}`}
            >
              <div className="d-flex justify-content-between align-items-start">
                <div>
                  <p className="mb-1">{notification.message}</p>
                  <small className="text-muted">
                    {formatTimestamp(notification.createdAt)}
                  </small>
                </div>
                {!notification.read && (
                  <Button
                    variant="outline-primary"
                    size="sm"
                    onClick={() => markAsRead(notification.notificationId)}
                  >
                    Marquer comme lu
                  </Button>
                )}
              </div>
            </ListGroup.Item>
          ))}
        </ListGroup>
      )}
    </div>
  );
};

export default NotificationList;
EOF

cat > frontend/package.json << 'EOF'
{
  "name": "frontend",
  "version": "0.1.0",
  "private": true,
  "dependencies": {
    "@testing-library/jest-dom": "^5.16.5",
    "@testing-library/react": "^13.4.0",
    "@testing-library/user-event": "^13.5.0",
    "axios": "^1.4.0",
    "bootstrap": "^5.3.0",
    "react": "^18.2.0",
    "react-bootstrap": "^2.8.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.14.1",
    "react-scripts": "5.0.1",
    "web-vitals": "^2.1.4"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  },
  "eslintConfig": {
    "extends": [
      "react-app",
      "react-app/jest"
    ]
  },
  "browserslist": {
    "production": [
      ">0.2%",
      "not dead",
      "not op_mini all"
    ],
    "development": [
      "last 1 chrome version",
      "last 1 firefox version",
      "last 1 safari version"
    ]
  }
}
EOF

cat > frontend/Dockerfile << 'EOF'
FROM node:18-alpine as build

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . ./
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 3000

CMD ["nginx", "-g", "daemon off;"]
EOF

cat > frontend/nginx.conf << 'EOF'
server {
    listen 3000;
    
    location / {
        root /usr/share/nginx/html;
        index index.html index.htm;
        try_files $uri $uri/ /index.html;
    }
    
    error_page 500 502 503 504 /50x.html;
    
    location = /50x.html {
        root /usr/share/nginx/html;
    }
}
EOF

echo "📝 Création du fichier docker-compose.yml..."

# Fichier docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3'

services:
  event-service:
    build: ./event-service
    container_name: event-service
    ports:
      - "8080:8080"
    environment:
      - SPRING_DATASOURCE_URL=jdbc:h2:mem:eventdb
      - SPRING_DATASOURCE_USERNAME=sa
      - SPRING_DATASOURCE_PASSWORD=password
    networks:
      - app-network
    depends_on:
      - rabbitmq
    restart: always

  reservation-service:
    build: ./reservation-service
    container_name: reservation-service
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - MONGODB_URI=mongodb://mongodb:27017/reservations
    networks:
      - app-network
    depends_on:
      - mongodb
      - rabbitmq
      - event-service
    restart: always

  notification-service:
    build: ./notification-service
    container_name: notification-service
    ports:
      - "5000:5000"
    environment:
      - FLASK_ENV=production
      - FLASK_APP=app.py
    networks:
      - app-network
    depends_on:
      - mongodb
      - rabbitmq
    restart: always

  api-gateway:
    build: ./api-gateway
    container_name: api-gateway
    ports:
      - "8000:8000"
    environment:
      - NODE_ENV=production
    networks:
      - app-network
    depends_on:
      - event-service
      - reservation-service
      - notification-service
    restart: always

  mongodb:
    image: mongo:latest
    container_name: mongodb
    ports:
      - "27017:27017"
    volumes:
      - mongodb_data:/data/db
    networks:
      - app-network

  rabbitmq:
    image: rabbitmq:3-management
    container_name: rabbitmq
    ports:
      - "5672:5672"   # AMQP port
      - "15672:15672" # Management UI port
    environment:
      - RABBITMQ_DEFAULT_USER=guest
      - RABBITMQ_DEFAULT_PASS=guest
    volumes:
      - rabbitmq_data:/var/lib/rabbitmq
    networks:
      - app-network
    healthcheck:
      test: ["CMD", "rabbitmqctl", "status"]
      interval: 10s
      timeout: 5s
      retries: 5

  frontend:
    build: ./frontend
    container_name: frontend
    ports:
      - "3001:3000"
    networks:
      - app-network
    depends_on:
      - api-gateway
    restart: always

volumes:
  mongodb_data:
  rabbitmq_data:

networks:
  app-network:
    driver: bridge
EOF

echo "📝 Création du fichier README.md..."

# Fichier README.md
cat > README.md << 'EOF'
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
EOF

# Rendre le script exécutable
chmod +x setup.sh

echo "✅ Initialisation terminée ! Structure du projet créée avec succès."
echo "📊 Résumé des fichiers créés :"
echo "- Service Événements (Java/Spring Boot) avec les TODOs MS1, REST1"
echo "- Service Réservations (Node.js/Express) avec les TODOs REST2, MQ1, MQ2"
echo "- Service Notifications (Python/Flask) avec le TODO MQ3"
echo "- API Gateway (Node.js/Express) avec les TODOs GW1, GW2, GW3"
echo "- Module de résilience avec les TODOs RESILIENCE1, RESILIENCE2, RESILIENCE3"
echo "- Frontend React avec interface utilisateur complète"
echo "- Docker Compose pour orchestrer l'ensemble"
echo "- README.md avec documentation et instructions"
echo ""
echo "Pour lancer l'application :"
echo "  1. Démarrez Docker sur votre machine"
echo "  2. Exécutez 'docker-compose up -d'"
echo "  3. Accédez au frontend à http://localhost:3001"
echo ""
echo "N'oubliez pas de compléter les sections marquées avec TODO pour faire fonctionner le système."
echo "Bonne chance et bon TP ! 🚀"