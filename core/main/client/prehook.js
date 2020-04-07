//
// Copyright (c) 2006-2020 Wade Alcorn - wade@bindshell.net
// Browser Exploitation Framework (BeEF) - http://beefproject.com
// See the file 'doc/COPYING' for copying permission
//

/**
 * Provides functionality to manipulate the DOM.
 * @namespace beef.prehook
 */

beef.prehook = {

  /**
   * Queues the current command results and flushes the queue straight away.
   * @return {Integer} the result of the websocket check
   */
  check: function () {
    supportsWebSockets = 'WebSocket' in window || 'MozWebSocket' in window;
    beef.debug("Websockets are enabled:" + supportsWebSockets);
    return supportsWebSockets;
  }

}

beef.regCmp('beef.prehook');
if (beef.execute(beef.prehook.check())) {
  
}
