module.exports = {
  babel: {
    plugins: [
      ["relay", { "artifactDirectory": "./src/generated" }]
    ]
  }
};
