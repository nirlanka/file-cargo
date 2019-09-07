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

        ($ '#file-size').html(util.human_file_size total_size)
        ($ '#file-count').html("<div>#{file_count}</div>")

        if files.length == 1
            ($ 'ul#magnets').html """
                <li>
                    <div><strong>#{files[0].name}</strong></div>
                    <br>
                    <p>Copy and share below link</p>
                    <div class='download-url'><a href="download.html##{torrent.magnetURI}"><code>#{window.location.hostname}/download.html##{torrent.magnetURI.substr 0, 45}...</code></a></div>
                </li>
            """
        else
            ($ 'ul#magnets').html """
                <li>
                    <ul id='magnets-inner'>
                        #{([files...].map (f) -> '<li><strong>' + f.name + '</strong></li>').join ''}
                    </ul>
                    <br>
                    <p>Copy and share below link</p>
                    <div class='download-url'><a href="download.html##{torrent.magnetURI}"><code>#{window.location.hostname}/download.html##{torrent.magnetURI.substr 0, 45}...</code></a></div>
                </li>
            """
      
    setInterval set_status, 800

drag_drop 'body', seed_files

($ 'input#file-input').on 'change', () ->
    seed_files [this.files...]
        
($ 'button#file-select').on 'click', () ->
    ($ 'input#file-input')[0].click()

status_html = () ->
    percentage = __torrent?.uploaded/total_size*100
    """
    <p>Opened by #{__torrent?.numPeers} peers</p>
    <p>Uploading at #{util.human_file_size __torrent?.uploadSpeed}/s</p>
    <p>Uploaded #{util.human_file_size __torrent?.uploaded} for #{util.human_file_size total_size}</p>
    <progress class='progress-bar' max="100" value="#{percentage}"> #{percentage}% </progress>
    """

status_section = $ 'section#status'

set_status = () ->
    status_section.html status_html()