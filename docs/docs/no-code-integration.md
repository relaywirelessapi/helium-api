---
sidebar_position: 5
title: No-Code Integrations
---

# Using the Helium API Without Code

You don't need to be a developer to use the Helium API! This guide shows you how to integrate with popular no-code tools.

## Zapier Integration

### Setting Up Zapier

1. Sign up for a Zapier account at [zapier.com](https://zapier.com)
2. Create a new Zap
3. Search for "Webhooks by Zapier" as your trigger or action
4. Select "Custom Request" as your action type

### Common Zapier Recipes

#### 1. Monitor IoT Beacon Reports

**Trigger**: Schedule (Every hour)
**Action**: Webhook to fetch recent beacon reports

Configuration:

```
URL: https://api.helium.io/graphql
Method: POST
Headers:
  - Content-Type: application/json
  - Authorization: Bearer YOUR_API_KEY
Body:
{
  "query": "{ iotBeaconIngestReports(first: 10, after: null) { nodes { hotspotKey receivedAt frequency dataRate } pageInfo { hasNextPage endCursor } } }"
}
```

For handling large datasets, use Zapier's "Do While" loop:

1. Set up a "Do While" loop after your webhook
2. Check `data.iotBeaconIngestReports.pageInfo.hasNextPage`
3. Update the cursor using `data.iotBeaconIngestReports.pageInfo.endCursor`
4. Store accumulated results in Zapier Storage or external database

#### 2. Track IoT Rewards

**Trigger**: Schedule (Daily)
**Action**: Webhook to fetch rewards with pagination

Configuration:

```
URL: https://api.helium.io/graphql
Method: POST
Headers:
  - Content-Type: application/json
  - Authorization: Bearer YOUR_API_KEY
Body:
{
  "query": "{ iotRewardShares(first: 100, after: null) { nodes { amount hotspotKey startPeriod endPeriod } pageInfo { hasNextPage endCursor } } }"
}
```

### Zapier Tips

1. Use "Formatter by Zapier" to process JSON responses
2. Set up error notifications using "Email by Zapier"
3. Store results in Google Sheets or Airtable
4. Use delay steps to respect rate limits
5. For paginated data, use Storage by Zapier to accumulate results across pages

## Make.com (Formerly Integromat)

### Basic Setup

1. Create a new scenario
2. Add an HTTP module
3. Configure GraphQL request:
   - Method: POST
   - URL: https://api.helium.io/graphql
   - Headers: Add Authorization and Content-Type
   - Body: Your GraphQL query

### Example Scenarios

#### Monitor Multiple IoT Witnesses

1. **Schedule Trigger** (Every 6 hours)
2. **HTTP Request** (GraphQL query for witness reports):

```json
{
  "query": "{ iotWitnessIngestReports(first: 20, after: null) { nodes { hotspotKey receivedAt signal snr } pageInfo { hasNextPage endCursor } } }"
}
```

3. **Iterator** module to handle pagination:
   - Add a Router after the HTTP Request
   - In one route, process current page data
   - In another route, make next HTTP request with `endCursor`
4. **Array Aggregator** to collect results
5. **Google Sheets** to log data

#### Track Mobile Rewards

1. **HTTP Request** with pagination:

```json
{
  "query": "{ mobileRewardShares(first: 100, after: null) { nodes { amount hotspotKey startPeriod endPeriod } pageInfo { hasNextPage endCursor } } }"
}
```

2. **Iterator** to process pages
3. **Filter** to check rewards threshold
4. **Telegram** or **Email** for notifications

## Airtable Automation

### Setting Up Airtable

1. Create a new base
2. Add an Automation
3. Use "Run a script" action
4. Configure HTTP request with pagination support:

```javascript
// Airtable Script with pagination
let hasNextPage = true;
let cursor = null;
let allResults = [];

while (hasNextPage) {
  let response = await fetch("https://api.helium.io/graphql", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: "Bearer YOUR_API_KEY",
    },
    body: JSON.stringify({
      query: `{
        iotRewardShares(first: 100, after: ${cursor ? `"${cursor}"` : null}) {
          nodes {
            hotspotKey
            amount
            startPeriod
            endPeriod
            beaconAmount
            witnessAmount
          }
          pageInfo {
            hasNextPage
            endCursor
          }
        }
      }`,
    }),
  });

  let data = await response.json();
  allResults = allResults.concat(data.data.iotRewardShares.nodes);
  hasNextPage = data.data.iotRewardShares.pageInfo.hasNextPage;
  cursor = data.data.iotRewardShares.pageInfo.endCursor;

  // Add delay to respect rate limits
  await new Promise((resolve) => setTimeout(resolve, 1000));
}

output.set("data", allResults);
```

## Google Sheets Integration

### Using Apps Script

1. Open your Google Sheet
2. Go to Extensions > Apps Script
3. Add this function with pagination support:

```javascript
function fetchAllHeliumData() {
  var allRewards = [];
  var hasNextPage = true;
  var cursor = null;

  while (hasNextPage) {
    var options = {
      method: "post",
      headers: {
        "Content-Type": "application/json",
        Authorization: "Bearer YOUR_API_KEY",
      },
      payload: JSON.stringify({
        query: `{
          status
          mobileRewardShares(first: 100, after: ${
            cursor ? `"${cursor}"` : null
          }) {
            nodes {
              amount
              hotspotKey
              startPeriod
              endPeriod
            }
            pageInfo {
              hasNextPage
              endCursor
            }
          }
        }`,
      }),
    };

    var response = UrlFetchApp.fetch("https://api.helium.io/graphql", options);
    var data = JSON.parse(response.getContentText());

    allRewards = allRewards.concat(data.data.mobileRewardShares.nodes);
    hasNextPage = data.data.mobileRewardShares.pageInfo.hasNextPage;
    cursor = data.data.mobileRewardShares.pageInfo.endCursor;

    // Add delay to respect rate limits
    Utilities.sleep(1000);
  }

  // Write all data to sheet
  var sheet = SpreadsheetApp.getActiveSheet();
  sheet.getRange("A1").setValue(new Date());
  sheet.getRange("B1").setValue(data.data.status);

  allRewards.forEach((reward, index) => {
    sheet.getRange(index + 2, 1).setValue(reward.hotspotKey);
    sheet.getRange(index + 2, 2).setValue(reward.amount);
    sheet.getRange(index + 2, 3).setValue(reward.startPeriod);
  });
}
```

### Setting Up Triggers

1. In Apps Script, go to Triggers
2. Create a new trigger:
   - Choose the function
   - Set time-based trigger
   - Select frequency
   - Consider longer intervals for paginated queries

## IFTTT Integration

### Creating an IFTTT Applet

1. Create new applet
2. Choose "Webhooks" as service
3. Configure webhook:
   - URL: https://api.helium.io/graphql
   - Method: POST
   - Content Type: application/json
   - Body: Your GraphQL query

### Example IFTTT Recipes

1. **Daily Reward Summary**:

   - Trigger: Time of day
   - Action: Webhook to fetch rewards
   - Action: Send email with results

   Note: Since IFTTT doesn't support native pagination, consider:

   - Using date-based filtering instead of cursor pagination
   - Creating multiple applets for different data ranges
   - Using a middleware service for handling pagination

2. **Status Change Alert**:
   - Trigger: Webhook (status check)
   - Action: Send notification
   - Action: Log to Google Sheet
