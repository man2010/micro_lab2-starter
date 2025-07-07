const express = require('express');
const router = express.Router();
const reservationController = require('../controllers/reservation.controller');

// Réservation routes
router.post('/', reservationController.createReservation);
router.get('/', reservationController.getAllReservations);
router.get('/user/:userId', reservationController.getReservationsByUserId);
router.get('/:id', reservationController.getReservationById);
router.put('/:id/cancel', reservationController.cancelReservation);

module.exports = router;
