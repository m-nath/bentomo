Namespace('jp.co.mixi.gateway')
.define(function(ns){ns.provide({gateway:function(name){return window.Mixi?Mixi.Gateway.getParam(name):undefined;},getAllGatewayData:function(){return window.Mixi?Mixi.Gateway.getParam():undefined;}});});Namespace('jp.co.mixi.dom.dataset.converter')
.define(function(ns){'use strict';ns.provide({booleanize:function(v){if(v==='')return false;if(v==='1')return true;if(v==='0')return false;if(v==='true')return true;if(v==='false')return false;throw new Error('cannot convert boolean');}});});Namespace('jp.co.mixi.dom.dataset.formatter')
.use('jp.co.mixi.dom.dataset.converter booleanize')
.use('jp.co.mixi.dom.dataset.parametername trimParameter')
.use('jp.co.mixi.dom.dataset.validator isValidDataset')
.define(function(ns){'use strict';var typeConverterMap={string:function(v){return v;},number:function(v){return parseInt(v,10);},'boolean':ns.booleanize};ns.provide({format:function(format,dataset){if(!ns.isValidDataset(format,dataset)){throw new Error('invalid dataset');}
var formattedDataset={};_.each(format,function(value,key){var trimmedKey=ns.trimParameter(key);var data=dataset[trimmedKey];if(!_.isUndefined(data)){formattedDataset[trimmedKey]=typeConverterMap[value](data);}});return formattedDataset;}});});Namespace('jp.co.mixi.dom.dataset.validator')
.use('jp.co.mixi.dom.dataset.converter booleanize')
.use('jp.co.mixi.dom.dataset.parametername isOptionalParameter,trimParameter')
.define(function(ns){'use strict';var isBoolean=function(v){try{ns.booleanize(v);return true;}
catch(e){return false;}};var isNumber=function(v){return!_.isNaN(parseInt(v,10));};var typeValidatorMap={string:_.isString,number:isNumber,'boolean':isBoolean};ns.provide({isValidDataset:function(format,dataset){if(_.isUndefined(dataset))return false;var invalids=_.filter(format,function(value,key){var param=ns.trimParameter(key);if(ns.isOptionalParameter(key)&&_.isUndefined(dataset[param])){return false;}
return!typeValidatorMap[value](dataset[param]);});return(invalids.length==0);}});});Namespace('jp.co.mixi.dom.dataset.parametername')
.define(function(ns){'use strict';var isOptional=function(key){return key.charAt(0)=='*';};var trim=function(key){return isOptional(key)?key.substring(1):key;};ns.provide({isOptionalParameter:isOptional,trimParameter:trim});});Namespace('jp.co.mixi.ui.textareawithplaceholder')
.define(function(ns){var _placeholderClass;var _defaultText;var _modifyClass=function(element,method,classElement){if(!classElement)return;$j(element)[method](classElement);};var initializePlaceholder=function(element){_placeholderClass=$j(element).attr('data-placeholder-class');_defaultText='defaultText';var activatePlaceholder=function(){$j(element).val($j(element).attr("data-placeholder"));_modifyClass(element,'addClass',_placeholderClass);_modifyClass(element,'addClass',_defaultText);};var initialize=function(){var _placeholder=$j(element).attr("data-placeholder");if($j(element).val()===""||$j(element).val()===_placeholder){activatePlaceholder();}else{_modifyClass(element,'removeClass',_placeholderClass);_modifyClass(element,'removeClass',_defaultText);}};$j(element).bind('focus',function(){setTimeout(function(){clearTextarea(element);},100);_modifyClass(element,'removeClass',_placeholderClass);_modifyClass(element,'removeClass',_defaultText);});$j(element).bind('blur',function(){var _placeholder=$j(element).attr("data-placeholder");if($j(element).val()===""||$j(element).val()===_placeholder){activatePlaceholder();}});$j(window).ready(initialize);initialize();};var updatePlaceholder=function(element,v){if(!_.isString(v))return;if($j(element).val()===$j(element).attr('data-placeholder')){$j(element).val(v);}
$j(element).attr('data-placeholder',v);};var clearTextarea=function(element){if($j(element).val()===$j(element).attr('data-placeholder')){$j(element).val('');}};ns.provide({initializePlaceholder:initializePlaceholder,updatePlaceholder:updatePlaceholder,clearTextarea:clearTextarea});});Namespace('jp.mixi.featuredcontents.ui.searchform')
.use('jp.co.mixi.gateway gateway')
.use('jp.co.mixi.ui.textareawithplaceholder clearTextarea')
.define(function(ns){"use strict";var UTF8_SEARCH_TYPES=['search_page','search_game_smartphone'];var MAP_TYPE_TO_FORM_SELECTOR={'search_meta':'.JS_formMetaSearch','search_comm':'.JS_formCommunitySearch','search_game':'.JS_formGameSearch','search_game_smartphone':'.JS_formGameSearchSmartphone','search_appli':'.JS_formAppliSearch','search_page':'.JS_formPageSearch','search_profile':'.JS_formProfileSearch','search_school':'.JS_formSchoolSearch','search_mykeyword':'.JS_formMyKeywordSearch','search_news':'.JS_formNewsSearch','search_item':'.JS_formItemSearch','search_diary':'.JS_formDiarySearch','search_voice':'.JS_formVoiceSearch','search_help':'.JS_formHelpSearch'};var _root,_selectorSelect,_selectorTextField,_selectorSubmitButton,_selectorForm;var getInitializedForm=function(searchType){if(searchType==="select"){alert("\u691c\u7d22\u3059\u308b\u30b5\u30fc\u30d3\u30b9\u3092\u9078\u629e\u3057\u3066\u304f\u3060\u3055\u3044");}
var form=_root.find(getMapTypeToFormSelector(searchType));if(_.isEmpty(form))return;ns.clearTextarea(_root.find(_selectorTextField)[0]);var searchText=_root.find(_selectorTextField).val();form.find(getInputNameValue(searchType)).val(searchText);return form;};var submitSelectedForm=function(searchType,isMoreSearch,formInitializer){if(!_.isFunction(formInitializer)){formInitializer=getInitializedForm;}
var form=formInitializer(searchType);if(isMoreSearch){form.append("<input type='hidden' name='is_more' value='1'>");}else{form.find("input[name='is_more']").remove();}
var backCharset=document.charset;if(isSearchTypeForUTF8(searchType)){try{document.charset='UTF-8';}catch(e){}}else{try{document.charset='EUC-JP';}catch(e){}}
form.acceptCharset=document.charset;form.submit();try{document.charset=backCharset;}catch(e){}};var observeTypeChangeEvent=function(proc){_root.find(_selectorSelect).bind('change',proc);};var getDefaultSearchType=function(){var href=document.location.href;var mixi_prefix_regexp='('+ns.gateway('url_mixi_prefix')+'|'+ns.gateway('url_mixi_prefix_ssl')+')';var map={"search_meta":'^'+mixi_prefix_regexp+'meta_search',"search_comm":'^'+mixi_prefix_regexp+'search_community',"search_game":'^'+mixi_prefix_regexp+'(search_appli_result.*is_game=1|search_game)',"search_appli":'^'+mixi_prefix_regexp+'search_appli_result.*is_game=0',"search_page":'^'+ns.gateway('url_fan_prefix'),"search_profile":'^'+mixi_prefix_regexp+'search_profile',"search_school":'^'+mixi_prefix_regexp+'search_school',"search_mykeyword":'^'+mixi_prefix_regexp+'search_mykeyword',"search_friend_mail":'^'+mixi_prefix_regexp+'search_friend_mail',"search_news":'^'+ns.gateway('url_news_prefix_ssl')+'search_news',"search_item":'^'+mixi_prefix_regexp+'search_item',"search_diary":'^'+mixi_prefix_regexp+'search_diary',"search_voice":'^'+mixi_prefix_regexp+'search_voice',"search_help":'^'+mixi_prefix_regexp+'search_help'};_.each(map,function(regexpString,searchType){var regexp=new RegExp(regexpString);if(regexp.test(href)){return searchType;}});};var initialize=function(element,dataset){_root=$j(element);_selectorSelect=dataset.formSelect;_selectorTextField=dataset.formTextField;_selectorSubmitButton=dataset.formSubmit;_selectorForm=dataset.form;};var getMapTypeToFormSelector=function(searchType){return MAP_TYPE_TO_FORM_SELECTOR[searchType];};var getInputNameValue=function(searchType){var inputNameValue='input[name=keyword]';if(searchType==='search_mykeyword'){inputNameValue='input[name=mykeyword]';}else if(searchType==='search_friend_mail'){inputNameValue='input[name=mail]';}else if(searchType==='search_game_smartphone'){inputNameValue='input[name=term]';}
return inputNameValue;};var isSearchTypeForUTF8=function(searchType){return _.contains(UTF8_SEARCH_TYPES,searchType);};ns.provide({initializeSearchForm:initialize,getInitializedForm:getInitializedForm,submitSelectedForm:submitSelectedForm,observeTypeChangeEvent:observeTypeChangeEvent,getDefaultSearchType:getDefaultSearchType,getMapTypeToFormSelector:getMapTypeToFormSelector,getInputNameValue:getInputNameValue,isSearchTypeForUTF8:isSearchTypeForUTF8});});Namespace('jp.mixi.featuredcontents.pc.widget.searchform')
.use('brook promise')
.use('brook.channel observeChannel')
.use('brook.dom.compat dataset')
.use('jp.co.mixi.ui.textareawithplaceholder initializePlaceholder,updatePlaceholder')
.use('jp.mixi.featuredcontents.ui.searchform initializeSearchForm,submitSelectedForm,getDefaultSearchType,observeTypeChangeEvent')
.define(function(ns){var _rootElement,_selectorSelect,_selectorCategory,_selectorTextField,_selectorSubmitButton;var _isOpen=false;var _pulldownMenuFocus=false;var getSearchType=function(){return $j(_rootElement).find(_selectorSelect).children().first().attr('value');};var observeSubmitEvent=function(){var submitEvent=function(){var searchType=getSearchType();if(_.isNull(searchType))return;ns.submitSelectedForm(searchType);};$j(_rootElement).find(_selectorSubmitButton).bind('click',submitEvent);$j(_rootElement).find(_selectorTextField).bind('keypress',function(e){if(e.keyCode!==13)return;submitEvent();});var isTextFieldEmpty=function(){var text=$j(_rootElement).find(_selectorTextField).val();return text===$j(_rootElement).find(_selectorTextField).attr('data-placeholder');};$j(document).bind('keypress',function(e){if(e.keyCode!==13)return;if(!_pulldownMenuFocus)return;if(isTextFieldEmpty())return;submitEvent();});};var initializePulldownMenu=function(){var pulldownMenu=$j(_rootElement).find(_selectorSelect).children()[0];$j(pulldownMenu).bind('click',function(){_pulldownMenuFocus=true;if(_isOpen){_close();}else{_open();}});setSelectorCategoryElementClickEvent();setBlurEvent();};var _close=function(){_isOpen=false;$j(_rootElement).find(_selectorCategory).hide();};var _open=function(){_isOpen=true;$j(_rootElement).find(_selectorCategory).show();};var setSelectorCategoryElementClickEvent=function(){$j(_rootElement).find(_selectorCategory).children().bind('click',function(){var placeholderString=$j(this).attr('data-placeholder-text');ns.updatePlaceholder($j(_rootElement).find(_selectorTextField)[0],placeholderString);_close();updateSelectorSelect(this);});};var __isChildOf=function(parent,child){if(parent===child){return false;}
while(child&&child!==parent){child=child.parentNode;}
return child===parent;};var setBlurEvent=function(){$j(document).bind('click',function(e){var span=$j(_rootElement).find(_selectorSelect).children()[0];var isCategoryClicked=__isChildOf(span,e.target)||(span===e.target);if(isCategoryClicked){return;}
var categoryElements=$j(_rootElement).find(_selectorCategory);for(var i=0,l=categoryElements.length;i<l;i++){var isListClicked=__isChildOf(categoryElements[i],e.target);if(isListClicked){return;}}
_close();_pulldownMenuFocus=false;});};var updateSelectorSelect=function(element){var selectorSelect=$j(_selectorSelect).children().first();$j(selectorSelect).attr('value',element.getAttribute('value'));$j(selectorSelect).text($j(element).attr('data-placeholder'));$j(selectorSelect).attr('data-placeholder',$j(element).attr('data-placeholder-text'));};var setDefaultSelectorSelect=function(type){var categoryElements=$j(_rootElement).find(_selectorCategory).children();for(var i=0,l=categoryElements.length;i<l;i++){var element=categoryElements[i];if(element.getAttribute('value')===type){updateSelectorSelect(element);return;}}};var _getParam=function(paramName){var str=location.search.substring(1);var params=str.split('&');for(var i=0,l=params.length;i<l;i++){value=params[i].split('=');if(value[0]===paramName){return value[1];}}
return'';};var _appli=function(){switch(_getParam("is_game")){case'0':return'search_appli';case'1':return'search_game';default:return'search_appli';}};var urlToSearchType=function(url){var reg=new RegExp(".+\\/(.+?)\\.pl");var regexec=reg.exec(url);if(!regexec)return"";var pl=regexec[1];var mapPlToType={'search_community':'search_comm','search_game':'search_game','search_appli':'search_appli','search_page':'search_page','search_profile':'search_profile','search_school':'search_school','search_mykeyword':'search_mykeyword','search_friend_mail':'search_friend_mail','search_news':'search_news','search_item':'search_item','list_review':'list_review','search_diary':'search_diary'};if(pl==='search_appli_result'){return _appli();}
return mapPlToType[pl]?mapPlToType[pl]:'';};var setDefaultToPlaceholderText=function(){var _selectorSelectElement=$j(_rootElement).find(_selectorSelect).children()[0];var placeholderString=ns.dataset(_selectorSelectElement).placeholder;ns.updatePlaceholder($j(_rootElement).find(_selectorTextField)[0],placeholderString);};var initialize=function(element,dataset){$j(window).bind('beforeunload',function(){try{document.charset=Mixi.Gateway.getParam('page_encoding');}catch(e){}});ns.initializeSearchForm(element,dataset);_rootElement=element;_selectorSelect=dataset.formSelect;_selectorCategory=dataset.formCategory;_selectorTextField=dataset.formTextField;_selectorSubmitButton=dataset.formSubmit;observeSubmitEvent();ns.observeTypeChangeEvent(setDefaultToPlaceholderText);var defaultType=ns.getDefaultSearchType();var validLocation=location.protocol+'//'+location.host+'/';if(location.href.indexOf(validLocation)===0){var type=urlToSearchType(location.href);if(type!==''){defaultType=type;}}
if(defaultType!==""){setDefaultSelectorSelect(defaultType);}
ns.initializePlaceholder($j(_rootElement).find(_selectorTextField)[0]);$j(_rootElement).find(_selectorSelect).trigger('change');initializePulldownMenu();ns.observeChannel('home.pc.homeview.open',hideSearchForm);ns.observeChannel('home.pc.homeview.close',showSearchForm);ns.observeChannel('home.pc.diaryeditor.close',showSearchForm);ns.observeChannel('home.pc.diaryeditor.open',hideSearchForm);};var showSearchForm=ns.promise().bind(function(next,value){$j(".searchBox").show();});var hideSearchForm=ns.promise().bind(function(next,value){$j(".searchBox").hide();});ns.provide({registerElement:initialize});});Namespace('jp.mixi.menu.widget.pc.header')
.use('jp.co.mixi.dom.dataset.formatter format')
.define(function(ns){'use strict';var DEFAULT_DRAWER_BOTTOM_MARGIN=20;function initializeElement(element,dataset){var datasetFormat={'globalNavi':'string','drawer':'string','drawerToggleButton':'string','drawerHeaderArea':'string','drawerMenuArea':'string','*drawerBottomMargin':'number','drawerToggleButtonToggleClass':'string'};var data=ns.format(datasetFormat,dataset);var headerArea=$j(element);var globalNavi=headerArea.find(data.globalNavi);var globalNaviHeight=globalNavi.get(0).offsetHeight;var drawer=headerArea.find(data.drawer);var drawerToggleButton=headerArea.find(data.drawerToggleButton);var drawerHeaderArea=headerArea.find(data.drawerHeaderArea);var drawerMenuArea=headerArea.find(data.drawerMenuArea);var drawerBottomMargin=(data.drawerBottomMargin!==undefined)?data.drawerBottomMargin:DEFAULT_DRAWER_BOTTOM_MARGIN;drawerToggleButton.on('click',function(event){event.preventDefault();drawer.css('height','auto');drawerMenuArea.css({'height':'auto','overflow-y':'visible'});drawer.toggle();drawerToggleButton.toggleClass(data.drawerToggleButtonToggleClass);var windowHeight=window.innerHeight;var drawerScrollHeight=drawer.outerHeight();if(drawerScrollHeight>(windowHeight-globalNaviHeight)){var drawerHeight=windowHeight-globalNaviHeight-drawerBottomMargin;var drawerHeaderScrollHeight=drawerHeaderArea.outerHeight();var drawerMenuAreaHeight=drawerHeight-drawerHeaderScrollHeight;drawer.css('height',drawerHeight+'px');drawerMenuArea.css({'overflow-y':'scroll','height':drawerMenuAreaHeight+'px',});}});$j(document).on('click',function(event){var target=$j(event.target);var hasDrawer=target.closest(data.drawer).length>0;var hasDrawerTogglerButton=target.closest(data.drawerToggleButton).length>0;if(!hasDrawer&&!hasDrawerTogglerButton){drawerToggleButton.removeClass(data.drawerToggleButtonToggleClass);drawer.hide();}});$(drawerHeaderArea).on('wheel',function(event){event.preventDefault();event.stopPropagation();return false;});$(drawerMenuArea).on('wheel',function(event){var element=$j(this);var scrollHeight=this.scrollHeight;var apparentHeight=element.outerHeight();var scrollingLeft=scrollHeight-apparentHeight-this.scrollTop;var delta=event.originalEvent.deltaY;var goingUp=delta<0;if(!goingUp&&delta>scrollingLeft){element.scrollTop(this.scrollHeight);event.preventDefault();event.stopPropagation();return false;}else if(goingUp&&-delta>this.scrollTop){element.scrollTop(0);event.preventDefault();event.stopPropagation();return false;}});}
ns.provide({registerElement:initializeElement});});Namespace('jp.mixi.menu.widget.pc.accountbox')
.define(function(ns){'use strict';function initializeElement(element,dataset){element=$j(element);var togglerElement=element.find(dataset.togglerElement||undefined);var menuElement=element.find(dataset.menuElement||undefined);togglerElement.on('click',function(event){menuElement.toggle();event.preventDefault();});$j(document).on('click',function(event){var target=$j(event.target);var isToggler=target.closest(togglerElement).get(0);var isMenu=target.closest(menuElement).get(0);if(!isToggler&&!isMenu){menuElement.hide();}});}
ns.provide({registerElement:initializeElement});});