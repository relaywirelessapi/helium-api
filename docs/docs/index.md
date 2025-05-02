---
sidebar_position: 1
slug: /
title: Introduction
---

# Introduction

Relay API is an easy-to-use, open-source GraphQL API for [Helium Oracle data](https://docs.helium.com/oracles/). It enables you to fetch data from Helium Oracles within seconds, eliminating the complexity of extracting data from AWS S3 buckets.

:::caution Relay API is currently in beta
During this phase, you may encounter some issues, bugs, or imperfections. We welcome your feedback in our official Helium Discord channel.
:::

## Use Cases

During the Beta phase, Relay API primarily provides access to Helium Network hotspot data, including `earnings` (HNT, IOT, and MOBILE) and hotspot `activity`. With Relay API, you can:

- Sync hotspot rewards including HNT, IOT, MOBILE [See how](./endpoints)
- Retrieve IoT and Mobile individual reward shares [See how](./endpoints)
- Access IoT hotspot activity including beacon and witness ingest reports [See how](./endpoints)
- Monitor hotspot network status [See how](./endpoints)
- Query Helium historical earnings data [See how](./endpoints)

:::info
The Relay team is actively expanding the API's capabilities. For more information about our development roadmap, [visit our website](https://relaywireless.com).
:::

## About GraphQL

Relay API is built on GraphQL — the modern standard for flexible, high-performance APIs. It combines GraphQL's power with familiar REST-style endpoints, allowing both developers and non-technical users to retrieve exactly the data they need, efficiently and simply.

Couple of key advantages of the GraphQL:
1. **Flexibility**: GraphQL allows you to request exactly the data you need, nothing more and nothing less.
2. **Strong Typing**: The schema provides clear contracts about available data and operations.
3. **Efficient Data Loading**: Reduce over-fetching and under-fetching of data common in REST APIs.
4. **Developer Experience**: Better tooling, introspection, and documentation capabilities.

GraphQL travels the same HTTP routes as REST, but gives you far more control. Using endpoints (persistent queries) — pre-defined calls you invoke by ID — you keep the convenience of familiar endpoints while gaining GraphQL’s precision and efficiency in a single request.

Learn more about [GraphQL](https://graphql.org/learn/).

Learn more about [Relay Endpoints](./endpoints).

## Open Source

Relay API is open-source. The backend code will be published under the Relay GitHub organization and made publicly accessible for review, feedback, contributions, and independent development. The API will be open-sourced after the Beta phase, at the time of the public launch.

### Sponsored by Helium Foundation

Relay API was built in partnership with the Helium Foundation. The Foundation awarded a grant to Relay to make Helium Oracle data more accessible to the community—removing the need to interact directly with AWS S3 and its complexities.

## Support

If you need help or have questions about the API:

1. Check our documentation for guides and examples
2. Explore the GraphQL schema using introspection [(learn more here)](./quick-start#tools-and-resources)
3. Chat with our team and community in our official Discord channel
