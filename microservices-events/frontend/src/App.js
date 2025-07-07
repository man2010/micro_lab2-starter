import React, { useState, useEffect } from 'react';
import { Routes, Route, Link } from 'react-router-dom';
import { Container, Nav, Navbar, Badge } from 'react-bootstrap';
import EventList from './pages/EventList';
import EventDetails from './pages/EventDetails';
import NotificationList from './pages/NotificationList';
import apiService from './services/api.service';

function App() {
  const [notificationCount, setNotificationCount] = useState(0);

  useEffect(() => {
    const fetchNotifications = async () => {
      try {
        const data = await apiService.getNotifications();
        const unreadCount = data.filter(n => !n.read).length;
        setNotificationCount(unreadCount);
      } catch (error) {
        console.error('Failed to fetch notifications:', error);
      }
    };

    fetchNotifications();
    const interval = setInterval(fetchNotifications, 5000);
    
    return () => clearInterval(interval);
  }, []);

  return (
    <div className="d-flex flex-column min-vh-100">
      <Navbar bg="dark" variant="dark" expand="lg" className="mb-4">
        <Container>
          <Navbar.Brand as={Link} to="/">Réservation d'Événements</Navbar.Brand>
          <Navbar.Toggle aria-controls="basic-navbar-nav" />
          <Navbar.Collapse id="basic-navbar-nav">
            <Nav className="me-auto">
              <Nav.Link as={Link} to="/">Événements</Nav.Link>
              <Nav.Link as={Link} to="/notifications">
                Notifications
                {notificationCount > 0 && (
                  <Badge pill bg="danger" className="ms-1">
                    {notificationCount}
                  </Badge>
                )}
              </Nav.Link>
            </Nav>
          </Navbar.Collapse>
        </Container>
      </Navbar>

      <Container className="flex-grow-1">
        <Routes>
          <Route path="/" element={<EventList />} />
          <Route path="/events/:id" element={<EventDetails />} />
          <Route path="/notifications" element={<NotificationList />} />
        </Routes>
      </Container>

      <footer className="bg-light py-3 mt-4">
        <Container className="text-center">
          <p className="text-muted mb-0">
            TP2 - Communication entre microservices &copy; {new Date().getFullYear()}
          </p>
        </Container>
      </footer>
    </div>
  );
}

export default App;
