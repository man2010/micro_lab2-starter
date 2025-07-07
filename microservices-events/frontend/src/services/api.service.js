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
