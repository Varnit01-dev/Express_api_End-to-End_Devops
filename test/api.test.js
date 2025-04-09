const request = require('supertest');
const app = require('../Server');

describe('GET /', () => {
  it('should return hello message', async () => {
    const res = await request(app).get('/');
    expect(res.status).toBe(200);
    expect(res.text).toBe('Hello from PeerHire API!');
  });
});
