webtorrent = require "webtorrent"
$ = require "cash-dom"

console.log 'Leach script loaded.'

($ 'button#download').prop 'disabled', true

($ 'button#download').on 'click', (event) ->
    console.log 'Trying to leach.'

    files.forEach (f) ->
        f.getBlob (err, blob) ->
            url = URL.createObjectURL blob
            a = document.createElement 'a'
            a.download = f.name
            a.href = url
            a.click()

magnet = window.location.hash.replace '#', ''

files = []

if magnet != ''
    client = new webtorrent()
    client.add magnet, (torrent) ->
        files = [torrent.files...]
        ($ 'ul#files').append (files.map (f) -> '<li>' + f.name + '</li>').join ''
        
        ($ 'button#download').prop 'disabled', false
    