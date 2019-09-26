module.exports = {};

module.exports.human_file_size = function(b) {
  var fn1, s, u;
  u = 0;
  s = 1024;
  fn1 = function() {
    b /= s;
    return u++;
  };
  while (b >= s || -b >= s) {
    fn1();
  }
  return (u ? (b.toFixed(1)) + ' ' : b) + ' KMGTPEZY'[u] + 'B';
};
