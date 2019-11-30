require('dotenv').config();
const fs = require('fs');

const args = process.argv.splice(2);
if (args.length === 0) {
  throw new Error('Missing argument (path to dartapi base directory');
}
if (!process.env.BASE_URL) {
  throw new Error('Couldn\'t get BASE_URL from .env file');
}
const dartapiBasePath = args[0];

replaceStringInFile(
  dartapiBasePath + '/lib/api_client.dart',
  /ApiClient\(\{this.basePath = "http:\/\/localhost"}\)/,
  'ApiClient({this.basePath = "' + process.env.BASE_URL + '"})'
);

function replaceStringInFile(file, searchValue, replaceValue) {
  if (!file || !searchValue || !replaceValue) {
    console.log('Missing values in replacefunc');
    return;
  }

  fs.readFile(file, 'utf8', function(err, data) {
    if (err) {
      return console.log(err);
    }
    var result = data.replace(searchValue, replaceValue);

    fs.writeFile(file, result, 'utf8', function(err) {
      if (err) return console.log(err);
    });
  });
}
