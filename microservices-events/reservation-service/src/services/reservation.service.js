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
    await rabbitmq.publishMessage(rabbitmq.ROUTING_KEY, {
      eventId: reservation.eventId,
      reservationId: reservation._id,
      userId: reservation.userId,
      userName: reservation.userName,
      userEmail: reservation.userEmail,
      seats: reservation.seats,
      status: reservation.status,
      createdAt: reservation.createdAt
    });

    
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
