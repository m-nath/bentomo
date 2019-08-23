/* Popup version 1.0.0
 *
 * (c) 2006 Lyo Kato <lyo.kato@gmail.com>
 * Popup is freely distributable under the terms of MIT-style license.
 *
 * This library requires the JavaScript Framework "Prototype" (version 1.4 or later).
 * For details, see http://prototype.conio.net/
/*---------------------------------------------------------------------------------*/
var Popup = {
  Version:     '1.0.0',
  windowClass: 'Base',
  currentDepth: 51,
  storage:      $H({}),
  defaultStyle: {
    position: 'absolute',
    width:    '200px',
    height:   '100px',
    top:      0,
    left:     0,
    zIndex:   51,
    backgroundColor: '#fff'
  },
  swapDepths: function(popup1, popup2) {
    var p1  = (typeof popup1 == 'string') ? this.get(popup1) : popup1;
    var p2  = (typeof popup2 == 'string') ? this.get(popup2) : popup2;
    var zIndex1 = p1.getDepth();
    var zIndex2 = p2.getDepth();
    p1.setDepth(zIndex2);
    p2.setDepth(zIndex1);
  },
  setDepth: function(name, depth) {
    this.get(name).setDepth(depth);
  },
  setHighestDepth: function(name) {
    var specified = (typeof name == 'string') ? this.get(name) : name;
    var popups    = this.storage.sortBy(function(data, index){
      return data.value.getDepth();
    });
    var stack    = [];
    var zIndexes = [];
    var specifiedDepth = specified.getDepth();
    popups.each(function(data){
      var popup = data.value;
      var depth = popup.getDepth();
      if (depth > specifiedDepth) {
        stack.push(popup);
        zIndexes.push(depth);
      }
    });
    stack.push(specified);
    zIndexes.unshift(specifiedDepth);
    for (var i=0; i<stack.length; i++) {
      var p = stack[i];
      var z = zIndexes[i];
      p.setDepth(z);
    }
  },
  getDepth: function(name) {
    return this.get(name).getDepth();
  },
  getWindowClass: function() {
    var name = this.windowClass;
    var windowClass = Popup.Window[name];
    if (!windowClass)
      throw "Unknown window class, " + name;
    return windowClass;
  },
  create: function(name, windowClass) {
    var windowClass = windowClass || this.getWindowClass();
    var p = new windowClass();
    p.setDepth(this.currentDepth);
    this.storage[name||'default'] = p;
    this.currentDepth++;
    return p;
  },
  appear: function(name, options) {
    this.get(name).appear(options);
  },
  fade: function(name, options) {
    this.get(name).fade(options);
  },
  get: function(name) {
    if (!name)
      name = 'default';
    var p = this.storage[name] || this.create(name);
    return p;
  },
  remove: function(name) {
    delete this.storage[name||'default'];
  }
}

Popup.Window = new Object();
Popup.Window.Base = Class.create();
Popup.Window.Base.prototype = {
  initialize: function() {
    var element = document.createElement('div');
    this.appeared = false;
    Object.extend(element.style, Popup.defaultStyle);
    Element.setStyle(element, { display: 'none' });
    this.element = element;
    document.body.appendChild(element);
    this.callbacks = {
      onInit:       new Array(),
      beforeAppear: new Array(),
      afterAppear:  new Array(),
      beforeFade:   new Array(),
      afterFade:    new Array()
    };
    this.setup();
  },
  setup: function() { },
  setContent: function(content) {
    switch (typeof content) {
      case 'string':
        this.element.innerHTML = content;
        break;
      case 'function':
        content(this.element);
        break;
    }
  },
  registerCallback: function(type, callback) {
    var callbacks = this.callbacks[type];
    if (!callbacks)
      throw "Unknown callback trigger, " + type;
    callbacks.push(callback);
  },
  setStyle: function(style) {
    Object.extend(this.element.style, style);
  },
  moveTo: function(x, y) {
    this.setStyle({ left: x + 'px', top: y + 'px' });
  },
  setDepth: function(depth) {
    this.setStyle({ zIndex: depth });
  },
  getDepth: function() {
    return Element.getStyle(this.element, 'zIndex');
  },
  appear: function(options) {
    var popup = this;
    if (!this.appeared) {
      this.appeared = true;
      this.callbacks.beforeAppear.each(function(c){c(popup, options);});
      this.appearWindow(options);
      this.callbacks.afterAppear.each(function(c){c(popup, options);});
    }
  },
  appearWindow: function(options) {
    Element.show(this.element);
  },
  fade: function(options) {
    var popup = this;
    if (this.appeared) {
      this.appeared = false;
      this.callbacks.beforeFade.each(function(c){c(popup, options);});
      this.fadeWindow(options);
      this.callbacks.afterFade.each(function(c){c(popup, options);});
    }
  },
  fadeWindow: function(options) {
    Element.hide(this.element);
  },
  getElement: function() {
    return this.element;
  },
  loadPlugin: function(pluginName) {
    var pluginClass = Popup.Plugin[pluginName];
    if (!pluginClass)
      throw "Unknown plugin, " + pluginName;
    var plugin = new pluginClass();
    plugin.load(this);
    return plugin;
  }
}

Popup.Plugin = new Object();
Popup.Plugin.Base = Class.create();
Popup.Plugin.Base.prototype = {
  initialize: function()       { },
  load:       function(popup)  { }
}

Popup.Plugin.Overlay = Class.create();
Object.extend(Object.extend(
  Popup.Plugin.Overlay.prototype, Popup.Plugin.Base.prototype), {
  initialize: function() {
    this.appearOptions = {};
    this.fadeOptions   = {};
  },
  setAppearOptions: function(options) {
    this.appearOptions = options;
  },
  setFadeOptions: function(options) {
    this.fadeOptions = options;
  },
  load: function(popup) {
    popup.registerCallback('beforeAppear', function(p){
      Overlay.appear(this.appearOptions);
    });
    popup.registerCallback('afterFade', function(p){
      Overlay.fade(this.fadeOptions);
    });
  }
});
Popup.Plugin.Centered = Class.create();
Object.extend(Object.extend(
  Popup.Plugin.Centered.prototype, Popup.Plugin.Base.prototype), {
  load: function(popup) {
    popup.registerCallback('beforeAppear', function(p){
      var element = p.getElement();
      var pw = parseFloat(Element.getStyle(element, 'width' )) || 0;
      var ph = parseFloat(Element.getStyle(element, 'height')) || 0;
      var winSize = WindowState.getSize();
      var offset  = WindowState.getOffset();
      var left = (winSize.width  > pw) ? winSize.width  / 2 - pw / 2 : 0;
      var top  = (winSize.height > ph) ? winSize.height / 2 - ph / 2 : 0;
      top += offset.top;
      p.moveTo(left, top);
    });
  }
});

