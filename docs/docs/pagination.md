# Pagination

The Relay API uses page-based pagination to efficiently handle large datasets and improve performance.

Paginated responses contain two main sections:

```json
{
  "meta": {
    "count": 25, // number of records in the current page
    "total_pages": 10, // total number of pages available
    "current_page": 1, // current page number
    "next_page": 2, // next page number
    "prev_page": null // previous page number
  },
  "records": [
    // ... array of actual data objects
  ]
}
```

You can control pagination using the following query parameters:

| Parameter  | Description                    | Default | Maximum |
| ---------- | ------------------------------ | ------- | ------- |
| `page`     | The page number to retrieve    | 1       | -       |
| `per_page` | The number of records per page | 25      | 100     |

For example, to retrieve the second page of IoT reward shares with 50 records per page:

```
GET /v1/helium/l2/iot-reward-shares?from=2024-01-01&to=2024-01-31&page=2&per_page=50
```

This would return a response like:

```json
{
  "meta": {
    "count": 50,
    "total_pages": 5,
    "current_page": 2,
    "next_page": 3,
    "prev_page": 1
  },
  "records": [
    // ... 50 IoT reward share objects
  ]
}
```
