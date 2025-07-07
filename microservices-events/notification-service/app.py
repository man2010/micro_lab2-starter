from flask import Flask, jsonify, request
import pika
import json
import threading
import time
import os
from pymongo import MongoClient

app = Flask(__name__)

# MongoDB connection
client = MongoClient('mongodb://mongodb:27017/' if os.environ.get('FLASK_ENV') == 'production' else 'mongodb://localhost:27017/')
db = client.notification_db
notifications = db.notifications

# RabbitMQ Configuration
RABBITMQ_HOST = 'rabbitmq' if os.environ.get('FLASK_ENV') == 'production' else 'localhost'
RABBITMQ_QUEUE = 'reservation_events'

def connect_to_rabbitmq():
    """Create a connection to RabbitMQ"""
    try:
        connection = pika.BlockingConnection(pika.ConnectionParameters(host=RABBITMQ_HOST))
        channel = connection.channel()
        channel.queue_declare(queue=RABBITMQ_QUEUE, durable=True)
        print("Connected to RabbitMQ")
        return connection, channel
    except Exception as e:
        print(f"Error connecting to RabbitMQ: {e}")
        return None, None

def process_message(ch, method, properties, body):
    """Process a message from RabbitMQ"""
    try:
        # Parse the message
        message = json.loads(body)
        print(f"Received message: {message}")
        
        # TODO-MQ3: Traitez le message reçu et créez une notification
        # Extrayez les informations nécessaires du message (email, nom, événement, places)
        # Créez un document notification avec ces informations
        # Sauvegardez la notification dans MongoDB
        # À implémenter


        # Extract reservation information
        user_email = message.get('userEmail')
        user_name = message.get('userName')
        event_id = message.get('eventId')
        seats = message.get('seats')
        # Create a notification
        notification = {
        'type': 'RESERVATION_CREATED',
        'userId': message.get('userId'),
        'userEmail': user_email,
        'message': f"Hello {user_name}, your reservation for event #{event_id} with {seats} seats has been confirmed.",
        'read': False,
        'createdAt': time.time()
        }
        # Save the notification to MongoDB
        notifications.insert_one(notification)
        print(f"Notification created for {user_email}")


        
        # Acknowledge the message
        ch.basic_ack(delivery_tag=method.delivery_tag)
    except Exception as e:
        print(f"Error processing message: {e}")
        # In case of error, requeue the message
        ch.basic_nack(delivery_tag=method.delivery_tag, requeue=True)

def start_consumer():
    """Start consuming messages from RabbitMQ"""
    def consumer_thread():
        while True:
            try:
                connection, channel = connect_to_rabbitmq()
                if channel:
                    # Set up the consumer
                    channel.basic_qos(prefetch_count=1)
                    channel.basic_consume(queue=RABBITMQ_QUEUE, on_message_callback=process_message)
                    
                    print("Starting to consume messages")
                    channel.start_consuming()
            except Exception as e:
                print(f"Consumer error: {e}")
                
            print("Consumer disconnected. Retrying in 5 seconds...")
            time.sleep(5)
    
    # Start the consumer in a separate thread
    thread = threading.Thread(target=consumer_thread)
    thread.daemon = True
    thread.start()
    print("Consumer thread started")

# Routes pour API
@app.route('/api/notifications', methods=['GET'])
def get_notifications():
    """Get all notifications"""
    try:
        result = list(notifications.find({}, {'_id': False}))
        return jsonify(result)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/notifications/user/<user_id>', methods=['GET'])
def get_user_notifications(user_id):
    """Get notifications for a specific user"""
    try:
        result = list(notifications.find({'userId': user_id}, {'_id': False}))
        return jsonify(result)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/notifications/<notification_id>/read', methods=['PUT'])
def mark_notification_read(notification_id):
    """Mark a notification as read"""
    try:
        notifications.update_one({'notificationId': notification_id}, {'$set': {'read': True}})
        return jsonify({'message': 'Notification marked as read'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/')
def index():
    """Home route"""
    return jsonify({
        'message': 'Notification Service API',
        'endpoints': {
            'notifications': '/api/notifications',
            'user_notifications': '/api/notifications/user/{user_id}',
            'mark_read': '/api/notifications/{notification_id}/read'
        }
    })

# Start the consumer when the app starts
start_consumer()

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=os.environ.get('FLASK_ENV') != 'production')
