const fs = require('fs');
const path = require('path');

const file = path.resolve(__dirname, '..', 'index.json');
try {
    const data = fs.readFileSync(file, 'utf8');
    JSON.parse(data);
    console.log('index.json is valid JSON');
    process.exit(0);
} catch (err) {
    console.error('Invalid JSON in index.json:');
    console.error(err.message);
    process.exit(1);
}
