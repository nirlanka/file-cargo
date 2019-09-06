webtorrent = require "webtorrent"
$ = require "cash-dom"

console.log 'Leach script loaded.'

($ 'button#download').prop 'disabled', true

($ 'button#download').on 'click', (event) ->
    console.log 'Trying to leach.'

magnet = window.location.hash.replace '#', ''

if magnet != ''
    ($ 'button#download').prop 'disabled', false

    client = new webtorrent()
    client.add magnet, (torrent) ->
        ($ 'ul#files').append ([torrent.files...].map (f) -> '<li>' + f.name + '</li>').join ''
    