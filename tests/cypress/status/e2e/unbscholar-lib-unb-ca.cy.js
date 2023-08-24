const host = 'https://unbscholar.lib.unb.ca'
describe('UNB Scholar Research Repository', {baseUrl: host, groups: ['sites']}, () => {

  context('Front page', {baseUrl: host}, () => {
    beforeEach(() => {
      cy.visit('/')
      cy.title()
        .should('contain', 'UNB Scholar')
    })

    specify('Search for "New Brunswick" should find 5+ results', () => {
      cy.get('[data-test="search-box"]')
        .type('New Brunswick')
      cy.get('[data-test="search-button"')
        .click()
      
      cy.get('[data-test="list-object"]')
        .should('have.lengthOf.at.least', 5)
    })
  })

})
