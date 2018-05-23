var assert = require('assert');

const PIN = ['1', '2', '3', '4'];
const teamName = 'Anteek';
const gameName = 'Anteek vs Fiasco';
const gameCount = 3;
const homeScore = 15;
const awayScore = 13;

describe('Player App', function() {
  it('can submit score', function () {
    // load app
    browser.url('http://localhost:5000');
    browser.pause(500);

    // perform search
    browser.setValue('#search', teamName);
    browser.pause(50);
    assert.equal(browser.elements('strong=' + teamName).value.length, gameCount);

    // navigate
    browser.click('button=Submit Scores');
    assert(browser.getUrl().match('/submit'));

    // enter captain pin
    var inputs = browser.elements('.pincode-input-text');
    for (var i=0; i<inputs.value.length; i++) {
      var input = inputs.value[i].ELEMENT;
      browser.elementIdValue(input, PIN[i]);
    }

    browser.waitForVisible('div=Submit a score for each game played', 2000);

    // choose game
    browser.click('button=' + gameName);

    // fill out form
    browser.setValue('[name="homeScore"]', homeScore);
    browser.setValue('[name="awayScore"]', awayScore);
    browser.click('label=Very Good');

    // submit
    browser.click('button=Submit');
    browser.pause(1500);

    // assert on local storage
    // var value = browser.localStorage('GET', 'reports').value;
    // var reports = JSON.parse(value);

    // assert.equal(reports.length, 1);
    // assert.equal(reports[0].homeScore, homeScore);
    // assert.equal(reports[0].awayScore, awayScore);
    // assert.equal(reports[0].status, 'success');

    // assert on green checkmark
    assert(browser.getSource().match(/color="green"/));
  });
})