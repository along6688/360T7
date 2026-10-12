// 把上游 defconfig/mt7981-ax3000.config 裁成只编 360T7 的配置
// 用法: node tools/trim-config.js <源config> <输出config> [版本号]
const fs = require('fs');
const src = process.argv[2];
const dst = process.argv[3];
const ver = process.argv[4] || '25.12.2';

const KEEP = ['qihoo_360t7', 'qihoo_360t7-ubi'];
const reDev = /^CONFIG_TARGET_DEVICE_mediatek_filogic_DEVICE_(.+)=y$/;
const rePkg = /^CONFIG_TARGET_DEVICE_PACKAGES_mediatek_filogic_DEVICE_(.+)=/;

const lines = fs.readFileSync(src, 'utf8').split(/\r?\n/);
const out = [];
let devRemoved = 0, pkgRemoved = 0, devKept = [];

for (const l of lines) {
  let m = l.match(reDev);
  if (m) {
    if (KEEP.includes(m[1])) { out.push(l); devKept.push(m[1]); }
    else devRemoved++;
    continue;
  }
  m = l.match(rePkg);
  if (m) {
    if (KEEP.includes(m[1])) out.push(l);
    else pkgRemoved++;
    continue;
  }
  out.push(l);
}

// 去掉尾部多余空行
while (out.length && out[out.length - 1] === '') out.pop();

out.push('');
out.push('#######################################################################');
out.push('#                        VERSION (25.12.2)                            #');
out.push('#######################################################################');
out.push('');
out.push('CONFIG_VERSION_DIST="ImmortalWrt"');
out.push('CONFIG_VERSION_NUMBER="' + ver + '"');
out.push('CONFIG_VERSION_CODE="' + ver + '"');
out.push('CONFIG_VERSION_HOME="https://immortalwrt.org/"');
out.push('CONFIG_VERSION_BUG_URL="https://github.com/immortalwrt/immortalwrt/issues"');
out.push('CONFIG_VERSION_SUPPORT_URL="https://forum.openwrt.org/"');
out.push('');

fs.writeFileSync(dst, out.join('\n'));
console.log('删除机型行: ' + devRemoved + ' , 删除机型包行: ' + pkgRemoved);
console.log('保留机型: ' + devKept.join(', '));
console.log('输出: ' + dst + ' (' + out.join('\n').length + ' bytes)');
