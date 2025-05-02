# Error Handling

The API returns errors in a consistent format:

```json
{
  "data": { ... },
  "errors": [
    {
      "message": "Error message here",
      "locations": [{ "line": 2, "column": 3 }],
      "path": ["fieldName"]
    }
  ]
}
```
