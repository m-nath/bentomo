TextInserter = Class.create();
TextInserter.prototype = {

    /**
    *    Constructor
    *
    *    @param    element the textarea element
    *    @param    mode    a browser mode
    */
    initialize: function(element,mode){
        this.textelement = element;
        this.start = 0;
        this.sel = null;
        this.rang = null;
        this.mode = mode;

        if (this.mode == 1 || this.mode == 4) {
            if (navigator.userAgent.indexOf('Sony/COM2') != -1) {
                this.start = element.value.length;
            }else {
                this.start = element.selectionStart;
            }
        }
        else if (this.mode == 2) {
            this.textelement.focus();
            this.sel = document.selection.createRange();
            this.rang = element.createTextRange();
            this.start = element.selectionStart;
            this.rang.moveToPoint(this.sel.offsetLeft,this.sel.offsetTop);
            this.rang.moveEnd("textedit");
            if(this.rang.text.replace(/\r/g,"").length != 0){
                var las = (element.value.match(/(\r\n)*$/),RegExp.lastMatch.length);
                this.start = (element.value.length - (this.rang.text.length + las));
            }else{
                this.start = (element.value.length - (this.rang.text.length));
            }
        }else{
            this.start = element.value.length;
        }

    },

    /**
    *    adds text to the specified position.
    *    @param code insert character
    */
    insertText: function(code){
        this.textelement.focus();
        var bl1 = this.textelement.value.substring(0, this.start);
        var bl2 = this.textelement.value.substring(this.start,this.textelement.value.length);
        this.textelement.value = bl1 + code + bl2;

        //If browser is InternetExplorer, revert the cursor postion.
        if (this.mode == 2) {
            this.rang.moveStart("character",bl1.length + code.length);
            this.rang.moveEnd("character",-(bl2.replace(/\r/g,"").length));
            this.rang.select();
        }
    }
};

EmojiPalette  = Class.create();

EmojiPalette.SINGLTON_OVERLAY = true;
EmojiPalette.ZINDEX = 50;

