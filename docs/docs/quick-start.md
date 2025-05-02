---
sidebar_position: 2
title: Quick Start
---

# Getting Started with GraphQL

:::info
This is a technical guide on how to query Relay API using GraphQL clients. If you're looking for no-code integrations, [learn more here](./no-code-integration).
:::

GraphQL queries are executed by making `POST` HTTP requests to the following endpoint:

```javascript
https://api.relaywireless.com/graphql
```

Each query starts with one of the objects listed in [GraphQL Schema](./schema), which serves as the entry point for all queries defined by the schema.

GraphQL queries function similarly to a `GET` request in REST.

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

## Making Your First Query

### Using curl

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -d '{"query": "{ status }"}' \
  https://api.relaywireless.com/graphql
```

### Using a GraphQL Client

```javascript
// Using Apollo Client
import { ApolloClient, InMemoryCache, gql } from "@apollo/client";

const client = new ApolloClient({
  uri: "https://api.relaywireless.com/graphql",
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

## Available Queries

The API provides the following main queries:

- `status`: Get the API status
- `iotRewardShares`: Get IoT reward shares
- `mobileRewardShares`: Get Mobile reward shares
- `echo`: Echo a message (for testing)

For detailed information about the available fields and types, refer to the [GraphQL Schema Documentation](./schema).

## Rate Limiting

- Monitor your rate limits in response headers
- Use the `X-RateLimit-Remaining` header to track usage
- Implement exponential backoff for retry logic

## Example Queries

1. **Get IoT Reward Shares**:

   ```graphql
   query {
     iotRewardShares(
       first: 10
       startPeriod: "2024-01-01T00:00:00Z"
       endPeriod: "2024-01-31T23:59:59Z"
     ) {
       nodes {
         hotspotKey
         amount
         beaconAmount
         dcTransferAmount
         witnessAmount
         startPeriod
         endPeriod
         rewardType
         unallocatedRewardType
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
     mobileRewardShares(
       first: 10
       startPeriod: "2024-01-01T00:00:00Z"
       endPeriod: "2024-01-31T23:59:59Z"
     ) {
       nodes {
         hotspotKey
         amount
         baseCoveragePointsSum
         basePocReward
         baseRewardShares
         boostedCoveragePointsSum
         boostedPocReward
         boostedRewardShares
         cbsdId
         dcTransferReward
         discoveryLocationAmount
         startPeriod
         endPeriod
         entity
         locationTrustScoreMultiplier
         matchedAmount
         oracleBoostedHexStatus
         ownerKey
         pocReward
         rewardType
         seniorityTimestamp
         serviceProviderAmount
         serviceProviderId
         spBoostedHexStatus
         speedtestMultiplier
         subscriberId
         subscriberReward
         unallocatedRewardType
       }
       pageInfo {
         hasNextPage
         endCursor
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

## Tools and Resources

- [GraphQL Playground](https://api.relaywireless.com/graphiql) - Interactive API explorer (you need to be authenticated)
- [Apollo Studio](https://studio.apollographql.com/) - Advanced API development environment
- [Insomnia](https://insomnia.rest/) - API client with GraphQL support
- [Postman](https://www.postman.com/) - API platform with GraphQL support
