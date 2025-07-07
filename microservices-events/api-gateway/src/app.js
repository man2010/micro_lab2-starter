const express = require('express');
const morgan = require('morgan');
const cors = require('cors');
const { createProxyMiddleware } = require('http-proxy-middleware');

const app = express();
const PORT = process.env.PORT || 8000;

// Middleware
app.use(cors());
app.use(morgan('dev'));

// 👉 Ne pas parser les body pour les routes proxy
app.use((req, res, next) => {
  if (!req.url.startsWith('/api/')) {
    express.json()(req, res, next);
  } else {
    next();
  }
});

// 🔧 Correction Content-Type manquant
app.use((req, res, next) => {
  if ((req.method === 'POST' || req.method === 'PUT') && !req.headers['content-type']) {
    req.headers['content-type'] = 'application/json';
  }
  next();
});

// 🔗 Définition des microservices selon l’environnement
const EVENTS_SERVICE = process.env.NODE_ENV === 'production'
  ? 'http://event-service:8080'
  : 'http://localhost:8080';

const RESERVATIONS_SERVICE = process.env.NODE_ENV === 'production'
  ? 'http://reservation-service:3000'
  : 'http://localhost:3002';

const NOTIFICATIONS_SERVICE = process.env.NODE_ENV === 'production'
  ? 'http://notification-service:5000'
  : 'http://localhost:5000';

// 📌 Route d'accueil
app.get('/', (req, res) => {
  res.json({
    message: 'Welcome to the Event Booking API Gateway',
    services: {
      events: '/api/events',
      reservations: '/api/reservations',
      notifications: '/api/notifications'
    }
  });
});

// ✅ Proxy vers Event Service
app.use('/api/events', createProxyMiddleware({
  target: EVENTS_SERVICE,
  changeOrigin: true,
  pathRewrite: { '^/api/events': '/api/events' },
  proxyTimeout: 30000,
  timeout: 30000,
  onError: (err, req, res) => {
    console.error('[Proxy error - Event Service]', err.message);
    if (!res.headersSent) {
      res.status(504).json({ error: 'Event service timeout' });
    }
  },
  logLevel: 'debug'
}));

// ✅ Proxy vers Reservation Service
app.use('/api/reservations', createProxyMiddleware({
  target: RESERVATIONS_SERVICE,
  changeOrigin: true,
  pathRewrite: { '^/api/reservations': '/api/reservations' },
  logLevel: 'debug'
}));

// ✅ Proxy vers Notification Service
app.use('/api/notifications', createProxyMiddleware({
  target: NOTIFICATIONS_SERVICE,
  changeOrigin: true,
  pathRewrite: { '^/api/notifications': '/api/notifications' },
  logLevel: 'debug'
}));

// 🛑 Suppression des duplications inutiles
// ⚠ Tu avais un createRawProxy redondant qui écrasait le proxy précédent. Supprimé.

// 🧯 Middleware global pour erreurs non attrapées
app.use((err, req, res, next) => {
  console.error('[Unhandled Gateway Error]', err.stack);
  res.status(500).json({
    error: 'Internal Server Error',
    message: err.message
  });
});

// 🚀 Lancement du serveur
app.listen(PORT, () => {
  console.log(`API Gateway running on port ${PORT}`);
});

module.exports = app;