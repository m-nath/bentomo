Namespace('jp.mixi.adnetwork.google.model.adexchange')
.use('brook promise')
.use('brook.util through')
.use('brook.model createModel')
.define(function(ns){'use strict';var model;var loadScript=ns.through(_.once(function(value){var script=document.createElement('script');script.src='//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js';script.async=true;value.element.appendChild(script);}));var addParam=ns.through(function(value){(window.adsbygoogle=window.adsbygoogle||[]).push(value.param);});var getModel=function(){if(model)return model;model=ns.createModel({add:ns.promise().bind(loadScript,addParam)});return model;};ns.provide({getModel:getModel});});Namespace('jp.mixi.adnetwork.google.model.dfp')
.use('jp.mixi.adnetwork.script.loader getScriptLoader')
.define(function(ns){'use strict';var DFP_SCRIPT='//securepubads.g.doubleclick.net/tag/js/gpt.js';var isLoaded=false;var isApsLoaded=false;var isPrebidLoaded=false;var setIsLoaded=function(flag){isLoaded=flag;};var loadDfpScript=function(element){if(isLoaded)return;if(!_.isElement(element)){throw new Error('element is required');}
var scriptLoader=ns.getScriptLoader();scriptLoader.load(DFP_SCRIPT,element);isLoaded=true;};var prepareApsSlot=function(slotId,slotName,sizes,onReady){if(!isApsLoaded){!function(a9,a,p,s,t,A,g){if(a[a9])return;function q(c,r){a[a9]._Q.push([c,r])}a[a9]={init:function(){q("i",arguments)},fetchBids:function(){q("f",arguments)},setDisplayBids:function(){},targetingKeys:function(){return[]},_Q:[]};A=p.createElement(s);A.async=!0;A.src=t;g=p.getElementsByTagName(s)[0];g.parentNode.insertBefore(A,g)}("apstag",window,document,"script","//c.amazon-adsystem.com/aax2/apstag.js");apstag.init({pubID:'a3e4c7ef-96b9-4316-96b7-986885a2be83',adServer:'googletag'});isApsLoaded=true;}
apstag.fetchBids({slots:[{'slotID':slotId,'slotName':slotName,'sizes':sizes}],timeout:2000},function(bids){googletag.cmd.push(function(){apstag.setDisplayBids();onReady();});});};var preparePrebidSlot=function(element,prebidParams,onReady){var slotId=element.id;if(!isPrebidLoaded){var scriptLoader=ns.getScriptLoader();scriptLoader.load('https://img.ak.impact-ad.jp/ic/pone/commonjs/prebid.js',element);isPrebidLoaded=true;}
var adUnits=[];for(var size in prebidParams){adUnits.push({code:slotId,mediaTypes:{banner:{sizes:size.split('x')}},bids:prebidParams[size]});}
var PREBID_TIMEOUT=1000;window.pbjs=window.pbjs||{};var pbjs=window.pbjs;pbjs.que=pbjs.que||[];pbjs.que.push(function(){var customGranularity={'buckets':[{'min':0,'max':2000,'increment':0.1}]};pbjs.setConfig({priceGranularity:customGranularity,userSync:{filterSettings:{iframe:{bidders:'*',filter:'include'}}},currency:{adServerCurrency:'JPY',conversionRateFile:'https://currency.prebid.org/latest.json',bidderCurrencyDefault:{yieldone:'JPY',rubicon:'USD',pubmatic:'USD',aja:'USD'},defaultRates:{USD:{JPY:100}}}});pbjs.bidderSettings={pubmatic:{bidCpmAdjustment:function(bidCpm){return bidCpm*.9;}}};pbjs.requestBids({adUnits:adUnits,bidsBackHandler:initAdserver});});var initAdserverSet=false;function initAdserver(){if(initAdserverSet)return;initAdserverSet=true;googletag.cmd.push(function(){pbjs.que.push(function(){pbjs.setTargetingForGPTAsync([slotId]);onReady();});});}
setTimeout(function(){initAdserver();},PREBID_TIMEOUT);};ns.provide({loadDfpScript:loadDfpScript,prepareApsSlot:prepareApsSlot,preparePrebidSlot:preparePrebidSlot,setIsLoaded:setIsLoaded});});Namespace('jp.mixi.adnetwork.google.model.dfp.slot.builder')
.use('jp.co.mixi.lang.class defineClass')
.use('jp.co.mixi.lang.string toQueryParams')
.define(function(ns){'use strict';var AD_THRESHOLD_WIDTH=342;var AD_SLOT_ID_SEPARATOR='-';var adSlotIdCounter={};window.Adomik=window.Adomik||{};var Adomik=window.Adomik;Adomik.randomAdGroup=Adomik.randomAdGroup||function(){var rand=Math.random();switch(false){case!(rand<0.09):return"ad_ex"+(Math.floor(100*rand));case!(rand<0.10):return"ad_bc";default:return"ad_opt";}};var SlotBuilder=ns.defineClass({initialize:function(element,dataset,googletag){this.element=element;this.dataset=dataset;this.googletag=(typeof googletag==='undefined')?window.googletag:googletag;this.isResponsible=!!parseInt(this.dataset.isResponsible,10);this.isMultiSizeResponsible=!!parseInt(this.dataset.isMultiSizeResponsible,10);this.useSequentialSlotId=!!parseInt(this.dataset.useSequentialSlotId,10);this.isFluid=!!parseInt(this.dataset.isFluid,10);},collapseEmptyDiv:function(){return(typeof this.dataset.collapseEmptyDiv==='undefined')?true:!!parseInt(this.dataset.collapseEmptyDiv,10);},getClientId:function(){return'/'+this.dataset.adClient+'/'+this.dataset.adChannel;},getAdSlot:function(){if(typeof this._adSlot!=='undefined'){return this._adSlot;}
if(this.useSequentialSlotId){if(typeof adSlotIdCounter[this.dataset.adSlot]==='undefined'){adSlotIdCounter[this.dataset.adSlot]=0;}
adSlotIdCounter[this.dataset.adSlot]++;this._adSlot=this.dataset.adSlot+AD_SLOT_ID_SEPARATOR+adSlotIdCounter[this.dataset.adSlot];this.element.id=this._adSlot;}else{this._adSlot=this.dataset.adSlot;}
return this._adSlot;},getMultiSizeArray:function(sizes){var sizeArray=sizes.split(',');return _.map(sizeArray,function(value,index,array){var wh=value.split('x').map(function(item){return parseInt(item,10);});if(wh[0]==0){return'fluid';}
return wh;});},getSize:function(){if(this.dataset.imageSize){return this.getMultiSizeArray(this.dataset.imageSize);}
return[parseInt(this.dataset.adWidth,10),parseInt(this.dataset.adHeight,10)];},defaultAdSlot:function(){var clientId=this.getClientId();var size=this.getSize();return this.googletag.defineSlot(clientId,size,this.getAdSlot());},responsibleAdSlot:function(){var clientId=this.getClientId();var parsedAdMinWidth=parseInt(this.dataset.adMinWidth,10);var parsedAdMinHeight=parseInt(this.dataset.adMinHeight,10);var parsedAdMaxWidth=parseInt(this.dataset.adMaxWidth,10);var parsedAdMaxHeight=parseInt(this.dataset.adMaxHeight,10);var parsedAdThresholdWidth=parseInt(this.dataset.adThresholdWidth,10);var parsedAdThresholdHeight=parseInt(this.dataset.adThresholdHeight,10);var size=[[parsedAdMinWidth,parsedAdMinHeight],[parsedAdMaxWidth,parsedAdMaxHeight]];var adSlot=this.googletag.defineSlot(clientId,size,this.getAdSlot());var mapping=this.googletag.sizeMapping()
.addSize([parsedAdThresholdWidth,parsedAdThresholdHeight],[parsedAdMaxWidth,parsedAdMaxHeight])
.addSize([0,0],[parsedAdMinWidth,parsedAdMinHeight])
.build();adSlot.defineSizeMapping(mapping);return adSlot;},multiSizeResponsibleAdSlot:function(dataset){var clientId=this.getClientId();var sizes=this.getSize();var adSlot=this.googletag.defineSlot(clientId,sizes,this.getAdSlot());var adMinWidth=parseInt(this.dataset.adMinWidth,10);var minSizes=_.filter(sizes,function(size){return adMinWidth===size[0];});var mapping=this.googletag.sizeMapping()
.addSize([AD_THRESHOLD_WIDTH,0],sizes)
.addSize([0,0],minSizes)
.build();return adSlot.defineSizeMapping(mapping);},fluidAdSlot:function(dataset){var clientId=this.getClientId();var size='fluid';return this.googletag.defineSlot(clientId,size,this.getAdSlot());},build:function(){var adSlot;if(this.isResponsible){adSlot=this.responsibleAdSlot();}else if(this.isMultiSizeResponsible){adSlot=this.multiSizeResponsibleAdSlot();}else if(this.isFluid){adSlot=this.fluidAdSlot();}else{adSlot=this.defaultAdSlot();}
adSlot.setCollapseEmptyDiv(this.collapseEmptyDiv());if(this.dataset.pageUrl){adSlot.set('page_url',this.dataset.pageUrl);}
if(this.dataset.adtest){adSlot.set('adtest',this.dataset.adtest);}
if(this.dataset.keyValue){var pair=ns.toQueryParams(this.dataset.keyValue);for(var key in pair){adSlot.setTargeting(key,pair[key]);}}
if(this.dataset.automaticOptimization){adSlot.setTargeting('ad_h',(new Date).getUTCHours());adSlot.setTargeting('ad_group',Adomik.randomAdGroup());adSlot.setTargeting('gngp_group',[String(Math.floor(Math.random()*100))]);}
adSlot.addService(this.googletag.pubads());this.enableServices();return adSlot;},enableServices:_.once(function(){this.googletag.enableServices();})});ns.provide({SlotBuilder:SlotBuilder});});Namespace('jp.mixi.adnetwork.google.adsense.widget.loadasyncscript')
.use('jp.mixi.adnetwork.google.model.adexchange getModel')
.define(function(ns){'use strict';var registerElement=function(element,dataset){var ins=$j(element).find('.adsbygoogle')[0];var adx=ns.getModel();adx.notify('add').run({element:element,param:{element:ins}});};ns.provide({registerElement:registerElement});});Namespace('jp.mixi.adnetwork.google.dfp.widget')
.use('jp.mixi.adnetwork.google.model.dfp loadDfpScript,prepareApsSlot,preparePrebidSlot')
.use('jp.mixi.adnetwork.google.model.dfp.slot.builder SlotBuilder')
.define(function(ns){'use strict';window.googletag=window.googletag||{};var googletag=window.googletag;googletag.cmd=googletag.cmd||[];var registerElement=function(element,dataset){ns.loadDfpScript(element);if(dataset.isLazyLoad){var wait=500;var $window=$j(window);var threshold=$j(element).offset().top-$window.height();var listener=_.throttle(function(){if(threshold<=$window.scrollTop()){displaySlot(element,dataset);$window.off('scroll',listener);}},wait);$window.on('scroll',listener);listener();}
else{displaySlot(element,dataset);}};var displaySlot=function(element,dataset){var slotBuilder=new ns.SlotBuilder(element,dataset);var slotElementId=slotBuilder.getAdSlot();var slotPath=slotBuilder.getClientId();var slotSize=slotBuilder.getSize();googletag.cmd.push(function(){slotBuilder.build();});var isApsEnabled=dataset.isAmazonHeaderBiddingEnabled;var prebidParamsJSON=dataset.prebidHeaderBiddingParamsJson;var isPrebidEnabled=prebidParamsJSON?true:false;var isPrebidReady=false;var isApsReady=false;if(isPrebidEnabled||isApsEnabled){if(isPrebidEnabled){ns.preparePrebidSlot(element,JSON.parse(prebidParamsJSON),function(){isPrebidReady=true;if(!isApsEnabled||isApsReady){googletag.cmd.push(function(){googletag.display(slotElementId);});}});}
if(isApsEnabled){ns.prepareApsSlot(slotElementId,slotPath,slotSize,function(){isApsReady=true;if(!isPrebidEnabled||isPrebidReady){googletag.cmd.push(function(){googletag.display(slotElementId);});}});}}
else{googletag.cmd.push(function(){googletag.display(slotElementId);});}};ns.provide({registerElement:registerElement});});Namespace('jp.mixi.adnetwork.script.loader')
.use('jp.co.mixi.net.uri isHttpUrl')
.use('jp.co.mixi.lang.class defineClass')
.define(function(ns){'use strict';var loader;var ScriptLoader=ns.defineClass({initialize:function(){this.loadedScripts=[];},load:function(src,element,onComplete){var scriptSrc=appendProtocolIfNeeded(src);if(!ns.isHttpUrl(scriptSrc))
throw new Error('src is not url.');if(!_.isElement(element))
throw new Error('element is required.');if(_.contains(this.loadedScripts,scriptSrc)){return;}
var script=document.createElement('script');script.async=true;script.type='text/javascript';script.src=scriptSrc;if(_.isFunction(onComplete)){script.onload=script.onerror=function(){onComplete();script.onload=script.onerror=script.onreadystatechange=null;};script.onreadystatechange=function(){if(this.readyState==='loaded'||this.readyState==='complete'){onComplete();script.onload=script.onerror=script.onreadystatechange=null;}};}
element.appendChild(script);this.loadedScripts.push(scriptSrc);}});var appendProtocolIfNeeded=function(str){if(/^(https?):/i.test(str)){return str;}else{var protocol=('https:'===document.location.protocol)?'https:':'http:';return protocol+str;}};ns.provide({getScriptLoader:function(){if(loader){return loader;}
loader=new ScriptLoader();return loader;}});});