webtorrent = require "webtorrent"
$ = require "cash-dom"

util = require '../util'

console.log 'Leach script loaded.'

($ 'button#download').prop 'disabled', true

total_size = 0
is_download_done = false

($ 'button#download').on 'click', (event) ->
    console.log 'Trying to leach.'

    files.forEach (f) ->
        f.getBlob (err, blob) ->
            url = URL.createObjectURL blob
            a = document.createElement 'a'
            a.download = f.name
            a.href = url
            a.click()

    setInterval set_status, 500

    __torrent.on 'done', () -> is_download_done = true

magnet = window.location.hash.replace '#', ''

__torrent = null
files = []

if magnet != ''
    client = new webtorrent()
    client.add magnet, (torrent) ->
        __torrent = torrent

        files = [torrent.files...]
        ($ 'ul#files').html (files.map (f) -> "<li><strong>#{f.name}</strong></li>").join ''
        
        ($ 'button#download').prop 'disabled', false

        total_size = (files.map (f) -> f.length).reduce ((a, b) -> a + b), 0

status_html = () -> 
    percentage = __torrent?.downloaded/total_size*100
    """
    <p>Downloading at #{ util.human_file_size __torrent?.downloadSpeed}/s</p>
    <p>Downloaded #{util.human_file_size __torrent?.downloaded} of #{util.human_file_size total_size}</p>
    <progress class='progress-bar' max="100" value="#{percentage}"> #{percentage}% </progress>
    """

done_html = () ->
    percentage = __torrent?.downloaded/total_size*100
    """
    <p>Downloaded #{util.human_file_size  total_size}</p>
    <p>Download complete.</p>
    <progress class='progress-bar' max="100" value="#{percentage}"> #{percentage}% </progress>
    """

status_section = $ 'section#status'

is_download_done_status_shown = false

set_status = () ->
    if not is_download_done
        status_section.html status_html()
    if is_download_done and not is_download_done_status_shown
        status_section.html done_html()
        is_download_done_status_shown = true