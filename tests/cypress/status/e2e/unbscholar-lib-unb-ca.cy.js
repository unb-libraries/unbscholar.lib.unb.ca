const host = 'https://unbscholar.lib.unb.ca'
describe('UNB Scholar Research Repository', {baseUrl: host, groups: ['sites']}, () => {

  context('Front page', {baseUrl: host}, () => {
    beforeEach(() => {
      cy.visit('/')
      cy.title()
        .should('contain', 'UNB Scholar')
    })

    specify('Search for "New Brunswick" should find 5+ results', () => {
      cy.get('.search-container form').within(() => {
        cy.get('input[name="query"]')
          .type('New Brunswick')
      }).submit()
      cy.url()
        .should('match', /\/search\?query=New%20Brunswick/)
      cy.get('#search-content ul.list-unstyled li')
        .should('have.lengthOf.at.least', 5)
    })
  })

})
