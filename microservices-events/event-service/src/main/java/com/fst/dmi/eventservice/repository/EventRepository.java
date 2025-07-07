package com.fst.dmi.eventservice.repository;

import com.fst.dmi.eventservice.model.Event;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface EventRepository extends JpaRepository<Event, Long> {
    // Méthodes additionnelles si nécessaire
}
