var assert = require('assert');

describe('Submit View', function() {
  before(function() {
    browser.url('http://localhost:5000/submit')
      .pause(2000);

    browser.setValue('#search', 'Anteek');
  });

  it('can enter pin', function () {
    browser.click('button=Submit Scores');

    browser.click('.pincode-input-text');
    browser.keys('1234');

    assert(browser.getHTML('div=Submit a score for each game played'));
  });
})