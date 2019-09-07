webtorrent = require "webtorrent"
drag_drop = require "drag-drop"
$ = require "cash-dom"

console.log 'Seeder script loaded.'

seed_files = (files) ->
    client = new webtorrent()
    client.seed files, (torrent) ->
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

drag_drop 'body', seed_files

($ 'input#file-input').on 'change', () ->
    seed_files [this.files...]
        
($ 'button#file-select').on 'click', () ->
    ($ 'input#file-input')[0].click()