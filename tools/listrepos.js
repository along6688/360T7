// 从 search API 结果中提取仓库摘要（full_name / 默认分支 / 推送时间 / 描述）
const fs = require('fs');
const j = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
if (j.total_count === undefined) { console.log(JSON.stringify(j).slice(0, 1200)); process.exit(0); }
console.log('total_count = ' + j.total_count + ' , shown = ' + (j.items ? j.items.length : 0));
(j.items || []).forEach(o => {
  const d = (o.description || '').replace(/\s+/g, ' ').slice(0, 90);
  console.log((o.pushed_at || '').slice(0, 10) + '  ' + o.full_name + '   [' + (o.default_branch || '') + ']  ' + d);
});
