describe('Navigation', () => {
  
  beforeEach(() => {
    browser.get('/')
  })

  it('navigates to map view', () => {
    browser.findElement(by.buttonText('Map')).click()
    
    browser.sleep(1)

    expect(browser.getCurrentUrl())
    .to.eventually.equal('http://localhost:5000/map')
  })

})