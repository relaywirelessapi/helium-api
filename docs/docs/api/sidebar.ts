import type { SidebarsConfig } from "@docusaurus/plugin-content-docs";

const sidebar: SidebarsConfig = {
  apisidebar: [
    {
      type: "doc",
      id: "api/relay-api",
    },
    {
      type: "category",
      label: "Hotspots",
      link: {
        type: "doc",
        id: "api/hotspots",
      },
      collapsible: true,
      collapsed: false,
      items: [
        {
          type: "doc",
          id: "api/get-hotspots",
          label: "List hotspots",
          className: "api-method get",
        },
      ],
    },
    {
      type: "category",
      label: "Makers",
      link: {
        type: "doc",
        id: "api/makers",
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
      ],
    },
    {
      type: "category",
      label: "Rewards",
      link: {
        type: "doc",
        id: "api/rewards",
      },
      collapsible: true,
      collapsed: false,
      items: [
        {
          type: "doc",
          id: "api/get-iot-rewards",
          label: "List IoT rewards",
          className: "api-method get",
        },
        {
          type: "doc",
          id: "api/get-mobile-rewards",
          label: "List Mobile rewards",
          className: "api-method get",
        },
      ],
    },
  ],
};

export default sidebar.apisidebar;