/**
*   Emoji Palette abstract class
*/
EmojiPalette.prototype = {

    /**
    *    Constructor
    *    @param    palette_name    create a palette name
    *    @param    width           palette width(size specified by css)
    *    @param    adv_x           max palette width
    *    @param    closefunction   palette close function
    */
    initialize: function(palette_name,width,adv_x,closefunction){
        this.pos_x = 0;
        this.pos_y = 10;
        this.onclick_function = closefunction;
        this.width = width;
        this.adv_x = adv_x;
        this.textinsert = null;

        this.img_server = "//img.mixi.net/";

        this.palette_name = palette_name;
        this.popup = Popup.create(this.palette_name);

        var table = $(palette_name).down('div.emoji_palette_body table');

        var tbody = new Element('tbody');
        table.appendChild(tbody);

        this._appendTableRows(tbody);

        var that = this;
        this._handleClick = function(event) {
            var palette = $j('#'+that.palette_name);
            if (! $j(event.target).closest(palette).length) {
                that.onclick_function();
            }
        };
    },

    _appendTableRows: function (table) {
        var rows = [
            [50,  59,  58,  61,  205, 209, 241, 56,  55,  60,
             206, 57,  52,  204, 53,  54,  51,  207, 242, 246 ],
            [208, 210, 46,  47,  49,  48,  65,  68,  76,  75,
             74,  78,  79,  73,  66,  67,  80,  77,  72,  71 ],
            [69,  40,  87,  41,  42,  137, 138, 141, 62,  63,
             43,  44,  103, 104, 105, 106, 107, 108, 109, 110 ],
            [111, 112, 113, 114, 237, 238, 239, 240, 243, 244,
             24,  98,  99,  236, 229, 231, 232, 22,  21,  202 ],
            [23,  235, 245, 1,   2,   101, 102, 3,   4,   5,
             6,   145, 146, 147, 148, 149, 150, 88,  184, 226 ],
            [227, 228, 230, 233, 234, 90,  91,  92,  93,  94,
             95,  116, 193, 201, 215, 115, 31,  134, 82,  29 ],
            [30,  25,  142, 191, 86,  9,   10,  7,   8,   12,
             11,  118, 119, 120, 18,  13,  89,  14,  15,  16 ],
            [17,  121, 122, 123, 124, 125, 19,  20,  26,  27,
             133, 28,  81,  32,  152, 117, 135, 154, 100, 153 ],
            [197, 196, 33,  34,  35,  97,  180, 84,  96,  181,
             136, 83,  212, 127, 128, 129, 130, 131, 143, 144 ],
            [160, 162, 176, 177, 178, 179, 182, 183, 188, 203,
             189, 192, 190, 194, 195, 198, 199, 200, 85,  132 ],
            [64,  70,  165, 166, 167, 168, 169, 170, 171, 172,
             173, 174, 175, 164, 163, 126, 139, 140, 151, 219 ],
            [217, 224, 225, 159, 45,  211, 36,  37,  38,  39,
             155, 157, 158, 156, 161, 185, 186, 187, 216, 220 ],
            [221, 222, 223, 218, 213, 214, 0,   0,   0,   0,
             0,   0,   0,   0,   0,   0,   0,   0,   0,   0 ]
        ];

        var palette = this;
        rows.each(function (columns) {
            var tr = new Element('tr');
            columns.each(function (n) {
                var td;
                if (n == 0) {
                    td = new Element('td');
                } else {
                    td = new Element('td', { 'class': 'sprite-' + n });
                    td.appendChild(palette._createAnchor(n));
                }
                tr.appendChild(td);
            });
            table.appendChild(tr);
        });
    },

    _createAnchor: function (n) {
        var img = new Element('img', {
            id: 'plt' + n,
            alt: '',
            src: this.img_server + 'img/dot0.gif'
        });

        var a = new Element('a');
        a.observe('click', function () {
            inputEmoji('m', n);
            closeEmojiPalette();
        });
        a.observe('mouseover', this.onMouseOver.bindAsEventListener(this));
        a.observe('mouseout', this.onMouseOut.bindAsEventListener(this));
        a.appendChild(img);

        img.width = '16';
        img.height = '16';

        return a;
    },



    /**
    *    Open palette
    *    @param    element     insert text element
    *    @param    event
    *    @param    x
    *    @param    y
    */
    openPalette: function(element, event, x, y, zIndex){

        this.textinsert = new TextInserter(element,get_mode());

        var x = 0;
        var y = 0;
        x = (typeof(x) == 'undefined' || x  == null) ? this.pos_x : x;
        y = (typeof(y)   == 'undefined' || y   == null) ? this.pos_y : y;

        var mouse = Event.pointer(event);
        var pageOffset = Position.cumulativeOffset($('page'));

        this.showPalette();
        this.pos_x   = mouse.x - pageOffset[0] + x;
        this.pos_y   = mouse.y - pageOffset[1] + y;

        var limit_x  = this.adv_x - this.width;

        if (this.pos_x > limit_x) {
            this.pos_x -= (this.pos_x - limit_x);
        }

        $j('#' + this.palette_name).css({
            left:   this.pos_x + 'px',
            top:    this.pos_y + 'px',
            zIndex: zIndex || EmojiPalette.ZINDEX
        }).show();
        $j(document.body).on('click', this._handleClick);

        // Don't call "this._handleClick" from here
        $j.event.fix(event).stopImmediatePropagation();

        //emoji access count
        new Ajax.Request(
            '/log_emoji_openpalette.pl?' + (new Date().getTime()),
            {
                method: 'get'
            });
    },

    closePalette: function(){
        $j('#' + this.palette_name).hide();
        $j(document.body).off('click', this._handleClick);
    },


    /**
    *    insert character
    *    @param code insert character
    */
    inputEmoji: function(code){
        //IE need focus to textelement before deferred function call.
        var isIE = (/MSIE/).test(navigator.userAgent);
        if (isIE) {
            this.textinsert.textelement.focus();
        }
        this.textinsert.insertText.bind(this.textinsert, code).defer();
    },
  onMouseOut:function(e){
    var target = Event.element(e);
    target.src = this.img_server + 'img/dot0.gif';
  },
  onMouseOver:function(e){
    var target = Event.element(e);
    target.src = this.img_server + 'img/mouse_over03.gif';
  },
  onClick:function(e){
    this.closePalette();
  },
  setPaletteTitle:function(title){
    $("emoji_palette_title_left").innerHTML = unescape("%u3000%u7D75%u6587%u5B57");
  }
};


