gulp       = require 'gulp'
watch      = require 'gulp-watch'
plumber    = require 'gulp-plumber'
gulpif     = require 'gulp-if'
concat     = require 'gulp-concat'
bower      = require 'main-bower-files'

coffee     = require 'gulp-coffee'
uglify     = require 'gulp-uglify'
sass       = require 'gulp-sass'
prefix     = require 'gulp-autoprefixer'
cssmin     = require 'gulp-cssmin'
jade       = require 'gulp-jade'
minifyHTML = require 'gulp-minify-html'

paths =
  styles: 'styles/*'
  pages: 'pages/*'
  scripts: 'scripts/*'
  images: 'images/*'

gulp.task 'images', ->
  gulp.src paths.images
    .pipe watch()
    .pipe plumber()
    .pipe gulp.dest 'build/images'

gulp.task 'styles', ->
  gulp.src paths.styles
    .pipe watch()
    .pipe plumber()
    .pipe gulpif /\.scss$/, sass()
    .pipe prefix "> 1%"
    # .pipe concat('app.css')
    .pipe cssmin keepSpecialComments: 0
    .pipe gulp.dest 'build'

gulp.task 'pages', ->
  gulp.src paths.pages
    .pipe watch()
    .pipe plumber()
    .pipe gulpif /\.jade$/, jade()
    .pipe minifyHTML()
    .pipe gulp.dest 'build'

gulp.task 'vendor-scripts', ->
  gulp.src bower()
    .pipe watch()
    .pipe plumber()
    # .pipe concat('vendor.js')
    .pipe uglify()
    .pipe gulp.dest 'build'

gulp.task 'app-scripts', ->
  gulp.src paths.scripts
    .pipe watch()
    .pipe plumber()
    .pipe gulpif /\.coffee$/, coffee()
    # .pipe concat('app.js')
    .pipe uglify()
    .pipe gulp.dest 'build'

gulp.task 'scripts', ['vendor-scripts', 'app-scripts']

gulp.task 'markdown', ->
  gulp.src 'source/content/*'
    .pipe watch()
    .pipe plumber()
    .pipe gulp.dest 'build'

# gulp.task 'watch', ->
#   gulp.watch paths.styles,  ['styles']
#   gulp.watch paths.scripts, ['scripts']
#   gulp.watch paths.pages,   ['pages']
#   gulp.watch paths.images,  ['images']

# Default task call every tasks created so far.
gulp.task 'default', ['images', 'styles', 'scripts', 'markdown', 'pages']
