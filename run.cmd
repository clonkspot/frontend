@echo off

call "cmd /c start supervisor --exec coffee.cmd app.coffee"
call "cmd /c start grunt watch"
