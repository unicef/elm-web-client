'use strict'
// Main javascript entry file
// Load Elm files and mount the application 
// Bind Elm ports
import './res/style.scss'

// Require index.html so it gets copied to dist
require('./index.html');

const Elm = require('./Main.elm');
const apiBase = '/wapi'
const wsProtocol = location.protocol === 'https:' ? 'wss:' : 'ws:'
//const websocketHost = `${wsProtocol}//${location.host}/ws`
const sockBase = wsProtocol + '//localhost:8888/ws'
// .embed() can take an optional second argument. 
// This would be an object describing the data we need to start a program, i.e. a userID or some token
const app = Elm.Main.embed(document.getElementById('app'), {
  sockBase: sockBase,
  apiBase: apiBase
});

app.ports.assetBlockImageSelected.subscribe(filerReader(app.ports.assetBlockImageRead))
app.ports.profileImageSelected.subscribe(filerReader(app.ports.proileImageContentRead))


function filerReader (port) {
  return function(id) {
        var node = document.getElementById(id);
        if (node === null) {
          return;
        }
        // If your file upload field allows multiple files, you might
        // want to consider turning this into a `for` loop.
        var file = node.files[0];
        var reader = new FileReader();
        // FileReader API is event based. Once a file is selected
        // it fires events. We hook into the `onload` event for our reader.
        reader.onload = (function(event) {
          // The event carries the `target`. The `target` is the file
          // that was selected. The result is base64 encoded contents of the file.
          var base64encoded = event.target.result;
          // We build up the `ImagePortData` object here that will be passed to our Elm
          // runtime through the `fileContentRead` subscription.
          var portData = {
            contents: base64encoded,
            filename: file.name
          };
          // We call the `fileContentRead` port with the file data
          // which will be sent to our Elm runtime via Subscriptions
          port.send(portData);
        });
        // Connect our FileReader with the file that was selected in our `input` node.
        reader.readAsDataURL(file);
      }
}
