const express = require('express');
const router = express.Router();
const reservationController = require('../controllers/reservation.controller');

// Ces routes sont des proxies vers le service d'événements
router.get('/', reservationController.getAllEvents);
router.get('/:id', reservationController.getEventById);

module.exports = router;
