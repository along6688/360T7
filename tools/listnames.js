// 从 contents API 的 JSON 数组中提取 name 列表
const fs = require('fs');
const file = process.argv[2];
const re = process.argv[3] ? new RegExp(process.argv[3]) : null;
let j;
try {
  j = JSON.parse(fs.readFileSync(file, 'utf8'));
} catch (e) {
  console.log('not json, raw head:');
  console.log(fs.readFileSync(file, 'utf8').slice(0, 500));
  process.exit(0);
}
if (!Array.isArray(j)) { console.log(JSON.stringify(j).slice(0, 2000)); process.exit(0); }
j.forEach(o => { if (!re || re.test(o.name)) console.log(o.type + '\t' + o.size + '\t' + o.name); });
