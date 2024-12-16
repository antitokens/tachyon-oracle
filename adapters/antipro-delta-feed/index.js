const express = require("express");
const bodyParser = require("body-parser");
const axios = require("axios");

const app = express();
app.use(bodyParser.json());

app.post("/", async (req, res) => {
  try {
    const antiTokenResponse = await axios.get(
      "https://api.dexscreener.com/latest/dex/tokens/HB8KrN7Bb3iLWUPsozp67kS4gxtbA4W5QJX4wKPvpump"
    );
    const proTokenResponse = await axios.get(
      "https://api.dexscreener.com/latest/dex/tokens/CWFa2nxUMf5d1WwKtG9FS9kjUKGwKXWSjH8hFdWspump"
    );

    // Extract and parse `priceUsd` values as numbers
    const priceUsdValuesAntitoken = antiTokenResponse.data.pairs.map((pair) =>
      parseFloat(pair.priceUsd)
    );
    const priceUsdValuesProtoken = proTokenResponse.data.pairs.map((pair) =>
      parseFloat(pair.priceUsd)
    );

    // Calculate the average
    const totalAntitoken = priceUsdValuesAntitoken.reduce(
      (sum, price) => sum + price,
      0
    );
    const totalProtoken = priceUsdValuesProtoken.reduce(
      (sum, price) => sum + price,
      0
    );
    const averageAntitoken = totalAntitoken / priceUsdValuesAntitoken.length;
    const averageProtoken = totalProtoken / priceUsdValuesProtoken.length;
    const delta = Math.abs(averageAntitoken - averageProtoken).toFixed(6);

    res.status(200).json({
      jobRunID: req.body.id,
      data: {
        result: delta, // Added result field for Chainlink
      },
      statusCode: 200,
    });
  } catch (error) {
    console.error("Error:", error);
    res.status(500).json({
      jobRunID: req.body.id,
      status: "errored",
      error: error.message,
    });
  }
});

app.listen(8080, () =>
  console.log("Antitoken Delta Feed Running on Port 8080")
);
