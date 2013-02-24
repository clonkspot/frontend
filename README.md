Clonkspot Frontend
==================

This is the frontend of [clonkspot's main web pages](http://clonkspot.org/).

It uses a simple express server for filling in translations on the server-side.

Setup
-----

```
npm install -g grunt-cli coffee-script supervisor
npm install
```

Then run the server with `coffee app.coffee` or `supervisor app.coffee`.

On Windows you might need to use `supervisor --exec .\node_modules\.bin\coffee.cmd app.coffee`.

