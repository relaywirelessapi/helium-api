# Error Handling

The API returns 2xx codes for all successful responses, and 4xx and 5xx codes for all errors.

We always try to return the most specific HTTP status code for an error. When a relevant status code is not available, we will return 400 Bad Request or 500 Internal Server Error.

:::info
In most cases, the API payload contains all the information you need to fix the error, so make sure to read it carefully!
:::

The API payload for errors is in a consistent format (note, however, that `doc_url` and `errors` are not always present):

```json
{
  "code": "malformed_request",
  "message": "The request is malformed. Please check the request parameters.",
  "doc_url": "https://docs.relaywireless.com/api/relay-api",
  "errors": [
    {
      "param": "hotspot_key",
      "error": "cannot be blank"
    }
  ]
}
```

## Error Codes

Here are all the possible error codes the API can return:

| Error Code                | HTTP Status           | Description                                        | How to Resolve                                                        | Notes                                                               |
| ------------------------- | --------------------- | -------------------------------------------------- | --------------------------------------------------------------------- | ------------------------------------------------------------------- |
| `authentication_required` | 401 Unauthorized      | This API endpoint requires authentication          | Provide a valid API key in the Authorization header                   |                                                                     |
| `malformed_request`       | 400 Bad Request       | The request is malformed or has invalid parameters | Check the request parameters and fix any validation errors            | Includes `errors` array with specific parameter validation failures |
| `rate_limit_exceeded`     | 429 Too Many Requests | You have been rate limited                         | Wait before making additional requests, implement exponential backoff |                                                                     |
| `usage_limit_exceeded`    | 402 Payment Required  | You have exhausted your monthly API usage limit    | Wait until your usage resets or upgrade your plan                     |                                                                     |
