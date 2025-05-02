# Rate Limiting

Hey there! To keep our API running smoothly for everyone, we've implemented rate limiting. Here's what you need to know:

If you're using an API key, you get:

- 120 requests per minute
- Track your remaining requests using the `X-RateLimit-Remaining` header
- Just include your API key in the `Authorization` header

If you're not using an API key, you get:

- 60 requests per minute
- Same `X-RateLimit-Remaining` header to track your usage
- Rate limits are based on your IP address

## Tips for Handling Rate Limits

- Keep an eye on those rate limit headers - they're your best friend
- If you hit a limit, don't panic! Just wait a bit and try again
- For the best experience, we recommend using an API key - you'll get higher limits and better tracking
