import type { SidebarsConfig } from "@docusaurus/plugin-content-docs";

const sidebar: SidebarsConfig = {
  apisidebar: [
    {
      type: "doc",
      id: "api/relay-api",
    },
    {
      type: "category",
      label: "Helium L1",
      link: {
        type: "doc",
        id: "api/helium-l-1",
      },
      collapsible: true,
      collapsed: false,
      items: [
        {
          type: "doc",
          id: "api/get-l-1-accounts",
          label: "List L1 accounts",
          className: "api-method get",
        },
        {
          type: "doc",
          id: "api/get-l-1-account",
          label: "Get L1 account",
          className: "api-method get",
        },
        {
          type: "doc",
          id: "api/get-l-1-transactions",
          label: "List L1 transactions",
          className: "api-method get",
        },
        {
          type: "doc",
          id: "api/get-l-1-transaction",
          label: "Get L1 transaction",
          className: "api-method get",
        },
        {
          type: "doc",
          id: "api/get-l-1-transaction-actors",
          label: "List L1 transaction actors",
          className: "api-method get",
        },
        {
          type: "doc",
          id: "api/get-l-1-dc-burns",
          label: "List L1 DC burns",
          className: "api-method get",
        },
        {
          type: "doc",
          id: "api/get-l-1-gateways",
          label: "List L1 gateways",
          className: "api-method get",
        },
        {
          type: "doc",
          id: "api/get-l-1-gateway",
          label: "Get L1 gateway",
          className: "api-method get",
        },
        {
          type: "doc",
          id: "api/get-l-1-packets",
          label: "List L1 packets",
          className: "api-method get",
        },
        {
          type: "doc",
          id: "api/get-l-1-rewards",
          label: "List L1 rewards",
          className: "api-method get",
        },
      ],
    },
    {
      type: "category",
      label: "Helium L2",
      link: {
        type: "doc",
        id: "api/helium-l-2",
      },
      collapsible: true,
      collapsed: false,
      items: [
        {
          type: "doc",
          id: "api/get-makers",
          label: "List makers",
          className: "api-method get",
        },
        {
          type: "doc",
          id: "api/get-maker",
          label: "Get maker",
          className: "api-method get",
        },
        {
          type: "doc",
          id: "api/get-hotspots",
          label: "List hotspots",
          className: "api-method get",
        },
        {
          type: "doc",
          id: "api/get-hotspot",
          label: "Get hotspot",
          className: "api-method get",
        },
        {
          type: "doc",
          id: "api/get-iot-rewards",
          label: "List IoT rewards",
          className: "api-method get",
        },
        {
          type: "doc",
          id: "api/get-iot-reward-totals",
          label: "Get IoT reward totals",
          className: "api-method get",
        },
        {
          type: "doc",
          id: "api/get-mobile-rewards",
          label: "List Mobile rewards",
          className: "api-method get",
        },
        {
          type: "doc",
          id: "api/get-mobile-reward-totals",
          label: "Get Mobile reward totals",
          className: "api-method get",
        },
      ],
    },
  ],
};

export default sidebar.apisidebar;
