Tests
=====

This app is tested using [Browserstack](https://www.browserstack.com/automate) with a local tunnel

In order to run the tests:

1. Run the Rails server to make the graphql api available locally

2. Run the webpack development server using `yarn start` in top directory

3. Run `yarn test`. The results can be seen visually on Browserstack

Note - make sure the constants in the test make sense with the current local tournament.