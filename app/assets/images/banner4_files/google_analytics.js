/**
 * @name jp.mixi.analysis.google_analytics
 * @namespace
 */
Namespace('jp.mixi.analysis.google_analytics')
.define(/** @lends jp.mixi.analysis.google_analytics */function(ns) {
    /*jshint browser:true, strict:true*/
    /*global Namespace:false, _:false*/
    'use strict';

    // This global is set by template layer.
    var enabledTrackerList = window._mixiGaEnabledTrackerList || [];

    var trackerEnabled = {};
    for (var k in enabledTrackerList) {
        trackerEnabled[enabledTrackerList[k]] = true;
    }

    /**
     * GAにeventを送信する
     * @param {string}     trackerName                   送信先のtracker名
     * @param {Object}     params                        GAに送信するパラメータ
     * @param {string}     params.eventCategory          イベントのカテゴリ名
     * @param {string}     params.eventAction            イベントのアクション名
     * @param {string}     [params.eventLabel]           イベントのラベル
     * @param {number}     [params.eventValue]           イベントの値
     * @param {function()} [params.hitCallback]          イベント送信後に呼び出される関数
     * @param {boolean}    [params.nonInteraction=false] 送信するイベントによって直帰率に影響を与えるかどうか
     * @see <a href="https://developers.google.com/analytics/devguides/collection/analyticsjs/events">Google アナリティクス イベント トラッキング(GA公式ドキュメント)</a>
     */
    var sendEvent = function(trackerName, params) {
        var q = {
            eventCategory : params.eventCategory,
            eventAction   : params.eventAction,
            eventLabel    : params.eventLabel,
            page          : params.page
        };
        if (_.isFunction(params.hitCallback)) {
            q.hitCallback = params.hitCallback;
        }
        if (params.eventValue !== undefined) {
            q.eventValue  = params.eventValue;
        }
        if (params.nonInteraction) {
            q.nonInteraction  = params.nonInteraction;
        }
        window.ga(trackerName + ".send", 'event', q);
    };

    var isEnabledTracker = function (trackerName) {
        return !!trackerEnabled[trackerName];
    };

    ns.provide({
        sendEvent        : sendEvent,
        isEnabledTracker : isEnabledTracker
    });
});
