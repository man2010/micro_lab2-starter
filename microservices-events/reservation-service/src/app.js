const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const morgan = require('morgan');

const reservationRoutes = require('./routes/reservation.routes');
const eventRoutes = require('./routes/event.routes');

// Initialiser l'application Express
const app = express();
const PORT = process.env.PORT || 3000;
const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/reservations';

// Middleware
app.use(cors());
app.use(express.json());
app.use(morgan('dev'));

// Connexion à MongoDB
mongoose.connect(MONGODB_URI)
  .then(() => console.log('Connected to MongoDB'))
  .catch(err => console.error('Failed to connect to MongoDB:', err));

// Routes
app.use('/api/reservations', reservationRoutes);
app.use('/api/events', eventRoutes);

// Route de base
app.get('/', (req, res) => {
  res.json({
    message: 'Reservation Service API',
    endpoints: {
      reservations: '/api/reservations',
      events: '/api/events'
    }
  });
});

// Middleware d'erreur
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    error: 'Internal Server Error',
    message: err.message
  });
});

// Démarrer le serveur
app.listen(PORT, () => {
  console.log(`Reservation Service running on port ${PORT}`);
});

module.exports = app;
