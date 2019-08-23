/* WindowState version 1.0.0
 *
 * (C) Lyo Kato <lyo.kato@gmail.com>
 * WindowState is freely distributable under the terms of MIT-style license.
 *
 * This library requires the JavaScript Framework "Prototype" (version 1.4 or later).
 * For details, see http://prototype.conio.net/
/*-----------------------------------------------------------------------------------*/
var WindowState = {
  getSize: function() {
    var width, height;
    if (self.innerHeight) {
      width  = self.innerWidth;
      height = self.innerHeight;
    } else if (document.documentElement && document.documentElement.clientHeight) {
      width  = document.documentElement.clientWidth;
      height = document.documentElement.clientHeight;
    } else if (document.body) {
      width  = document.body.clientWidth;
      height = document.body.clientHeight;
    }
    return { width: width, height: height };
  },
  getScrollSize: function() {
    var width, height;
    if (window.innerHeight && window.scrollMaxY) {
      width  = document.body.scrollWidth;
      height = window.innerHeight + window.scrollMaxY;
    } else if (document.body.scrollHeight > document.body.offsetHeight) {
      width  = document.body.scrollWidth;
      height = document.body.scrollHeight;
    } else {
      width  = document.body.offsetWidth;
      height = document.body.offsetHeight;
    }
    return { width: width, height: height };
  },
  getOffset: function() {
    var offsetX = window.pageXOffset
                || document.documentElement.scrollLeft
                || document.body.scrollLeft
                || 0;
    var offsetY = window.pageYOffset
                || document.documentElement.scrollTop
                || document.body.scrollTop
                || 0;
    return { left: offsetX, top: offsetY };
  },
  getContentSize: function() {
    var width, height;
    var scrollSize = WindowState.getScrollSize();
    var windowSize = WindowState.getSize();
    width = (scrollSize.width  < windowSize.width) ? windowSize.width  : scrollSize.width;
    height = (scrollSize.height < windowSize.height) ? windowSize.height : scrollSize.height;
    return { width: width, height: height };
  }
};
