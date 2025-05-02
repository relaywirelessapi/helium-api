---
title: Data Credits
---

# Understanding Data Credits

Data credits are the foundation of our API's usage model. This guide explains how they work, how they're calculated, and how to manage them effectively.

## What Are Data Credits?

Data credits are the unit of measurement for API usage. They represent the computational and network resources required to fulfill your API requests.

## Credit Calculation

Credits in our API are calculated using GraphQL Ruby's built-in complexity analysis system. Each field in a query contributes to the overall complexity score based on its type:

### Field Complexity Rules

1. **Leaf Fields**: Fields that return scalar values (like String, Integer, etc.)

   - Cost: 0 credits
   - Example: `hotspotKey`, `signature`, `frequency`

2. **Composite Fields**: Fields that return object types

   - Cost: 1 credit
   - Example: `nodes` in connections, root query fields

3. **Connection Fields**: Fields that implement the Relay connection pattern
   - Cost: Number of children × Input size (e.g., `first`/`last` argument)
   - Example: `iotBeaconIngestReports`, `mobileRewardShares`

### Example Query Costs

```graphql
query {
  iotBeaconIngestReports(first: 5) {
    # +(3 × 5) (connection with 3 child fields)
    edges {
      node {
        hotspotKey # child 1 (leaf: +0)
        frequency # child 2 (leaf: +0)
        dataRate # child 3 (leaf: +0)
      }
    }
  }
  mobileRewardShares(first: 10) {
    # +(4 × 10) (connection with 4 child fields)
    nodes {
      hotspotKey # child 1 (leaf: +0)
      amount # child 2 (leaf: +0)
      rewardType # child 3 (leaf: +0)
      startPeriod # child 4 (leaf: +0)
    }
  }
}
```

Total cost for this query: 55 credits

- 15 credits for `iotBeaconIngestReports` connection (3 children × 5 items)
- 40 credits for `mobileRewardShares` connection (4 children × 10 items)
