# Usage Limits

## Rate Limiting

To keep the Relay API running smoothly for everyone, the API implements rate limiting. More specifically:

- All private endpoints accept up to 120 requests/minute per API key.
- All public endpoints accept up to 60 requests/minute per IP address.

If you exceed the rate limit, you'll get a `429 Too Many Requests` response with a payload similar to the following:

```json
{
  "code": "rate_limit_exceeded",
  "message": "You have been rate limited. Please try again later.",
  "doc_url": "https://docs.relaywireless.com/usage-limits#rate-limiting"
}
```

## Plan Limits

Your monthly API credit allowance depends on your plan, and each successful API call consumes one credit.

### Available Plans

- **Community**: 1,000 requests/month - Free
- **Enthusiast**: 10,000 requests/month - $49.99/month
- **Professional**: 100,000 requests/month - $199.99/month
- **Enterprise**: Unlimited requests - Custom pricing

If you exceed the credit limit, you'll get a `402 Payment Required` response with a payload similar to the following:

```json
{
  "code": "usage_limit_exceeded",
  "message": "You have exhausted your API usage limit of 10,000 requests/month. Your usage resets at 2025-06-30 12:31:15 UTC.",
  "doc_url": "https://docs.relaywireless.com/usage-limits#plan-limits"
}
```
