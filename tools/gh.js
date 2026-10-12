// GitHub API 抓取工具（本机直连 raw.githubusercontent 不通，统一走 api.github.com）
// 用法: node tools/gh.js <url> [outfile]
const https = require('https');
const fs = require('fs');
const path = require('path');

const url = process.argv[2];
const out = process.argv[3];

function get(u, redirects = 0) {
  return new Promise((resolve, reject) => {
    const req = https.request(u, {
      headers: {
        'User-Agent': 'node-fetch-script',
        'Accept': 'application/vnd.github.raw',
        'Authorization': process.env.GITHUB_TOKEN ? 'token ' + process.env.GITHUB_TOKEN : ''
      }
    }, (res) => {
      if (res.statusCode >= 300 && res.statusCode < 400 && res.headers.location && redirects < 5) {
        res.resume();
        return get(res.headers.location, redirects + 1).then(resolve, reject);
      }
      let d = '';
      res.setEncoding('utf8');
      res.on('data', c => d += c);
      res.on('end', () => resolve({ status: res.statusCode, body: d }));
    });
    req.on('error', reject);
    req.end();
  });
}

(async () => {
  const r = await get(url);
  if (out) {
    fs.mkdirSync(path.dirname(out), { recursive: true });
    fs.writeFileSync(out, r.body);
    console.log('saved -> ' + out + '  (' + r.body.length + ' bytes, http ' + r.status + ')');
  } else {
    console.log('http ' + r.status);
    console.log(r.body);
  }
})();
