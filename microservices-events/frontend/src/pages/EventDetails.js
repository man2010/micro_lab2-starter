import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { Card, Button, Form, Alert, ProgressBar } from 'react-bootstrap';
import apiService from '../services/api.service';

const EventDetails = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  
  const [event, setEvent] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [reservationData, setReservationData] = useState({
    userId: 'user123',  // Simplified for the example
    userName: 'Test User',
    userEmail: 'test@example.com',
    seats: 1
  });
  const [reservationError, setReservationError] = useState(null);
  const [reservationSuccess, setReservationSuccess] = useState(null);

  useEffect(() => {
    const fetchEvent = async () => {
      try {
        const data = await apiService.getEvent(id);
        setEvent(data);
        setLoading(false);
      } catch (error) {
        console.error('Error fetching event:', error);
        setError('Failed to load event details. Please try again later.');
        setLoading(false);
      }
    };

    fetchEvent();
  }, [id]);

  const handleReservation = async (e) => {
    e.preventDefault();
    setReservationError(null);
    setReservationSuccess(null);
    
    try {
      const data = await apiService.createReservation({
        ...reservationData,
        eventId: parseInt(id)
      });
      
      setReservationSuccess('Réservation effectuée avec succès!');
      
      // Refresh event data to update available seats
      const updatedEvent = await apiService.getEvent(id);
      setEvent(updatedEvent);
      
      // Reset form
      setReservationData({
        ...reservationData,
        seats: 1
      });
    } catch (error) {
      console.error('Error creating reservation:', error);
      setReservationError(error.message || 'Failed to create reservation. Please try again.');
    }
  };

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setReservationData({
      ...reservationData,
      [name]: name === 'seats' ? parseInt(value) : value
    });
  };

  const formatDate = (dateString) => {
    const options = { 
      year: 'numeric', 
      month: 'long', 
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    };
    return new Date(dateString).toLocaleDateString('fr-FR', options);
  };

  if (loading) {
    return <div className="text-center py-5">Chargement des détails de l'événement...</div>;
  }

  if (error) {
    return (
      <Alert variant="danger" className="my-3">
        {error}
      </Alert>
    );
  }

  if (!event) {
    return (
      <Alert variant="warning" className="my-3">
        Événement non trouvé.
      </Alert>
    );
  }

  const availableSeats = event.totalCapacity - event.bookedSeats;
  const occupancyRate = (event.bookedSeats / event.totalCapacity) * 100;

  return (
    <div>
      <Button 
        variant="outline-secondary" 
        onClick={() => navigate(-1)} 
        className="mb-3"
      >
        &larr; Retour
      </Button>
      
      <Card className="mb-4">
        <Card.Body>
          <Card.Title as="h1">{event.name}</Card.Title>
          <Card.Subtitle className="mb-3 text-muted">
            {formatDate(event.date)}
          </Card.Subtitle>
          
          <Card.Text>{event.description}</Card.Text>
          
          <div className="mb-3">
            <strong>Lieu :</strong> {event.location}
          </div>
          
          <div className="mb-3">
            <strong>Capacité :</strong> {event.totalCapacity} places
          </div>
          
          <div className="mb-3">
            <strong>Places réservées :</strong> {event.bookedSeats} / {event.totalCapacity}
            <ProgressBar 
              now={occupancyRate} 
              variant={occupancyRate > 80 ? "danger" : occupancyRate > 50 ? "warning" : "success"} 
              className="mt-2"
            />
          </div>
          
          <div className="mb-3">
            <strong>Places disponibles :</strong> {availableSeats}
          </div>
        </Card.Body>
      </Card>
      
      <Card>
        <Card.Header as="h5">Réserver des places</Card.Header>
        <Card.Body>
          {reservationSuccess && (
            <Alert variant="success" className="mb-3">
              {reservationSuccess}
            </Alert>
          )}
          
          {reservationError && (
            <Alert variant="danger" className="mb-3">
              {reservationError}
            </Alert>
          )}
          
          {availableSeats > 0 ? (
            <Form onSubmit={handleReservation}>
              <Form.Group className="mb-3">
                <Form.Label>Nom</Form.Label>
                <Form.Control
                  type="text"
                  name="userName"
                  value={reservationData.userName}
                  onChange={handleInputChange}
                  required
                />
              </Form.Group>
              
              <Form.Group className="mb-3">
                <Form.Label>Email</Form.Label>
                <Form.Control
                  type="email"
                  name="userEmail"
                  value={reservationData.userEmail}
                  onChange={handleInputChange}
                  required
                />
              </Form.Group>
              
              <Form.Group className="mb-3">
                <Form.Label>Nombre de places</Form.Label>
                <Form.Control
                  type="number"
                  name="seats"
                  value={reservationData.seats}
                  onChange={handleInputChange}
                  min="1"
                  max={availableSeats}
                  required
                />
                <Form.Text className="text-muted">
                  Maximum {availableSeats} places disponibles.
                </Form.Text>
              </Form.Group>
              
              <Button variant="primary" type="submit">
                Réserver
              </Button>
            </Form>
          ) : (
            <Alert variant="warning">
              Désolé, cet événement est complet. Aucune place n'est disponible.
            </Alert>
          )}
        </Card.Body>
      </Card>
    </div>
  );
};

export default EventDetails;
