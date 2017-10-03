var assert = require('assert');

describe('BrowserStack Local Testing', function() {
  it('can check tunnel working', function () {
    browser.url('http://localhost:5000')
           .pause(2000);

    browser.click('button=Map');
    
    assert(browser.getUrl().match('/map'));
  });
});