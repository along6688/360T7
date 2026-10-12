// 从 branches API JSON 中提取分支名
const fs = require('fs');
const j = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
if (!Array.isArray(j)) { console.log(JSON.stringify(j).slice(0, 1500)); process.exit(0); }
j.forEach(b => console.log(b.name));
