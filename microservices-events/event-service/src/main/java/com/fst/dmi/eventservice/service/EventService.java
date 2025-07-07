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
