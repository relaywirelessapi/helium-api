import type { SidebarsConfig } from "@docusaurus/plugin-content-docs";
import restSidebar from "./docs/api/sidebar";

// This runs in Node.js - Don't use client-side code here (browser APIs, JSX...)

/**
 * Creating a sidebar enables you to:
 - create an ordered group of docs
 - render a sidebar for each doc of that group
 - provide next/previous navigation

 The sidebars can be generated from the filesystem, or explicitly defined here.

 Create as many sidebars as you want.
 */
const sidebars: SidebarsConfig = {
  basics: [
    {
      type: "doc",
      id: "index",
    },
    {
      type: "doc",
      id: "authentication",
    },
    {
      type: "doc",
      id: "pagination",
    },
    {
      type: "doc",
      id: "error-handling",
    },
    {
      type: "doc",
      id: "usage-limits",
    },
    {
      type: "doc",
      id: "no-code-integrations",
    },
    {
      type: "doc",
      id: "support",
    },
  ],

  // Add the REST API sidebar
  apisidebar: restSidebar,
};

export default sidebars;
