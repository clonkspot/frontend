@echo off

call "cmd /c start supervisor --exec .\node_modules\.bin\coffee.cmd app.coffee"
call "cmd /c start grunt watch"
