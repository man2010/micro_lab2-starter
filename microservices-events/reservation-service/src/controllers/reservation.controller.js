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
