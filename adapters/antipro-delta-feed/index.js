const express = require("express");
const bodyParser = require("body-parser");
const axios = require("axios");

const app = express();
app.use(bodyParser.json());

app.post("/", async (req, res) => {
  try {
    const antiToken = await axios.get(
      "https://api.dexscreener.com/latest/dex/tokens/HB8KrN7Bb3iLWUPsozp67kS4gxtbA4W5QJX4wKPvpump"
    );
    const proToken = await axios.get(
      "https://api.dexscreener.com/latest/dex/tokens/CWFa2nxUMf5d1WwKtG9FS9kjUKGwKXWSjH8hFdWspump"
    );
    const delta = antiToken.pairs.priceUsd - proToken.pairs.priceUsd;

    res.status(200).json({
      jobRunID: req.body.id,
      data: { delta },
      statusCode: 200,
    });
  } catch (error) {
    res.status(500).json({
      jobRunID: req.body.id,
      status: "errored",
      error: error.message,
    });
  }
});

app.listen(8080, () => console.log("CHAINLINK_ADAPTER_ON_PORT_8080"));
