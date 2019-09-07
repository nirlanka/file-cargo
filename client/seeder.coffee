webtorrent = require "webtorrent"
drag_drop = require "drag-drop"
$ = require "cash-dom"

util = require '../util'

console.log 'Seeder script loaded.'

__torrent = null

seed_files = (files) ->
    client = new webtorrent()
    client.seed files, (torrent) ->
        __torrent = torrent

        if files.length == 1
            ($ 'ul#magnets').append """
                <li>
                    <div><strong>#{files[0].name}</strong></div>
                    <div><a href="download.html##{torrent.magnetURI}">Right-click and copy URL for download</a></div>
                </li>
            """
        else
            ($ 'ul#magnets').append """
                <li>
                    <ul>
                        #{([files...].map (f) -> '<li>' + f.name + '</li>').join ''}
                    </ul>
                    <div><a href="download.html##{torrent.magnetURI}">Right-click and copy URL for download</a></div>
                </li>
            """

    setInterval set_status, 500

drag_drop 'body', seed_files

($ 'input#file-input').on 'change', () ->
    seed_files [this.files...]
        
($ 'button#file-select').on 'click', () ->
    ($ 'input#file-input')[0].click()

status_html = () ->
    """
    <div>#{__torrent.numPeers} peers online</div>
    <div>Uploaded #{util.human_file_size __torrent.uploaded}</div>
    <div>Uploading at #{util.human_file_size __torrent.uploadSpeed}/s</div>
    """

status_section = $ 'section#status'

set_status = () ->
    status_section.html status_html()