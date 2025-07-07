const axios = require('axios');
const CircuitBreaker = require('../utils/circuit-breaker');


// Détection environnement
const EVENT_SERVICE_URL = process.env.NODE_ENV === 'production' 
  ? 'http://event-service:8080/api/events'
  : 'http://localhost:8080/api/events';

// Client Axios avec timeout
const apiClient = axios.create({
  timeout: 3000 // 3 seconds
});

// Mécanisme de retry avec backoff exponentiel
const retryRequest = async (fn, retries = 3, delay = 1000, backoff = 2) => {
  try {
    return await fn();
  } catch (error) {
    if (retries <= 0) {
      throw error;
    }
    console.log(`🔁 Retrying in ${delay}ms... (${retries} retries left)`);
    await new Promise(resolve => setTimeout(resolve, delay));
    return retryRequest(fn, retries - 1, delay * backoff, backoff);
  }
};

// Circuit breakers pour chaque opération
const getEventsCircuitBreaker = new CircuitBreaker();
const getEventByIdCircuitBreaker = new CircuitBreaker();
const bookSeatsCircuitBreaker = new CircuitBreaker();

// Obtenir tous les événements
const getAllEvents = async () => {
  try {
    return await getEventsCircuitBreaker.execute(() =>
      retryRequest(async () => {
        const response = await apiClient.get(EVENT_SERVICE_URL);
        return response.data;
      })
    );
  } catch (error) {
    console.error('❌ Error fetching events:', error.message);
    if (error.message === 'Circuit is open, request rejected') {
      throw new Error('Event service is currently unavailable');
    }
    throw new Error('Failed to fetch events');
  }
};

// Obtenir un événement par ID
const getEventById = async (eventId) => {
  try {
    return await getEventByIdCircuitBreaker.execute(() =>
      retryRequest(async () => {
        const response = await apiClient.get(`${EVENT_SERVICE_URL}/${eventId}`);
        return response.data;
      })
    );
  } catch (error) {
    console.error(`❌ Error fetching event ${eventId}:`, error.message);
    if (error.message === 'Circuit is open, request rejected') {
      throw new Error('Event service is currently unavailable');
    }
    if (error.response && error.response.status === 404) {
      throw new Error(`Event with ID ${eventId} not found`);
    }
    throw new Error('Failed to fetch event');
  }
};

// Réserver des places
const bookEventSeats = async (eventId, seats) => {
  try {
    return await bookSeatsCircuitBreaker.execute(() =>
      retryRequest(async () => {
        const response = await apiClient.post(`${EVENT_SERVICE_URL}/${eventId}/book`, {
          seats: seats
        });
        return response.data;
      })
    );
  } catch (error) {
    console.error(`❌ Error booking seats for event ${eventId}:`, error.message);
    if (error.message === 'Circuit is open, request rejected') {
      throw new Error('Event booking service is currently unavailable');
    }
    if (error.response) {
      throw new Error(error.response.data.error || 'Failed to book seats');
    }
    throw new Error('Failed to book seats');
  }
};

// Export des fonctions
module.exports = {
  getAllEvents,
  getEventById,
  bookEventSeats
};
