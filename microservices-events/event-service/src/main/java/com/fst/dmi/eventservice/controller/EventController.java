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
    // Cet endpoint doit recevoir une requête POST avec le nombre de places à
    // réserver
    // Il doit appeler eventService.bookEventSeats et retourner une réponse
    // appropriée
    @PostMapping("/{id}/book")
    public ResponseEntity<?> bookEventSeats(@PathVariable Long id, @RequestBody Map<String, Integer> bookingRequest) {
        Integer seats = bookingRequest.get("seats");
        if (seats == null || seats <= 0) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", "Invalid number of seats requested"));
        }
        boolean booked = eventService.bookEventSeats(id, seats);
        if (booked) {
            return ResponseEntity.ok(Map.of(
                    "message", "Successfully booked " + seats + " seats",
                    "eventId", id,
                    "seatsBooked", seats));
        } else {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", "Could not book seats. Event might not exist or not have enough capacity."));
        }
    }
}
