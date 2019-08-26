/* Overlay version 1.0.0
 *
 * (c) 2006 Lyo Kato <lyo.kato@gmail.com>
 * Overlay is freely distributable under the terms of MIT-style license.
 *
 * This library requires the JavaScript Framework "Prototype" (version 1.4 or later).
 * For details, see http://prototype.conio.net/
/*-----------------------------------------------------------------------*/
var Overlay = Class.create();
Object.extend(Overlay, {
  Version: '1.0.0',
  useEffect: false,
  hideSelectBoxes : true,
  opacity: 0.8,
  getInstance: function() {
    if(!this.__singleton__) {
      this.__singleton__ = new Overlay();
    }
    return this.__singleton__;
  },
  defaultStyle: {
    position:        'absolute',
    top:             0,
    left:            0,
    zIndex:          50,
    width:           '100%',
    height:          '500px',
    backgroundColor: '#000000'
  },
  appear: function(options) {
    this.getInstance().appear(options);
  },
  fade: function() {
    this.getInstance().fade();
  },
  setZIndex: function(num) {
    this.setStyle({ zIndex: num });
  },
  setColor: function(color) {
    this.setStyle({ backgroundColor: color });
  },
  setStyle: function(style) {
    this.getInstance().setStyle(style);
  }
});

Overlay.prototype = {
  initialize: function() {
    var element = document.createElement('div');
    var id = 'overlay';

    if ($('overlay')) {
        //quick fix. avoid duplicated element id.
        //this class must be instantiated by singleton interface.
        //but any library instantiates this class with the new operator.
        id += (new Date()).getTime();
    }

    element.setAttribute('id', id);
    this.defaultAppearOptions = { duration: 0.4, from: 0.2, to: 0.8 };
    this.defaultFadeOptions   = { duration: 0.2 };
    Object.extend(element.style, Overlay.defaultStyle);
    Element.setOpacity(element, Overlay.opacity);
    Element.setStyle(element, { display: 'none' });
    this.element = element;
    if($('page')){
        $('page').appendChild(element);
    }else{
        document.body.appendChild(element);
    }
  },
  setStyle: function(style) {
    if (style.backgroundColor)
      Element.setStyle(this.element, { backgroundColor: style.backgroundColor });
    if (style.zIndex)
      Element.setStyle(this.element, { zIndex: style.zIndex });
  },
  appear: function(options) {
    if (Overlay.hideSelectBoxes){
      this.hideSelectBoxes();
    }
    this.resize();
    if (Overlay.useEffect) {
      new Effect.Appear(this.element, Object.extend(this.defaultAppearOptions, options||{}));
    } else {
      Element.show(this.element);
    }
    this._tmpCallback = this.resize.bind(this);
    Event.observe(window, 'resize', this._tmpCallback);
  },
  resize: function() {
    var contentSize = WindowState.getContentSize();
    Element.setStyle(this.element, { height: contentSize.height + 'px' });
  },
  fade: function(options) {
    if (Overlay.useEffect) {
      new Effect.Fade(this.element, Object.extend(this.defaultFadeOptions, options||{}));
    } else {
      Element.hide(this.element);
    }
    if (Overlay.hideSelectBoxes){
      this.showSelectBoxes();
    }
    Event.stopObserving(window, 'resize', this._tmpCallback);
    this._tmpCallback = undefined;
  },
  showSelectBoxes: function() {
    var selects = document.getElementsByTagName('select');
    $A(selects).each(function(e){ Element.setStyle(e, {visibility: 'visible'}) });
  },
  hideSelectBoxes: function() {
    var selects = document.getElementsByTagName('select');
    $A(selects).each(function(e){ Element.setStyle(e, {visibility: 'hidden'}) });
  },
  getElement: function() {
    return this.element;
  },
  setZIndex: function(num) {
    this.setStyle({ zIndex: num });
  }
};

