module.exports = {
  build: {
    "index.html": "index.html",
    "app.js": [
      "javascripts/app.js"
    ],
    "app.css": [
      "stylesheets/app.css"
    ],
    "images/": "images/"
  },
  deploy: [
    "Aviary",
    "Canary",
    "CanaryDb",
    "Permissions",
    "PermissionsDb",
    "Tlc"
  ],
  rpc: {
    host: "localhost",
    port: 8545
  }
};
