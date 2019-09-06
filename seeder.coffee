webtorrent = require "webtorrent"
drag_drop = require "drag-drop"
$ = require "cash-dom"

console.log 'Seeder script loaded.'

drag_drop 'body', (files) ->
    client = new webtorrent()
    client.seed files, (torrent) ->
        if files.length == 1
            ($ 'ul#magnets').append """
                <li>
                    <div><strong>#{files[0].name}</strong></div>
                    <!--div><code>#{torrent.magnetURI}</code></div-->
                    <div><a href="download.html##{torrent.magnetURI}">Download</a></div>
                </li>
            """
        else
            ($ 'ul#magnets').append """
                <li>
                    <ul>
                        #{([files...].map (f) -> '<li>' + f.name + '</li>').join ''}
                    </ul>
                    <!--div><code>#{torrent.magnetURI}</code></div-->
                    <div><a href="download.html##{torrent.magnetURI}">Download</a></div>
                </li>
            """
        