/*jshint browser:true*/
/*global Namespace:false*/
Namespace('jp.mixi.service.analysis')
.use('jp.co.mixi.gateway gateway')
.use('jp.co.mixi.lang parseIntAsDecimal')
.use('jp.co.mixi.net.jsonrpc JSONRPC')
.use('jp.co.mixi.logging Log')
.use('jp.mixi.analysis.google_analytics sendEvent')
.define(function(ns){
    var memberId = ns.parseIntAsDecimal(ns.gateway('login_member_id'));
    var postKey  = ns.gateway('rpc_post_key');

    var SAMPLING_ID = 68;
    var isSamplingId = ((memberId % 100) === SAMPLING_ID);
    var rpc = ns.JSONRPC.createService('/system/rpc.json',{ auth_type : 'postkey', secret : postKey});
    var isDebug   = ns.gateway('RUN_MODE') == 'debug';
    var isStaging = ns.gateway('RUN_MODE') == 'staging';

    var DEFAULT_ACTION = "click";

    ns.provide({
        postAnalysisLog: function(locationParam){
            if(!locationParam) {
                return;
            }

            if(!isSamplingId && !isDebug) {
                return;
            }

            rpc.call('jp.mixi.analysis.analysisOfClickCount',{
                member_id : memberId,
                location  : locationParam
            }, function() {});
        },
        postUIEventLog: function(eventName, pageName, callback, errorCallback){
            if(!eventName) {
                return;
            }

            rpc.call('jp.mixi.analysis.uievent.send',{
                member_id  : memberId,
                event_name : eventName,
                page_name  : pageName
            }, (callback || function (){}), (errorCallback || function (){}));
        },
        postUIEventLogToGA: function(trackerName, params){
            if (!trackerName) {
                ns.Log.warn('trackerName is required');
                return;
            }
            if (!params.eventCategory) {
                ns.Log.warn('eventCategory is required');
                return;
            }

            if (!params.eventAction) {
                params.eventAction = DEFAULT_ACTION;
            }

            ns.sendEvent(trackerName, params);
        },
        isSamplingIdOnePercent: function(samplingId) {
            var isSampling = ((memberId % 100) === samplingId);
            if(!isSampling && !isDebug && !isStaging) {
                return;
            }
            return true;
        },
        isSamplingIdTenPercent: function(samplingId) {
            var isSampling = ((memberId % 10) === samplingId);
            if(!isSampling && !isDebug && !isStaging) {
                return;
            }
            return true;
        },
        postWidgetProfilerLog: function(logAggregate, totalCount, totalTime, pathname) {
            if(!logAggregate || !totalCount || !totalTime || !pathname) {
                return;
            }

            rpc.call('jp.mixi.analysis.behaviour.sendMessage',{
                name  : "widget.profiler",
                value : {
                    logAgregate : logAggregate,
                    totalCount  : totalCount,
                    totalTime   : totalTime,
                    pathname    : pathname
                }
            }, function() {});
        }
    });
});
