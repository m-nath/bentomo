Mixi.Common.Namespace.createNamespace('Mixi.Common.EmojiPaletteLoader',function(ns){
    var EMOJI_PALETTE_TEMPLATE  = 'component_emoji_palette';
    this.emojiPaletteLoaded = false;
    this.isShowed           = false;

    this.loadEmojiPalette = function () {
        if (this.emojiPaletteLoaded) {
            return;
        }
        this.emojiPaletteBase = new Element('div' , {'class' : 'emoji_palette', 'id' : 'emoji_palette'});
        var configImgBase =  Mixi.Gateway.getParam('CONFIG_IMG_BASE') || '';
        var template = new HTML.Template($(EMOJI_PALETTE_TEMPLATE));
        template.param({'CONFIG_IMG_BASE' : configImgBase});
        var emojiPalette = template.output();
        if (emojiPalette) {
            this.emojiPaletteBase.update(emojiPalette);
        }
        $('page').insert(this.emojiPaletteBase);
        this.emojiPaletteLoaded = true;
    };
    this.getEmojiPaletteBase = function () {
        if (this.emojiPaletteBase) {
            return this.emojiPaletteBase;
        }
        else {
            throw('EmojiPaletteLoader needs loadEmojiPalette');
        }
    };
    this.openEmojiPalette = function (element, event, zIndex) {
        this.isShowed = true;
        window.openEmojiPalette(element, event, zIndex);
    };
    this.closeEmojiPalette = function (event) {
        this.isShowed = false;
        window.closeEmojiPalette(event);
    };
    this.isShowPalette = function () {
        return this.isShowed;
    };
});

Namespace('jp.co.mixi.emojiPaletteLoader')
.define(function (ns) {
    ns.provide({
        EmojiPaletteLoader : function () { return Mixi.Common.EmojiPaletteLoader; }
    });
});
