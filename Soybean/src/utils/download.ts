/**
 * 下载 blob 文件
 */
export function downloadFile(res: any, downName = '') {
  const aLink = document.createElement('a');
  let fileName = downName;
  let blob = res;

  if (res.headers && res.data) {
    blob = new Blob([res.data], {
      type: res.headers['content-type']?.replace(';charset=utf8', '') || 'application/octet-stream'
    });
    if (!downName) {
      const contentDisposition = decodeURI(res.headers['content-disposition'] || '');
      const result = contentDisposition.match(/filename="(.+)/gi);
      fileName = result?.[0]?.replace(/filename="(.+)/gi, '') || '';
      fileName = fileName.replace('"', '');
    }
  }

  aLink.href = URL.createObjectURL(blob);
  aLink.setAttribute('download', fileName);
  document.body.appendChild(aLink);
  aLink.click();
  document.body.removeChild(aLink);
  URL.revokeObjectURL(aLink.href);
}
