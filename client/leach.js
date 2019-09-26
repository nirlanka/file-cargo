var $, __torrent, client, done_html, file_count, files, is_download_done, is_download_done_status_shown, magnet, set_status, status_html, status_section, total_size, util, webtorrent;

webtorrent = require("webtorrent");

$ = require("cash-dom");

util = require('../util');

console.log('Leach script loaded.');

($('button#download')).prop('disabled', true);

total_size = 0;

file_count = 0;

is_download_done = false;

($('button#download')).on('click', function(event) {
  console.log('Trying to leach.');
  files.forEach(function(f) {
    return f.getBlob(function(err, blob) {
      var a, url;
      url = URL.createObjectURL(blob);
      a = document.createElement('a');
      a.download = f.name;
      a.href = url;
      return a.click();
    });
  });
  setInterval(set_status, 500);
  return __torrent.on('done', function() {
    return is_download_done = true;
  });
});

magnet = window.location.hash.replace('#', '');

__torrent = null;

files = [];

if (magnet !== '') {
  client = new webtorrent();
  client.add(magnet, function(torrent) {
    __torrent = torrent;
    files = [...torrent.files];
    ($('ul#files')).html((files.map(function(f) {
      return `<li><strong>${f.name}</strong></li>`;
    })).join(''));
    ($('button#download')).prop('disabled', false);
    total_size = (files.map(function(f) {
      return f.length;
    })).reduce((function(a, b) {
      return a + b;
    }), 0);
    file_count = files.length;
    ($('#file-size')).html(util.human_file_size(total_size));
    return ($('#file-count')).html(`<div>${file_count}</div>`);
  });
}

status_html = function() {
  var percentage;
  percentage = (__torrent != null ? __torrent.downloaded : void 0) / total_size * 100;
  return `<p>Downloading at ${util.human_file_size(__torrent != null ? __torrent.downloadSpeed : void 0)}/s</p>\n<p>Downloaded ${util.human_file_size(__torrent != null ? __torrent.downloaded : void 0)} of ${util.human_file_size(total_size)}</p>\n<progress class='progress-bar' max="100" value="${percentage}"> ${percentage}% </progress>`;
};

done_html = function() {
  var percentage;
  percentage = (__torrent != null ? __torrent.downloaded : void 0) / total_size * 100;
  return `<p>Downloaded ${util.human_file_size(total_size)}</p>\n<p>Download complete.</p>\n<progress class='progress-bar' max="100" value="${percentage}"> ${percentage}% </progress>`;
};

status_section = $('section#status');

is_download_done_status_shown = false;

set_status = function() {
  if (!is_download_done) {
    status_section.html(status_html());
  }
  if (is_download_done && !is_download_done_status_shown) {
    status_section.html(done_html());
    return is_download_done_status_shown = true;
  }
};
