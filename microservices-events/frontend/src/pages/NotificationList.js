import React, { useState, useEffect } from 'react';
import { ListGroup, Alert, Button } from 'react-bootstrap';
import apiService from '../services/api.service';

const NotificationList = () => {
  const [notifications, setNotifications] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchNotifications = async () => {
      try {
        const data = await apiService.getNotifications();
        setNotifications(data);
        setLoading(false);
      } catch (error) {
        console.error('Error fetching notifications:', error);
        setError('Failed to load notifications. Please try again later.');
        setLoading(false);
      }
    };

    fetchNotifications();
    
    // Poll for new notifications
    const interval = setInterval(fetchNotifications, 5000);
    
    return () => clearInterval(interval);
  }, []);

  const markAsRead = async (id) => {
    try {
      await apiService.markNotificationAsRead(id);
      setNotifications(
        notifications.map(notification =>
          notification.notificationId === id
            ? { ...notification, read: true }
            : notification
        )
      );
    } catch (error) {
      console.error('Error marking notification as read:', error);
    }
  };

  const formatTimestamp = (timestamp) => {
    const date = new Date(timestamp * 1000);
    return date.toLocaleString();
  };

  if (loading) {
    return <div className="text-center py-5">Chargement des notifications...</div>;
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
      <h1 className="mb-4">Notifications</h1>
      
      {notifications.length === 0 ? (
        <Alert variant="info">Aucune notification pour le moment.</Alert>
      ) : (
        <ListGroup>
          {notifications.map((notification) => (
            <ListGroup.Item
              key={notification.notificationId}
              className={`notification ${!notification.read ? 'notification-unread' : ''}`}
            >
              <div className="d-flex justify-content-between align-items-start">
                <div>
                  <p className="mb-1">{notification.message}</p>
                  <small className="text-muted">
                    {formatTimestamp(notification.createdAt)}
                  </small>
                </div>
                {!notification.read && (
                  <Button
                    variant="outline-primary"
                    size="sm"
                    onClick={() => markAsRead(notification.notificationId)}
                  >
                    Marquer comme lu
                  </Button>
                )}
              </div>
            </ListGroup.Item>
          ))}
        </ListGroup>
      )}
    </div>
  );
};

export default NotificationList;
