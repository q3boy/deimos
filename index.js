try {
  path = require.resolve('./dist/lib/faker')
} catch (e) {
  if (require.extensions['.coffee'] === undefined) {
   require('coffee-script/register')
  }
  path = './lib/faker'
}
module.exports = require(path)