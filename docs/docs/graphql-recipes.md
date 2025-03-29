---
sidebar_position: 3
title: GraphQL Recipes
---

# GraphQL Recipes

Common recipes and patterns for getting specific data from the Helium API.

## IoT Data

### Get IoT Beacon Ingest Reports

```graphql
query {
  iotBeaconIngestReports(first: 10) {
    edges {
      node {
        hotspotKey
        data
        dataRate
        frequency
        receivedAt
        reportedAt
        signature
        tmst
        txPower
      }
    }
  }
}
```

### Get IoT Witness Ingest Reports

```graphql
query {
  iotWitnessIngestReports(first: 10) {
    edges {
      node {
        hotspotKey
        data
        dataRate
        frequency
        receivedAt
        reportedAt
        signal
        signature
        snr
        tmst
      }
    }
  }
}
```

## Reward Data

### Get IoT Reward Shares

```graphql
query {
  iotRewardShares(first: 10) {
    edges {
      node {
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
    }
  }
}
```

### Get Mobile Reward Shares

```graphql
query {
  mobileRewardShares(first: 10) {
    edges {
      node {
        hotspotKey
        amount
        cbsdId
        dcTransferReward
        discoveryLocationAmount
        startPeriod
        endPeriod
        entity
        matchedAmount
        pocReward
        rewardType
        serviceProviderAmount
        serviceProviderId
        subscriberId
        subscriberReward
      }
    }
  }
}
```

## API Status

### Get API Status

```graphql
query {
  status
}
```

## Advanced Queries

### Using Pagination

All connection-based queries support cursor-based pagination. Here's an example:

```graphql
query {
  iotBeaconIngestReports(first: 5, after: "cursor_value") {
    edges {
      cursor
      node {
        hotspotKey
        receivedAt
      }
    }
    pageInfo {
      hasNextPage
      endCursor
    }
  }
}
```

### Using Variables for Flexible Queries

```graphql
query GetRewardShares($first: Int!) {
  mobile: mobileRewardShares(first: $first) {
    edges {
      node {
        hotspotKey
        amount
        rewardType
      }
    }
  }
  iot: iotRewardShares(first: $first) {
    edges {
      node {
        hotspotKey
        amount
        rewardType
      }
    }
  }
}
```

Variables:

```json
{
  "first": 5
}
```

## Tips for Common Use Cases

1. **Pagination Best Practices**:

   - Always use cursor-based pagination
   - Store the `endCursor` for subsequent requests
   - Check `hasNextPage` to determine if more data is available

2. **Error Handling**:

   - Check for null values in responses
   - Implement retry logic for failed requests
   - Log error responses

3. **Performance Optimization**:

   - Request only needed fields
   - Use appropriate page sizes
   - Cache results when possible

4. **Data Analysis**:
   - Aggregate reward data across time periods
   - Track beacon and witness patterns
   - Monitor reward distribution
