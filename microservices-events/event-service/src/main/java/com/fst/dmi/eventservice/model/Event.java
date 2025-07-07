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

    // TODO-MS1: Implémentez la méthode bookSeats pour réserver des places si
    // disponibles
    // Cette méthode doit vérifier si le nombre de places demandées est disponible
    // Si oui, elle incrémente bookedSeats et retourne true, sinon retourne false
    public boolean bookSeats(int seats) {
        if (!hasAvailableSeats(seats)) {
            return false;
        }
        bookedSeats += seats;
        return true;
    }
}
