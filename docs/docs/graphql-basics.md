---
sidebar_position: 2
title: GraphQL Basics
---

# Getting Started with GraphQL

This guide will help you understand how to use our GraphQL API, even if you're new to GraphQL.

## Making Your First Query

### Using curl

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -d '{"query": "{ status }"}' \
  https://helium-api.relaywireless.com/graphql
```

### Using a GraphQL Client

```javascript
// Using Apollo Client
import { ApolloClient, InMemoryCache, gql } from "@apollo/client";

const client = new ApolloClient({
  uri: "https://helium-api.relaywireless.com/graphql",
  cache: new InMemoryCache(),
  headers: {
    Authorization: "Bearer YOUR_API_KEY",
  },
});

// Make a query
client
  .query({
    query: gql`
      {
        status
      }
    `,
  })
  .then((result) => console.log(result));
```

## Authentication

All requests need to include your API key in the Authorization header:

```
Authorization: Bearer YOUR_API_KEY
```

## Basic Query Structure

GraphQL queries follow this pattern:

```graphql
query {
  resourceName {
    field1
    field2
    nestedResource {
      nestedField1
      nestedField2
    }
  }
}
```

### Example Queries

1. **Get IoT Beacon Ingest Reports**:

   ```graphql
   query {
     iotBeaconIngestReports(first: 10) {
       nodes {
         hotspotKey
         data
         dataRate
         frequency
         receivedAt
         reportedAt
         signature
       }
       pageInfo {
         hasNextPage
         endCursor
       }
     }
   }
   ```

2. **Get Mobile Reward Shares**:
   ```graphql
   query {
     mobileRewardShares(first: 10) {
       nodes {
         hotspotKey
         amount
         rewardType
         startPeriod
         endPeriod
         serviceProviderId
       }
     }
   }
   ```

## Using Variables

Variables make your queries more reusable:

```graphql
query GetRewardShares($first: Int!) {
  mobileRewardShares(first: $first) {
    nodes {
      hotspotKey
      amount
      rewardType
    }
  }
}
```

Variables JSON:

```json
{
  "first": 5
}
```

## Error Handling

GraphQL returns errors in a consistent format:

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

## Pagination

All list queries support cursor-based pagination:

```graphql
query {
  iotWitnessIngestReports(first: 10) {
    nodes {
      hotspotKey
      dataRate
      frequency
    }
    pageInfo {
      hasNextPage
      endCursor
    }
  }
}
```

To get the next page, use the `endCursor` from the previous query:

```graphql
query {
  iotWitnessIngestReports(first: 10, after: "previous-end-cursor") {
    nodes {
      hotspotKey
      dataRate
      frequency
    }
    pageInfo {
      hasNextPage
      endCursor
    }
  }
}
```

## Best Practices

1. **Request Only What You Need**

   ```graphql
   # Good
   query {
     mobileRewardShares(first: 10) {
       nodes {
         hotspotKey
         amount
       }
     }
   }

   # Bad - requesting unnecessary fields
   query {
     mobileRewardShares(first: 10) {
       nodes {
         hotspotKey
         amount
         rewardType
         startPeriod
         endPeriod
         serviceProviderId
         # ... many more fields
       }
     }
   }
   ```

2. **Use Fragments for Reusable Fields**

   ```graphql
   fragment RewardDetails on MobileRewardShare {
     hotspotKey
     amount
     rewardType
     startPeriod
     endPeriod
   }

   query {
     mobileRewardShares(first: 10) {
       nodes {
         ...RewardDetails
         serviceProviderId
       }
     }
   }
   ```

## Available Queries

The API provides the following main queries:

- `status`: Get the API status
- `iotBeaconIngestReports`: Get IoT beacon ingest reports
- `iotWitnessIngestReports`: Get IoT witness ingest reports
- `iotRewardShares`: Get IoT reward shares
- `mobileRewardShares`: Get mobile reward shares

For detailed information about the available fields and types, refer to the [GraphQL Schema Documentation](./schema).

## Rate Limiting

- Monitor your rate limits in response headers
- Use the `X-RateLimit-Remaining` header to track usage
- Implement exponential backoff for retry logic

## Tools and Resources

- [GraphQL Playground](https://api.helium.io/graphql) - Interactive API explorer
- [Apollo Studio](https://studio.apollographql.com/) - Advanced API development environment
- [Insomnia](https://insomnia.rest/) - API client with GraphQL support
- [Postman](https://www.postman.com/) - API platform with GraphQL support
