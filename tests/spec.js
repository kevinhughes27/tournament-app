var assert = require('assert');

const teamName = 'Anteek';
const gameName = 'Anteek vs Fiasco';
const gameCount = 3;
const homeScore = '15';
const awayScore = '13';

describe('Player App', function() {
  it('can submit score', function () {
    // load app
    browser.url('http://localhost:5000');
    browser.pause(500);

    // perform search
    browser.setValue('#search', teamName);
    assert.equal(browser.elements('strong=' + teamName).value.length, gameCount);

    // navigate
    browser.click('button=Submit Scores');
    assert(browser.getUrl().match('/submit'));

    // enter captain pin
    browser.click('.pincode-input-text');
    browser.keys('1234');
    assert(browser.getHTML('div=Submit a score for each game played'));

    // choose game
    browser.click('button=' + gameName);

    // fill out form
    browser.setValue('[name="home_score"]', homeScore);
    browser.setValue('[name="away_score"]', awayScore);
    browser.click('label=Very Good');

    // submit
    browser.click('button=Submit');
    browser.pause(500);

    // load results
    var value = browser.localStorage('GET', 'reports').value;
    var reports = JSON.parse(value);

    // assert result
    assert.equal(reports.length, 1);
    assert.equal(reports[0].home_score, homeScore);
    assert.equal(reports[0].away_score, awayScore);
    assert.equal(reports[0].status, 'success');
  });
})