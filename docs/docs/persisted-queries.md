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

| Parameter     | Type            | Required | Description                              |
| ------------- | --------------- | -------- | ---------------------------------------- |
| `startPeriod` | ISO8601DateTime | Yes      | Start of the time period                 |
| `endPeriod`   | ISO8601DateTime | Yes      | End of the time period                   |
| `hotspotKey`  | String          | No       | Optional hotspot identifier              |
| `rewardType`  | String          | No       | Optional reward type filter              |
| `first`       | Int             | No       | Number of results to return              |
| `last`        | Int             | No       | Number of results to return from the end |
| `after`       | String          | No       | Cursor for forward pagination            |
| `before`      | String          | No       | Cursor for backward pagination           |

#### Sample Response

```json
{
  "data": {
    "iotRewardShares": {
      "nodes": [
        {
          "id": "123",
          "startPeriod": "2024-01-01T00:00:00Z",
          "endPeriod": "2024-01-04T00:00:00Z",
          "rewardType": "iot",
          "unallocatedRewardType": "none",
          "amount": "100",
          "hotspotKey": "11aBcDeFgHiJkLmNoPqRsTuVwXyZ123456",
          "beaconAmount": "50",
          "witnessAmount": "30",
          "dcTransferAmount": "20",
          "manifest": {
            "id": "manifest123",
            "writtenFiles": ["file1", "file2"],
            "startTimestamp": "2024-01-01T00:00:00Z",
            "endTimestamp": "2024-01-04T00:00:00Z",
            "rewardData": {
              "rewardType": "iot",
              "pocBonesPerBeaconRewardShare": "100",
              "pocBonesPerWitnessRewardShare": "50",
              "dcBonesPerShare": "20",
              "token": "IOT"
            },
            "epoch": 123,
            "price": "1.23"
          }
        }
      ],
      "pageInfo": {
        "hasNextPage": true,
        "hasPreviousPage": false,
        "startCursor": "cursor123",
        "endCursor": "cursor456"
      }
    }
  }
}
```

### Mobile Reward Shares

**Query ID:** `mobile-reward-shares`

This query retrieves Mobile reward share information for a given time period and hotspot.

#### Parameters

| Parameter     | Type            | Required | Description                              |
| ------------- | --------------- | -------- | ---------------------------------------- |
| `startPeriod` | ISO8601DateTime | Yes      | Start of the time period                 |
| `endPeriod`   | ISO8601DateTime | Yes      | End of the time period                   |
| `hotspotKey`  | String          | No       | Optional hotspot identifier              |
| `rewardType`  | String          | No       | Optional reward type filter              |
| `first`       | Int             | No       | Number of results to return              |
| `last`        | Int             | No       | Number of results to return from the end |
| `after`       | String          | No       | Cursor for forward pagination            |
| `before`      | String          | No       | Cursor for backward pagination           |

#### Sample Response

```json
{
  "data": {
    "mobileRewardShares": {
      "nodes": [
        {
          "id": "123",
          "ownerKey": "owner123",
          "hotspotKey": "11aBcDeFgHiJkLmNoPqRsTuVwXyZ123456",
          "cbsdId": "CBSD123",
          "amount": "200",
          "startPeriod": "2024-01-01T00:00:00Z",
          "endPeriod": "2024-01-04T00:00:00Z",
          "rewardType": "mobile",
          "dcTransferReward": "50",
          "pocReward": "120",
          "subscriberId": "SUB123",
          "subscriberReward": "60",
          "discoveryLocationAmount": "30",
          "unallocatedRewardType": "none",
          "serviceProviderId": "SP123",
          "baseCoveragePointsSum": 150.5,
          "boostedCoveragePointsSum": 200.5,
          "baseRewardShares": 1.5,
          "boostedRewardShares": 2.0,
          "basePocReward": "100",
          "boostedPocReward": "150",
          "coverageObject": "coverage123",
          "seniorityTimestamp": "1234567890",
          "locationTrustScoreMultiplier": 1.2,
          "speedtestMultiplier": 1.1,
          "spBoostedHexStatus": "1",
          "oracleBoostedHexStatus": "1",
          "entity": "entity123",
          "serviceProviderAmount": "40",
          "matchedAmount": "180",
          "manifest": {
            "id": "manifest123",
            "writtenFiles": ["file1", "file2"],
            "startTimestamp": "2024-01-01T00:00:00Z",
            "endTimestamp": "2024-01-04T00:00:00Z",
            "rewardData": {
              "rewardType": "mobile",
              "pocBonesPerRewardShare": "100",
              "boostedPocBonesPerRewardShare": "150",
              "serviceProviderPromotions": [
                {
                  "serviceProvider": "SP123",
                  "incentiveEscrowFundBps": 100,
                  "promotions": [
                    {
                      "entity": "entity123",
                      "startTs": "2024-01-01T00:00:00Z",
                      "endTs": "2024-01-04T00:00:00Z",
                      "shares": 1.5
                    }
                  ]
                }
              ],
              "token": "MOBILE"
            },
            "epoch": 123,
            "price": "1.23"
          }
        }
      ],
      "pageInfo": {
        "hasNextPage": true,
        "hasPreviousPage": false,
        "startCursor": "cursor123",
        "endCursor": "cursor456"
      }
    }
  }
}
```

### Reward Manifests

**Query ID:** `reward-manifests`

This query retrieves reward manifest information for a given time period.

#### Parameters

| Parameter        | Type            | Required | Description                              |
| ---------------- | --------------- | -------- | ---------------------------------------- |
| `startTimestamp` | ISO8601DateTime | Yes      | Start of the time period                 |
| `endTimestamp`   | ISO8601DateTime | Yes      | End of the time period                   |
| `first`          | Int             | No       | Number of results to return              |
| `last`           | Int             | No       | Number of results to return from the end |
| `after`          | String          | No       | Cursor for forward pagination            |
| `before`         | String          | No       | Cursor for backward pagination           |

#### Sample Response

```json
{
  "data": {
    "rewardManifests": {
      "nodes": [
        {
          "id": "manifest123",
          "writtenFiles": ["file1", "file2"],
          "startTimestamp": "2024-01-01T00:00:00Z",
          "endTimestamp": "2024-01-04T00:00:00Z",
          "rewardData": {
            "rewardType": "mobile",
            "pocBonesPerRewardShare": "100",
            "boostedPocBonesPerRewardShare": "150",
            "serviceProviderPromotions": [
              {
                "serviceProvider": "SP123",
                "incentiveEscrowFundBps": 100,
                "promotions": [
                  {
                    "entity": "entity123",
                    "startTs": "2024-01-01T00:00:00Z",
                    "endTs": "2024-01-04T00:00:00Z",
                    "shares": 1.5
                  }
                ]
              }
            ],
            "token": "MOBILE"
          },
          "epoch": 123,
          "price": "1.23"
        }
      ],
      "pageInfo": {
        "hasNextPage": true,
        "hasPreviousPage": false,
        "startCursor": "cursor123",
        "endCursor": "cursor456"
      }
    }
  }
}
```
