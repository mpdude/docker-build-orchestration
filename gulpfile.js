require('gulp').task('default', function (done) {
  require('fs').writeFileSync('html/time', (new Date()).toISOString());
  done();
})
