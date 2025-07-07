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
  try {
    return await getEventByIdCircuitBreaker.execute(async () => {
      const response = await apiClient.get(`${EVENT_SERVICE_URL}/${eventId}`);
      return response.data;
    });
  } catch (error) {
    if (error.message === 'Circuit is open, request rejected') {
      throw new Error('Event service is currently unavailable');
    }
    if (error.response && error.response.status === 404) {
      throw new Error(`Event with ID ${eventId} not found`);
    }
    console.error(`❌ Failed to fetch event ${eventId}:`, error.message);
    throw new Error('Failed to fetch event');
  }
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