/**
*    Imode palette class
*/
ImodeEmojiPalette = Class.create();
ImodeEmojiPalette.prototype =
{
    initialize: function(palette_name,width,adv_x,closefunction){        
        this.pos_x = 0;
        this.pos_y = 10;
        this.onclick_function = closefunction;
        this.width = width;
        this.adv_x = adv_x;
        this.textinsert = null;
        this.emoji_array = [];
        this.emoji_img_array = [];
        this.palette_name = palette_name;
        this.popup = Popup.create(this.palette_name);
    },
    /**
    *    Display of palette contents
    */
    showPalette: function() {
        Element.show(this.palette_name);
    }
};

Object.extend(ImodeEmojiPalette.prototype,EmojiPalette.prototype);


/**
*    Ads palette class
*/
AdsEmojiPalette = Class.create();
AdsEmojiPalette.prototype =
{
    initialize: function(palette_name,width,adv_x,closefunction,ads_array){

        this.pos_x = 0;
        this.pos_y = 10;
        this.onclick_function = closefunction;
        this.width = width;
        this.adv_x = adv_x;
        this.textinsert = null;
        this.emoji_array = [];
        this.emoji_img_array = [];

        this.ads_emoji_array = [];
        this.ads_emoji_array_a = [];
        this.ads_emoji_img_array = [];

        this.ads_html = null;

        this.ads_link = null;

        this.ads_dir = null;
        this.ads_area = null;

        this.palette_name = palette_name;
        this.popup = Popup.create(this.palette_name);
    },

    set_ads_array: function(array,array_a){
        this.ads_emoji_array = array;
        this.ads_emoji_array_a = array_a;
        this.ads_emoji_img_array = [];
    },

    set_ads_html: function(html){
        this.ads_html = html;
    },

    set_ads_link: function(src,link){
      if(link){
        var a=document.createElement('a');
        a.setAttribute('target','_blank');
        a.setAttribute('href',link);
        var img=document.createElement('img');
        img.setAttribute('src',src);
        img.style.marginTop = "10px";
        a.appendChild(img);
        this.ads_link = a;
      }else{
        var img=document.createElement('img');
        img.setAttribute('src',src);
        img.style.marginTop = "10px";
        this.ads_link = img;
      }
    },
     set_ads_dir: function(dir){
        this.ads_dir = dir;
    },
    set_ads_area: function(ads_area){
      this.ads_area = $(ads_area);
    },
    /**
    *   image load with css sprite
    */
    load_ads_table: function(){

      for(var i_img = 0; i_img < this.ads_emoji_array.length; i_img++){
        this.ads_emoji_img_array[i_img] = new Image();
        this.ads_emoji_img_array[i_img].src = this.img_server + "img/emoji/" + this.ads_dir + this.ads_emoji_array[i_img] + ".gif";
      }

      if(this.ads_link){
        var tr = document.createElement("tr");
        var td = document.createElement("td");
        td.setAttribute('colSpan','20');
        td.appendChild(this.ads_link);
        tr.appendChild(td);
        this.ads_area.appendChild(tr);
      }

      i = 0; j=0; current = 0;
      while(i < Math.floor(this.ads_emoji_img_array.length / 20) + 1) {
        var tr = document.createElement("tr");
        while(j < 20) {
          if(current >= this.ads_emoji_img_array.length ){
            var td = document.createElement("td");
            tr.appendChild(td);
          }else{

            var td = document.createElement("td");
            td.style.width="16px";
            td.style.height="16px";
            td.style.backgroundImage = "url('" + this.ads_emoji_img_array[current].src + "')";

            var a=document.createElement('a');
            a.setAttribute('href','javascript:inputEmoji(\'a\',' + this.ads_emoji_array_a[current]+ ')');

            Event.observe(a,'click',this.onClick.bind(this));
            Event.observe(a,'mouseover', this.onMouseOver.bind(this));
            Event.observe(a,'mouseout', this.onMouseOut.bind(this));

            var img=document.createElement('img');
            img.style.width="16px";
            img.style.height="16px";
            img.setAttribute('border','0');
            img.setAttribute('id','plt' + this.ads_emoji_array_a[current]);
            img.src = this.img_server + "img/dot0.gif";
            a.appendChild(img);
            td.appendChild(a);
            tr.appendChild(td);
          }
          current++;
          j++;
        }
        this.ads_area.appendChild(tr);
        j=0;
        i++;
      }

    },

    /**
    *    Display of palette contents
    */
    showPalette: function() {
        Element.show(this.palette_name);
    }
};

Object.extend(AdsEmojiPalette.prototype,EmojiPalette.prototype);
