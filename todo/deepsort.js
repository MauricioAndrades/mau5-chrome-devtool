var deep_sort = (function() {
    require=function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s}({1:[function(require,module,exports){"use strict";var isObject=require("isobject");function isObjectObject(o){return isObject(o)===true&&Object.prototype.toString.call(o)==="[object Object]"}module.exports=function isPlainObject(o){var ctor,prot;if(isObjectObject(o)===false)return false;ctor=o.constructor;if(typeof ctor!=="function")return false;prot=ctor.prototype;if(isObjectObject(prot)===false)return false;if(prot.hasOwnProperty("isPrototypeOf")===false){return false}return true}},{isobject:2}],2:[function(require,module,exports){"use strict";module.exports=function isObject(val){return val!=null&&typeof val==="object"&&Array.isArray(val)===false}},{}],"deep-sort-object":[function(require,module,exports){"use strict";var isPlainObject=require("is-plain-object");function defaultSortFn(a,b){return a.localeCompare(b)}function sort(src,comparator){var out;if(Array.isArray(src)){return src.map(function(item){return sort(item,comparator)})}if(isPlainObject(src)){out={};Object.keys(src).sort(comparator||defaultSortFn).forEach(function(key){out[key]=sort(src[key],comparator)});return out}return src}module.exports=sort},{"is-plain-object":1}]},{},[]);
    return require('deep-sort-object')
})();
var requireg = require("/Users/Op/.npm-global/lib/node_modules/requireg/lib/requireg.js")
const jstpc = requireg('json-stringify-pretty-compact');
console.log(jstpc(deep_sort(data)))
var sorted_data = {
  "audiences": {
    "llbean_main_118": "Window Shopper",
    "llbean_main_120": "Repeat Visitor"
  },
  "badges": {"30": true, "31": true, "5180": true, "5272": true, "5291": true},
  "current_visit": {
    "dates": {"10": 1496503036000},
    "flags": {
      "14": true,
      "5208": true,
      "5357": false,
      "5359": true,
      "5413": false,
      "5415": false,
      "5417": false,
      "5430": false,
      "5432": false,
      "5434": false,
      "5800": false,
      "5810": false,
      "5812": false
    },
    "metric_sets": {"5521": {"": 1}, "5546": {"": 1}},
    "metrics": {"7": 2, "5214": 0, "5814": 0},
    "properties": {
      "5": "https://www.llbean.com/",
      "44": "Chrome",
      "45": "Mac OS X",
      "46": "Mac desktop",
      "47": "browser",
      "48": "Chrome",
      "5444": "A0A64CA2200000E815927A750l4F31",
      "5447": "prod",
      "5503": "main",
      "5507": "guest",
      "5520": "",
      "5545": ""
    },
    "property_sets": {
      "49": ["Chrome"],
      "50": ["Mac OS X"],
      "51": ["Mac desktop"],
      "52": ["browser"],
      "53": ["Chrome"],
      "5519": [""]
    }
  },
  "dates": {
    "23": 1495770965000,
    "24": 1496503036000,
    "audience_llbean_main_118_count_ts": 1496503036000,
    "audience_llbean_main_119_count_ts": 1496165389000,
    "audience_llbean_main_120_count_ts": 1496503036000
  },
  "flags": {
    "27": true,
    "5298": false,
    "5438": false,
    "5449": false,
    "5487": false,
    "5499": false,
    "5501": false,
    "5532": false,
    "5604": false,
    "5606": true
  },
  "metric_sets": {
    "55": {"Mac desktop": 6},
    "57": {"Chrome": 6},
    "59": {"Mac OS X": 6},
    "61": {"browser": 6},
    "63": {"Chrome": 6},
    "5282": {"[]": 17}
  },
  "metrics": {
    "15": 6,
    "16": 1,
    "21": 7,
    "22": 17,
    "25": 24.05,
    "26": 4.008333333333334,
    "28": 1.2104348544973544,
    "29": 5.783045633551938,
    "5212": 6,
    "5230": 0,
    "5270": 0
  },
  "properties": {
    "17": "https://www.llbean.com/",
    "54": "Mac desktop",
    "56": "Chrome",
    "58": "Mac OS X",
    "60": "browser",
    "62": "Chrome",
    "5280": "[]",
    "5281": "[]",
    "5466": "5f2c5927-7c3a-4e00-ad0e-633ab04a4670",
    "5593": "A0A64CA2200000E815927A750l4F31",
    "5618": "015c42e5a4150010981eeeab554d05078006407000ac2",
    "account": "llbean",
    "profile": "main"
  }
}
