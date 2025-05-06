# Rate Limiting

To keep Relay API running smoothly for everyone in Beta, we've implemented rate limiting. Here's what you need to know:

- 120 requests per minute
- Track your remaining requests using the `X-RateLimit-Remaining` header
- Just include your API key in the `Authorization` header

## Tips for Handling Rate Limits

- Keep an eye on those rate limit headers - they're your best friend
- If you hit a limit, don't panic! Just wait a bit and try again
- For the best experience, we recommend using an API key - you'll get higher limits and better tracking
