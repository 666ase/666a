import companies from '../data/companies.json'
import { createCompany } from '../lib/company'
;(async () => {
  companies.forEach((company) => {
    createCompany({
      name: company.name,
      number: company.id,
    })
  })
})()
