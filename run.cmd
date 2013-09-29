@echo off

call "cmd /c npm install"
call "cmd /c start coffee run.coffee"
call "cmd /c start grunt watch"
