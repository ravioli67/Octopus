const crypto = require('crypto');
const key = crypto.randomBytes(32);
console.log(key);

const fs = require('fs');

// Write the key variable to a file named 'generated.key'
fs.writeFileSync('generated.key', key, 'utf8');

console.log('Key written to file successfully!');
