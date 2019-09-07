webtorrent = require "webtorrent"
drag_drop = require "drag-drop"
$ = require "cash-dom"

util = require '../util'

console.log 'Seeder script loaded.'

__torrent = null
total_size = 0
file_count = 0

seed_files = (files) ->
    if __torrent?
        __torrent.destroy () ->
            console.log 'Destroyed last seeded torrent'

    client = new webtorrent()
    client.seed files, (torrent) ->
        __torrent = torrent

        total_size = (files.map (f) -> f.size).reduce ((a, b) -> a + b), 0
        file_count = files.length

        if files.length == 1
            ($ 'ul#magnets').html """
                <li>
                    <div><strong>#{files[0].name}</strong></div>
                    <div><a href="download.html##{torrent.magnetURI}">Right-click and copy URL for download</a></div>
                </li>
            """
        else
            ($ 'ul#magnets').html """
                <li>
                    <ul>
                        #{([files...].map (f) -> '<li>' + f.name + '</li>').join ''}
                    </ul>
                    <div><a href="download.html##{torrent.magnetURI}">Right-click and copy URL for download</a></div>
                </li>
            """
      
    setInterval set_status, 800

drag_drop 'body', seed_files

($ 'input#file-input').on 'change', () ->
    seed_files [this.files...]
        
($ 'button#file-select').on 'click', () ->
    ($ 'input#file-input')[0].click()

# status_html = () ->
#     """
#     <div>#{__torrent.numPeers} peers online</div>
#     <div>Uploaded #{util.human_file_size __torrent.uploaded}</div>
#     <div>Uploading at #{util.human_file_size __torrent.uploadSpeed}/s</div>
#     """

status_section = $ 'section#status'

set_status = () ->
    ($ '#file-size').html(util.human_file_size total_size)
    ($ '#file-count').html("<div>#{file_count}</div>")
    # status_section.html status_html()