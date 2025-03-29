---
sidebar_position: 1
slug: /
title: Introduction
---

# Introduction

Welcome to the Helium API documentation! This guide will help you understand our API, its capabilities, and how to integrate it into your applications.

## Overview

The Helium API provides access to IoT and Mobile data from the Helium Network. Through our GraphQL API, you can:

- Access IoT beacon and witness ingest reports
- Retrieve IoT and mobile reward shares
- Monitor network status
- Query historical data

## Why GraphQL?

We chose GraphQL for our API for several key reasons:

1. **Flexibility**: GraphQL allows you to request exactly the data you need, nothing more and nothing less.
2. **Strong Typing**: The schema provides clear contracts about available data and operations.
3. **Efficient Data Loading**: Reduce over-fetching and under-fetching of data common in REST APIs.
4. **Developer Experience**: Better tooling, introspection, and documentation capabilities.

## Getting Started

1. **API Endpoint**: The API is accessible at `https://helium-api.relaywireless.com/graphql`
2. **Authentication**: All requests require an API key, passed via the `Authorization: Bearer <API_KEY>` header

## Support

If you need help or have questions about the API:

1. Check our documentation for guides and examples
2. Explore the GraphQL schema using introspection
3. Contact support if you need additional assistance
