var emoji_palette;

Event.observe(window, 'load', initializeEmojiPalette);

function initializeEmojiPalette() {
  if($('emoji_palette')){
    emoji_palette = 
    new ImodeEmojiPalette(
      'emoji_palette',364,714,
      function() { closeEmojiPalette() }
    );
    emoji_palette.setPaletteTitle();
  }
}

function openEmojiPalette(element,event, zIndex) {
  if (!emoji_palette) {
    initializeEmojiPalette();
  }
  emoji_palette.openPalette(element,event,0,10,zIndex);
}

function closeEmojiPalette(event) {
  emoji_palette.closePalette();
}

function inputEmoji(head,num){
  var code = "[" + head + ":" + num + "]";
  emoji_palette.inputEmoji(code);    
}

function onMouseOut(_target){
  var target = $(_target);
  target.src = emoji_palette.img_server + 'img/dot0.gif';
}

function onMouseOver(_target){
  var target = $(_target);
  target.src = emoji_palette.img_server + 'img/mouse_over03.gif';
}

