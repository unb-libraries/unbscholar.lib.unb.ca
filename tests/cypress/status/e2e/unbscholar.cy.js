const host = 'https://unbscholar.lib.unb.ca'
describe('UNB Scholar Research Repository', {baseUrl: host, groups: ['sites']}, () => {

  context('Front page', {baseUrl: host}, () => {
    beforeEach(() => {
      cy.visit('/')
      cy.title()
        .should('contain', 'UNB Scholar')
    })

    specify('Search for "New Brunswick" should find 5+ results', () => {
      cy.get('#home-search-block form').within(() => {
        cy.get('input[name="islandora_simple_search_query"]')
          .type('New Brunswick')
      }).submit()
      cy.url()
        .should('match', /\/islandora\/search\/New%20Brunswick/)
      cy.get('.islandora-solr-search-result')
        .should('have.lengthOf.at.least', 5)
    })
  })

})
