// Background page -- background.js
chrome.runtime.onConnect.addListener(function(devToolsConnection) {
  // assign the listener function to a variable so we can remove it later
  var devToolsListener = function(message, sender, sendResponse) {
      // Inject a content script into the identified tab
      chrome.tabs.executeScript(message.tabId, {
        file: message.scriptToInject
      });
    }
    // add the listener
  devToolsConnection.onMessage.addListener(devToolsListener);

  devToolsConnection.onDisconnect.addListener(function() {
    devToolsConnection.onMessage.removeListener(devToolsListener);
  });
});

// background.js
var openCount = 0;
chrome.runtime.onConnect.addListener(function(port) {
  if (port.name == "devtools-page") {
    if (openCount == 0) {
      alert("DevTools window opening.");
    }
    openCount++;

    port.onDisconnect.addListener(function(port) {
      openCount--;
      if (openCount == 0) {
        alert("Last DevTools window closing.");
      }
    });
  }
});