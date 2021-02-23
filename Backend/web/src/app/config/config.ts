let ipAddress = localStorage.getItem("ipAddress");
let port = localStorage.getItem("port");
let url = `http://${window.location.hostname}/api`;
if (ipAddress && port) url = "http://" + ipAddress + ":" + port + "/api";
const dev = {
  api: {
    URL: url
  }
};

const prod = {
  api: {
    URL: url
  }
};

const config = process.env.NODE_ENV === "production" ? prod : dev;
export default {
  // Add common config values here
  MAX_ATTACHMENT_SIZE: 5000000,
  ...config
};
