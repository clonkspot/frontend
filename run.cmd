@echo off

call "cmd /c npm install"
call "cmd /c start nodemon run.js"
call "cmd /c start grunt watch"
