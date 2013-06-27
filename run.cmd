@echo off

call "cmd /c npm install"
call "cmd /c start coffee app.coffee"
call "cmd /c start grunt watch"
