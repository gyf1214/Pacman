var gulp = require('gulp'),
  coffee = require('gulp-coffee'),
  lint = require('gulp-coffeelint'),
  cache = require('gulp-cache'),
  uglify = require('gulp-uglify'),
  clean = require('gulp-clean'),
  concat = require('gulp-concat'),
  rename = require('gulp-rename'),
  util = require('gulp-util'),
  merge = require('merge-stream');

var libFile = ['src/*.coffee', '!src/main.coffee'],
  mainFile = 'src/main.coffee',
  libTarget = 'lib.js',
  mainTarget = 'main.js',
  tarPath = 'bin';

var coffeefy = function(src, target) {
  var d = src
    .pipe(lint())
    .pipe(lint.reporter())
    .pipe(cache(coffee()))
    .on('error', function (err) {
      this.emit('end');
    })
    if (target !== null && target !== undefined) {
      return d
        .pipe(concat(target))
        .pipe(gulp.dest(tarPath));
    } else return d;
}

var compress = function(src) {
  return src
    .pipe(rename({suffix: '.min'}))
    .pipe(uglify())
    .on('error', util.log)
    .pipe(gulp.dest(tarPath));
}

gulp.task('coffee', function () {
  var main = gulp.src(mainFile),
    lib = gulp.src(libFile);

  var lib = coffeefy(lib, libTarget),
    target = compress(merge(coffeefy(main), lib)
          .pipe(concat(mainTarget))
          .pipe(gulp.dest(tarPath)));

  return merge(compress(lib), target);
});

gulp.task('watch', function (){
  gulp.watch('src/*.coffee', ['coffee']);
});
