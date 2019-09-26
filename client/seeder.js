var $, __torrent, drag_drop, file_count, seed_files, set_status, status_html, status_section, total_size, util, webtorrent;

webtorrent = require("webtorrent");

drag_drop = require("drag-drop");

$ = require("cash-dom");

util = require('../util');

console.log('Seeder script loaded.');

__torrent = null;

total_size = 0;

file_count = 0;

seed_files = function(files) {
  var client;
  if (__torrent != null) {
    __torrent.destroy(function() {
      return console.log('Destroyed last seeded torrent');
    });
  }
  client = new webtorrent();
  client.seed(files, function(torrent) {
    __torrent = torrent;
    total_size = (files.map(function(f) {
      return f.size;
    })).reduce((function(a, b) {
      return a + b;
    }), 0);
    file_count = files.length;
    ($('#file-size')).html(util.human_file_size(total_size));
    ($('#file-count')).html(`<div>${file_count}</div>`);
    if (files.length === 1) {
      return ($('ul#magnets')).html(`<li>\n    <div><strong>${files[0].name}</strong></div>\n    <br>\n    <p>Copy and share below link</p>\n    <div class='download-url'><a href="download.html#${torrent.magnetURI}"><code>${window.location.hostname}/download.html#${torrent.magnetURI.substr(0, 45)}...</code></a></div>\n</li>`);
    } else {
      return ($('ul#magnets')).html(`<li>\n    <ul id='magnets-inner'>\n        ${([...files].map(function(f) {
        return '<li><strong>' + f.name + '</strong></li>';
      })).join('')}\n    </ul>\n    <br>\n    <p>Copy and share below link</p>\n    <div class='download-url'><a href="download.html#${torrent.magnetURI}"><code>${window.location.hostname}/download.html#${torrent.magnetURI.substr(0, 45)}...</code></a></div>\n</li>`);
    }
  });
  return setInterval(set_status, 800);
};

drag_drop('body', seed_files);

($('input#file-input')).on('change', function() {
  return seed_files([...this.files]);
});

($('button#file-select')).on('click', function() {
  return ($('input#file-input'))[0].click();
});

status_html = function() {
  var percentage;
  percentage = (__torrent != null ? __torrent.uploaded : void 0) / total_size * 100;
  return `<p>Opened by ${(__torrent != null ? __torrent.numPeers : void 0)} peers</p>\n<p>Uploading at ${util.human_file_size(__torrent != null ? __torrent.uploadSpeed : void 0)}/s</p>\n<p>Uploaded ${util.human_file_size(__torrent != null ? __torrent.uploaded : void 0)} for ${util.human_file_size(total_size)}</p>\n<progress class='progress-bar' max="100" value="${percentage}"> ${percentage}% </progress>`;
};

status_section = $('section#status');

set_status = function() {
  return status_section.html(status_html());
};
