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
