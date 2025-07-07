import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { Row, Col, Card, Button, Alert } from 'react-bootstrap';
import apiService from '../services/api.service';

const EventList = () => {
  const [events, setEvents] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchEvents = async () => {
      try {
        const data = await apiService.getEvents();
        setEvents(data);
        setLoading(false);
      } catch (error) {
        console.error('Error fetching events:', error);
        setError('Failed to load events. Please try again later.');
        setLoading(false);
      }
    };

    fetchEvents();
  }, []);

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
    return <div className="text-center py-5">Chargement des événements...</div>;
  }

  if (error) {
    return (
      <Alert variant="danger" className="my-3">
        {error}
      </Alert>
    );
  }

  return (
    <div>
      <h1 className="mb-4">Événements à venir</h1>
      
      {events.length === 0 ? (
        <Alert variant="info">Aucun événement disponible pour le moment.</Alert>
      ) : (
        <Row xs={1} md={2} lg={3} className="g-4">
          {events.map((event) => (
            <Col key={event.id}>
              <Card className="h-100 event-card">
                <Card.Body>
                  <Card.Title>{event.name}</Card.Title>
                  <Card.Text className="text-muted mb-2">
                    {formatDate(event.date)}
                  </Card.Text>
                  <Card.Text>
                    {event.description.length > 100
                      ? `${event.description.substring(0, 100)}...`
                      : event.description}
                  </Card.Text>
                  <Card.Text>
                    <strong>Lieu :</strong> {event.location}
                  </Card.Text>
                  <Card.Text>
                    <strong>Places disponibles :</strong> {event.totalCapacity - event.bookedSeats} / {event.totalCapacity}
                  </Card.Text>
                </Card.Body>
                <Card.Footer className="bg-white">
                  <Button
                    as={Link}
                    to={`/events/${event.id}`}
                    variant="primary"
                    className="w-100"
                  >
                    Voir détails
                  </Button>
                </Card.Footer>
              </Card>
            </Col>
          ))}
        </Row>
      )}
    </div>
  );
};

export default EventList;
