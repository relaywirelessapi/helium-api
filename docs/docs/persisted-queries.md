---
sidebar_position: 4
title: Persisted Queries
---

# Persisted Queries

This document outlines the available persisted queries in the Helium API.

Persisted queries are pre-defined GraphQL queries that can be executed by their ID, providing a more efficient and user-friendly way to query the API.

## Usage

To use a persisted query, make a GET request to the API in the following format:

```
GET /graphql/[QUERY_ID]
```

All parameters should be provided as query parameters in the request URL.

## Available Queries

### IOT Reward Shares

**Query ID:** `iot-reward-shares`

This query retrieves IOT reward share information for a given time period and hotspot.

#### Parameters

| Parameter     | Type            | Description                 |
| ------------- | --------------- | --------------------------- |
| `startPeriod` | ISO8601DateTime | Start of the time period    |
| `endPeriod`   | ISO8601DateTime | End of the time period      |
| `hotspotKey`  | String          | Optional hotspot identifier |
| `first`       | Int             | Number of results to return |
| `after`       | String          | Cursor for pagination       |

#### Sample Response

```json
{
  "data": {
    "iotRewardShares": {
      "edges": [
        {
          "node": {
            "amount": "100",
            "beaconAmount": "50",
            "witnessAmount": "30",
            "dcTransferAmount": "20",
            "rewardType": "iot",
            "unallocatedRewardType": "none",
            "startPeriod": "2024-01-01T00:00:00Z",
            "endPeriod": "2024-01-04T00:00:00Z",
            "hotspotKey": "11aBcDeFgHiJkLmNoPqRsTuVwXyZ123456"
          }
        }
      ]
    }
  }
}
```

### Mobile Reward Shares

**Query ID:** `mobile-reward-shares`

This query retrieves Mobile reward share information for a given time period and hotspot.

#### Parameters

| Parameter     | Type            | Description                 |
| ------------- | --------------- | --------------------------- |
| `startPeriod` | ISO8601DateTime | Start of the time period    |
| `endPeriod`   | ISO8601DateTime | End of the time period      |
| `hotspotKey`  | String          | Optional hotspot identifier |
| `first`       | Int             | Number of results to return |
| `after`       | String          | Cursor for pagination       |

#### Sample Response

```json
{
  "data": {
    "mobileRewardShares": {
      "edges": [
        {
          "node": {
            "amount": "200",
            "baseCoveragePointsSum": 150.5,
            "basePocReward": "100",
            "baseRewardShares": 1.5,
            "boostedCoveragePointsSum": 200.5,
            "boostedPocReward": "150",
            "boostedRewardShares": 2.0,
            "cbsdId": "CBSD123",
            "dcTransferReward": "50",
            "discoveryLocationAmount": "30",
            "endPeriod": "2024-01-04T00:00:00Z",
            "entity": "entity123",
            "hotspotKey": "11aBcDeFgHiJkLmNoPqRsTuVwXyZ123456",
            "locationTrustScoreMultiplier": 1.2,
            "matchedAmount": "180",
            "oracleBoostedHexStatus": 1,
            "ownerKey": "owner123",
            "pocReward": "120",
            "rewardType": "mobile",
            "seniorityTimestamp": "1234567890",
            "serviceProviderAmount": "40",
            "serviceProviderId": "SP123",
            "spBoostedHexStatus": 1,
            "speedtestMultiplier": 1.1,
            "startPeriod": "2024-01-01T00:00:00Z",
            "subscriberId": "SUB123",
            "subscriberReward": "60",
            "unallocatedRewardType": "none"
          }
        }
      ]
    }
  }
}
```
