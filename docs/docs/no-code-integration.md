---
title: No-Code Integrations
---

# No-Code Integration

You don't need to be a developer to use the Relay Helium API! This guide will show you how to integrate with popular no-code tools.

## Zapier Integration

### Setting Up Zapier

1. Sign up for a Zapier account at [zapier.com](https://zapier.com)
2. Create a new Zap
3. Search for "Webhooks by Zapier" as your trigger or action step
4. Select "Custom Request" as your **action** type

:::caution
To use "Custom Request" in "Webhooks by Zapier", make sure you set it as **action** and not a trigger. Learn more about Webhooks by Zapier in [Zapier's official guide](https://zapier.com/apps/webhook/integrations)
:::

### Common Zapier Examples

#### Track IoT Rewards

**Trigger**: Schedule (Daily)
**Action**: Webhook to fetch rewards

Configuration:

```
URL: https://api.relaywireless.com/graphql/iot-reward-shares
Method: GET
Headers:
  - Authorization: Bearer YOUR_API_KEY
  - Accept: application/json
Params:
  hotspotKey = {Hotspot ECC key}
  startPeriod = {YYYY‑MM‑DD}
  endPeriod = {YYYY‑MM‑DD}
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
   - URL: https://api.relaywireless.com/graphql
   - Headers: Add Authorization and Content-Type
   - Body: Your GraphQL query

### Example Scenarios

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
  let response = await fetch("https://api.relaywireless.com/graphql", {
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

    var response = UrlFetchApp.fetch(
      "https://api.relaywireless.com/graphql",
      options
    );
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
   - URL: https://api.relaywireless.com/graphql
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
