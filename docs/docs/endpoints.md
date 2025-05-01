---
sidebar_position: 4
title: Endpoints
---

# Endpoints

GraphQL Endpoints, also know as persisted queries are pre-defined GraphQL queries that can be executed by their ID, providing a more efficient and user-friendly way to query the API.

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

#### Response Sample

```json
{
  "data": {
    "iotRewardShares": {
      "nodes": [
        {
          "id": "iot-reward-share-123",
          "rewardType": "gateway_reward",
          "startPeriod": "2024-03-01T00:00:00Z",
          "endPeriod": "2024-03-01T23:59:59Z",
          "manifest": {
            "id": "manifest-456",
            "writtenFiles": ["file1.json", "file2.json"],
            "startTimestamp": "2024-03-01T00:00:00Z",
            "endTimestamp": "2024-03-01T23:59:59Z",
            "rewardData": {
              "rewardType": "iot",
              "pocBonesPerBeaconRewardShare": "1000000",
              "pocBonesPerWitnessRewardShare": "500000",
              "dcBonesPerShare": "250000",
              "token": "IOT"
            },
            "epoch": 123456,
            "price": "5000000000"
          },
          "rewardDetail": {
            "hotspotKey": "11aabbccddeeff",
            "beaconAmount": "1000000",
            "witnessAmount": "500000",
            "dcTransferAmount": "250000",
            "formattedBeaconAmount": "1.000000",
            "formattedWitnessAmount": "0.500000",
            "formattedDcTransferAmount": "0.250000"
          }
        },
        {
          "id": "iot-reward-share-124",
          "rewardType": "operational_reward",
          "startPeriod": "2024-03-01T00:00:00Z",
          "endPeriod": "2024-03-01T23:59:59Z",
          "manifest": {
            "id": "manifest-457",
            "writtenFiles": ["file3.json"],
            "startTimestamp": "2024-03-01T00:00:00Z",
            "endTimestamp": "2024-03-01T23:59:59Z",
            "rewardData": {
              "rewardType": "iot",
              "pocBonesPerBeaconRewardShare": "1000000",
              "pocBonesPerWitnessRewardShare": "500000",
              "dcBonesPerShare": "250000",
              "token": "IOT"
            },
            "epoch": 123456,
            "price": "5000000000"
          },
          "rewardDetail": {
            "amount": "750000",
            "formattedAmount": "0.750000"
          }
        },
        {
          "id": "iot-reward-share-125",
          "rewardType": "unallocated_reward",
          "startPeriod": "2024-03-01T00:00:00Z",
          "endPeriod": "2024-03-01T23:59:59Z",
          "manifest": {
            "id": "manifest-458",
            "writtenFiles": ["file4.json"],
            "startTimestamp": "2024-03-01T00:00:00Z",
            "endTimestamp": "2024-03-01T23:59:59Z",
            "rewardData": {
              "rewardType": "iot",
              "pocBonesPerBeaconRewardShare": "1000000",
              "pocBonesPerWitnessRewardShare": "500000",
              "dcBonesPerShare": "250000",
              "token": "IOT"
            },
            "epoch": 123456,
            "price": "5000000000"
          },
          "rewardDetail": {
            "amount": "300000",
            "formattedAmount": "0.300000",
            "unallocatedRewardType": "excess"
          }
        }
      ],
      "pageInfo": {
        "hasNextPage": true,
        "hasPreviousPage": false,
        "startCursor": "cursor1",
        "endCursor": "cursor2"
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

#### Response Sample

```json
{
  "data": {
    "mobileRewardShares": {
      "nodes": [
        {
          "id": "mobile-reward-share-789",
          "rewardType": "radio_reward_v2",
          "startPeriod": "2024-03-01T00:00:00Z",
          "endPeriod": "2024-03-01T23:59:59Z",
          "manifest": {
            "id": "manifest-789",
            "writtenFiles": ["mobile-file1.json", "mobile-file2.json"],
            "startTimestamp": "2024-03-01T00:00:00Z",
            "endTimestamp": "2024-03-01T23:59:59Z",
            "rewardData": {
              "rewardType": "mobile",
              "pocBonesPerRewardShare": "2000000",
              "boostedPocBonesPerRewardShare": "3000000",
              "serviceProviderPromotions": [
                {
                  "serviceProvider": "provider1",
                  "incentiveEscrowFundBps": "1000",
                  "promotions": [
                    {
                      "entity": "entity1",
                      "startTs": "2024-03-01T00:00:00Z",
                      "endTs": "2024-03-31T23:59:59Z",
                      "shares": "500000"
                    }
                  ]
                }
              ],
              "token": "MOBILE"
            },
            "epoch": 123457,
            "price": "6000000000"
          },
          "rewardDetail": {
            "hotspotKey": "22aabbccddeeff",
            "cbsdId": "cbsd-123",
            "baseCoveragePointsSum": 150.5,
            "boostedCoveragePointsSum": 200.75,
            "baseRewardShares": 100.25,
            "boostedRewardShares": 150.5,
            "basePocReward": "1500000",
            "boostedPocReward": "2000000",
            "seniorityTimestamp": "2023-01-01T00:00:00Z",
            "coverageObject": "hex-123",
            "locationTrustScoreMultiplier": 1.2,
            "speedtestMultiplier": 1.1,
            "spBoostedHexStatus": "active",
            "oracleBoostedHexStatus": "active",
            "dcTransferReward": "1000000",
            "formattedDcTransferReward": "1.000000",
            "pocReward": "2000000",
            "formattedPocReward": "2.000000"
          }
        },
        {
          "id": "mobile-reward-share-790",
          "rewardType": "gateway_reward",
          "startPeriod": "2024-03-01T00:00:00Z",
          "endPeriod": "2024-03-01T23:59:59Z",
          "manifest": {
            "id": "manifest-790",
            "writtenFiles": ["mobile-file3.json"],
            "startTimestamp": "2024-03-01T00:00:00Z",
            "endTimestamp": "2024-03-01T23:59:59Z",
            "rewardData": {
              "rewardType": "mobile",
              "pocBonesPerRewardShare": "2000000",
              "boostedPocBonesPerRewardShare": "3000000",
              "serviceProviderPromotions": [],
              "token": "MOBILE"
            },
            "epoch": 123457,
            "price": "6000000000"
          },
          "rewardDetail": {
            "hotspotKey": "33aabbccddeeff",
            "dcTransferReward": "1000000",
            "formattedDcTransferReward": "1.000000"
          }
        },
        {
          "id": "mobile-reward-share-791",
          "rewardType": "promotion_reward",
          "startPeriod": "2024-03-01T00:00:00Z",
          "endPeriod": "2024-03-01T23:59:59Z",
          "manifest": {
            "id": "manifest-791",
            "writtenFiles": ["mobile-file4.json"],
            "startTimestamp": "2024-03-01T00:00:00Z",
            "endTimestamp": "2024-03-01T23:59:59Z",
            "rewardData": {
              "rewardType": "mobile",
              "pocBonesPerRewardShare": "2000000",
              "boostedPocBonesPerRewardShare": "3000000",
              "serviceProviderPromotions": [],
              "token": "MOBILE"
            },
            "epoch": 123457,
            "price": "6000000000"
          },
          "rewardDetail": {
            "entity": "entity2",
            "matchedAmount": "500000",
            "serviceProviderAmount": "750000"
          }
        },
        {
          "id": "mobile-reward-share-792",
          "rewardType": "radio_reward",
          "startPeriod": "2024-03-01T00:00:00Z",
          "endPeriod": "2024-03-01T23:59:59Z",
          "manifest": {
            "id": "manifest-792",
            "writtenFiles": ["mobile-file5.json"],
            "startTimestamp": "2024-03-01T00:00:00Z",
            "endTimestamp": "2024-03-01T23:59:59Z",
            "rewardData": {
              "rewardType": "mobile",
              "pocBonesPerRewardShare": "2000000",
              "boostedPocBonesPerRewardShare": "3000000",
              "serviceProviderPromotions": [],
              "token": "MOBILE"
            },
            "epoch": 123457,
            "price": "6000000000"
          },
          "rewardDetail": {
            "hotspotKey": "44aabbccddeeff",
            "cbsdId": "cbsd-124",
            "dcTransferReward": "1000000",
            "pocReward": "2000000"
          }
        },
        {
          "id": "mobile-reward-share-793",
          "rewardType": "service_provider_reward",
          "startPeriod": "2024-03-01T00:00:00Z",
          "endPeriod": "2024-03-01T23:59:59Z",
          "manifest": {
            "id": "manifest-793",
            "writtenFiles": ["mobile-file6.json"],
            "startTimestamp": "2024-03-01T00:00:00Z",
            "endTimestamp": "2024-03-01T23:59:59Z",
            "rewardData": {
              "rewardType": "mobile",
              "pocBonesPerRewardShare": "2000000",
              "boostedPocBonesPerRewardShare": "3000000",
              "serviceProviderPromotions": [],
              "token": "MOBILE"
            },
            "epoch": 123457,
            "price": "6000000000"
          },
          "rewardDetail": {
            "serviceProviderId": "provider2",
            "amount": "1500000",
            "formattedAmount": "1.500000"
          }
        },
        {
          "id": "mobile-reward-share-794",
          "rewardType": "subscriber_reward",
          "startPeriod": "2024-03-01T00:00:00Z",
          "endPeriod": "2024-03-01T23:59:59Z",
          "manifest": {
            "id": "manifest-794",
            "writtenFiles": ["mobile-file7.json"],
            "startTimestamp": "2024-03-01T00:00:00Z",
            "endTimestamp": "2024-03-01T23:59:59Z",
            "rewardData": {
              "rewardType": "mobile",
              "pocBonesPerRewardShare": "2000000",
              "boostedPocBonesPerRewardShare": "3000000",
              "serviceProviderPromotions": [],
              "token": "MOBILE"
            },
            "epoch": 123457,
            "price": "6000000000"
          },
          "rewardDetail": {
            "subscriberId": "subscriber1",
            "discoveryLocationAmount": "250000",
            "formattedDiscoveryLocationAmount": "0.250000",
            "formattedSubscriberReward": "0.250000"
          }
        },
        {
          "id": "mobile-reward-share-795",
          "rewardType": "unallocated_reward",
          "startPeriod": "2024-03-01T00:00:00Z",
          "endPeriod": "2024-03-01T23:59:59Z",
          "manifest": {
            "id": "manifest-795",
            "writtenFiles": ["mobile-file8.json"],
            "startTimestamp": "2024-03-01T00:00:00Z",
            "endTimestamp": "2024-03-01T23:59:59Z",
            "rewardData": {
              "rewardType": "mobile",
              "pocBonesPerRewardShare": "2000000",
              "boostedPocBonesPerRewardShare": "3000000",
              "serviceProviderPromotions": [],
              "token": "MOBILE"
            },
            "epoch": 123457,
            "price": "6000000000"
          },
          "rewardDetail": {
            "amount": "100000",
            "formattedAmount": "0.100000",
            "unallocatedRewardType": "excess"
          }
        }
      ],
      "pageInfo": {
        "hasNextPage": true,
        "hasPreviousPage": false,
        "startCursor": "cursor3",
        "endCursor": "cursor4"
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

#### Response Sample

```json
{
  "data": {
    "rewardManifests": {
      "nodes": [
        {
          "id": "manifest-101",
          "writtenFiles": ["manifest-file1.json", "manifest-file2.json"],
          "startTimestamp": "2024-03-01T00:00:00Z",
          "endTimestamp": "2024-03-01T23:59:59Z",
          "rewardData": {
            "rewardType": "mobile",
            "pocBonesPerRewardShare": "2000000",
            "boostedPocBonesPerRewardShare": "3000000",
            "serviceProviderPromotions": [
              {
                "serviceProvider": "provider2",
                "incentiveEscrowFundBps": "1500",
                "promotions": [
                  {
                    "entity": "entity2",
                    "startTs": "2024-03-01T00:00:00Z",
                    "endTs": "2024-03-31T23:59:59Z",
                    "shares": "750000"
                  }
                ]
              }
            ],
            "token": "MOBILE"
          },
          "epoch": 123458,
          "price": "7000000000"
        },
        {
          "id": "manifest-102",
          "writtenFiles": ["manifest-file3.json"],
          "startTimestamp": "2024-03-01T00:00:00Z",
          "endTimestamp": "2024-03-01T23:59:59Z",
          "rewardData": {
            "rewardType": "iot",
            "pocBonesPerBeaconRewardShare": "1000000",
            "pocBonesPerWitnessRewardShare": "500000",
            "dcBonesPerShare": "250000",
            "token": "IOT"
          },
          "epoch": 123459,
          "price": "5000000000"
        }
      ],
      "pageInfo": {
        "hasNextPage": true,
        "hasPreviousPage": false,
        "startCursor": "cursor5",
        "endCursor": "cursor6"
      }
    }
  }
}
```
