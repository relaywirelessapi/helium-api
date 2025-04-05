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

### Get Mobile Reward Shares

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
  iotRewardShares(
    first: 5
    after: "cursor_value"
    startPeriod: "2024-01-01T00:00:00Z"
    endPeriod: "2024-01-31T23:59:59Z"
  ) {
    nodes {
      hotspotKey
      amount
      startPeriod
      endPeriod
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
query GetRewardShares(
  $first: Int!
  $startPeriod: ISO8601DateTime!
  $endPeriod: ISO8601DateTime!
) {
  mobile: mobileRewardShares(
    first: $first
    startPeriod: $startPeriod
    endPeriod: $endPeriod
  ) {
    nodes {
      hotspotKey
      amount
      rewardType
    }
    pageInfo {
      hasNextPage
      endCursor
    }
  }
  iot: iotRewardShares(
    first: $first
    startPeriod: $startPeriod
    endPeriod: $endPeriod
  ) {
    nodes {
      hotspotKey
      amount
      rewardType
    }
    pageInfo {
      hasNextPage
      endCursor
    }
  }
}
```

Variables:

```json
{
  "first": 5,
  "startPeriod": "2024-01-01T00:00:00Z",
  "endPeriod": "2024-01-31T23:59:59Z"
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
   - Track reward distribution patterns
   - Monitor reward types and amounts
