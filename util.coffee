module.exports = {}

module.exports.human_file_size = (b) ->
    u = 0
    s = 1024

    fn1 = () ->
        b /= s
        u++

    fn1() while b >= s or -b >= s

    return (if u then (b.toFixed 1) + ' ' else b) + ' KMGTPEZY'[u] + 'B';
