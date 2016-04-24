var gulp = require('gulp'),
  coffee = require('gulp-coffee'),
  lint = require('gulp-coffeelint'),
  cache = require('gulp-cache'),
  uglify = require('gulp-uglify'),
  clean = require('gulp-clean'),
  concat = require('gulp-concat'),
  rename = require('gulp-rename'),
  util = require('gulp-util');

var srcFile = 'src/*.coffee',
  target = 'main.js',
  tarPath = 'bin'

gulp.task('coffee', function () {
  return gulp.src(srcFile)
    .pipe(lint())
    .pipe(lint.reporter())
    .pipe(cache(coffee())).on('error', util.log)
    .pipe(concat(target))
    .pipe(gulp.dest(tarPath))
    .pipe(rename({suffix: '.min'}))
    .pipe(uglify())
    .pipe(gulp.dest(tarPath));
});

gulp.task('watch', function (){
  gulp.watch(srcFile, ['coffee']);
});
