// YAML 语法校验（js-yaml 只做解析，不做 schema 语义校验）
const fs = require('fs');
const yaml = require('js-yaml');
let ok = true;
for (const f of process.argv.slice(2)) {
  try {
    const doc = yaml.load(fs.readFileSync(f, 'utf8'));
    const jobs = Object.keys(doc.jobs || {});
    const steps = jobs.map(j => ((doc.jobs[j].steps || []).length));
    console.log('OK   ' + f + '  jobs=' + jobs.join(',') + '  steps=' + steps.join(','));
  } catch (e) {
    ok = false;
    console.log('FAIL ' + f + '\n  ' + e.message);
  }
}
process.exit(ok ? 0 : 1);
