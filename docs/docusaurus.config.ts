import { themes as prismThemes } from "prism-react-renderer";
import type { Config } from "@docusaurus/types";
import type * as Preset from "@docusaurus/preset-classic";
import type { ScalarOptions } from "@scalar/docusaurus";

// This runs in Node.js - Don't use client-side code here (browser APIs, JSX...)

const config: Config = {
  title: "Relay API",
  url: "https://api.relaywireless.com",
  baseUrl: "/",
  onBrokenLinks: "throw",
  onBrokenMarkdownLinks: "warn",
  favicon: "img/logo.svg",
  i18n: {
    defaultLocale: "en",
    locales: ["en"],
  },

  presets: [
    [
      "classic",
      {
        docs: {
          sidebarPath: "./sidebars.ts",
          routeBasePath: "/",
        },
        blog: false,
        theme: {
          customCss: "./src/css/custom.css",
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    navbar: {
      title: "Relay API",
      logo: {
        alt: "Relay API Logo",
        src: "img/logo.svg",
      },
      items: [
        {
          to: "/graphql",
          label: "GraphQL API",
          position: "left",
        },
        {
          to: "/rest",
          label: "REST API",
          position: "left",
        },
      ],
    },
    footer: {
      style: "dark",
      links: [],
      copyright: `Copyright © ${new Date().getFullYear()} Relay International, Inc.`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
    },
    colorMode: {
      defaultMode: "light",
      respectPrefersColorScheme: true,
    },
    algolia: {
      appId: "494RXN3JUG",
      apiKey: "9fdb002caa4cbd417dcfc31c0ea66b36",
      indexName: "relaywireless",
      contextualSearch: true,
      searchPagePath: "search",
      insights: true,
    },
  } satisfies Preset.ThemeConfig,

  plugins: [
    [
      "@graphql-markdown/docusaurus",
      /** @type {import('@graphql-markdown/types').ConfigOptions} */
      {
        schema: "./graphql/schema.graphql",
        homepage: "./graphql/index.md",
        rootPath: "./docs",
        baseURL: "graphql/schema",
        loaders: {
          GraphQLFileLoader: "@graphql-tools/graphql-file-loader",
        },
      },
    ],
    [
      "@scalar/docusaurus",
      {
        label: "REST API",
        route: "/rest",
        showNavLink: false,
        configuration: {
          hideSearch: true,
          url: "/openapi.yaml",
        },
      } as ScalarOptions,
    ],
  ],
};

export default config;
