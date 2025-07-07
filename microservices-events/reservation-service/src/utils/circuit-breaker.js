class CircuitBreaker {
  constructor(options = {}) {
    this.failureThreshold = options.failureThreshold || 3;
    this.resetTimeout = options.resetTimeout || 30000; // 30s
    this.failureCount = 0;
    this.isOpen = false;
    this.lastFailureTime = null;
  }

  async execute(fn) {
    const now = Date.now();

    if (this.isOpen) {
      if (this.lastFailureTime && (now - this.lastFailureTime) > this.resetTimeout) {
        this.isOpen = false;
        console.log('🟡 Circuit half-open, retrying request...');
      } else {
        console.log('🔴 Circuit is open — rejecting request');
        throw new Error('Circuit is open, request rejected');
      }
    }

    try {
      const result = await fn();
      this.onSuccess();
      return result;
    } catch (error) {
      this.onFailure();
      if (this.failureCount >= this.failureThreshold) {
        this.isOpen = true;
        this.lastFailureTime = now;
        console.log(`🚨 Circuit opened after ${this.failureCount} failures`);
      }
      throw error;
    }
  }

  onSuccess() {
    this.failureCount = 0;
    this.isOpen = false;
  }

  onFailure() {
    this.failureCount += 1;
    this.lastFailureTime = Date.now();
  }
}

module.exports = CircuitBreaker;
