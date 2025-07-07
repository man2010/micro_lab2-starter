// rabbitmq.config.js
const amqp = require('amqplib');

const RABBITMQ_URL = process.env.NODE_ENV === 'production'
  ? 'amqp://guest:guest@rabbitmq:5672'
  : 'amqp://guest:guest@localhost:5672';

const EXCHANGE_NAME = 'events_exchange';
const QUEUE_NAME = 'reservation_events';
const ROUTING_KEY = 'reservation.created';

let channel = null;

const connect = async () => {
  try {
    const connection = await amqp.connect(RABBITMQ_URL);
    const ch = await connection.createChannel();

    await ch.assertExchange(EXCHANGE_NAME, 'topic', { durable: true });
    await ch.assertQueue(QUEUE_NAME, { durable: true });
    await ch.bindQueue(QUEUE_NAME, EXCHANGE_NAME, 'reservation.*');

    channel = ch;
    console.log('✅ Connecté à RabbitMQ');

    connection.on('close', () => {
      console.log('❗ Connexion RabbitMQ fermée, tentative de reconnexion...');
      setTimeout(connect, 5000);
    });

    return ch;
  } catch (error) {
    console.error('❌ Erreur de connexion à RabbitMQ :', error.message);
    setTimeout(connect, 5000);
  }
};

connect();

// 🔄 Publication d'un message dans l'exchange
const publishMessage = async (routingKey, message) => {
  try {
    if (!channel) {
      console.log('📡 Canal RabbitMQ non disponible, reconnexion...');
      await connect();
    }

    const buffer = Buffer.from(JSON.stringify(message));
    channel.publish(EXCHANGE_NAME, routingKey, buffer, { persistent: true });
    console.log('📨 Message publié :', message);
    return true;
  } catch (error) {
    console.error('❌ Erreur lors de la publication du message :', error.message);
    return false;
  }
};

module.exports = {
  connect,
  publishMessage,
  EXCHANGE_NAME,
  QUEUE_NAME,
  ROUTING_KEY
};
