
var cleanUDO = function(udo, config = {values: false,keys: false}) {
  if(typeof(Array.prototype.reduce)!=="function"||Array.prototype.reduce.toString().indexOf('native') === -1){Object.defineProperty(Array.prototype,"reduce",{value:function(callback){if(this===null){throw new TypeError("Array.prototype.reduce "+"called on null or undefined")}if(typeof callback!=="function"){throw new TypeError(callback+" is not a function")}var o=Object(this);var len=o.length>>>0;var k=0;var value;if(arguments.length>=2){value=arguments[1]}else{while(k<len&&!(k in o)){k++}if(k>=len){throw new TypeError("Reduce of empty array "+"with no initial value")}value=o[k++]}while(k<len){if(k in o){value=callback(value,o[k],k,o)}k++}return value}})}
  var is_circular=function(obj){var circular_checker=function(obj){this.obj=obj};return circular_checker.prototype.is_circular=function(obj,seen){if(obj=obj||this.obj,seen=seen||[],!(obj instanceof Object))throw new TypeError("\"obj\" must be an object (or inherit from it)");var self=this;seen.push(obj);for(var key in obj){var val=obj[key];if(val instanceof Object&&(~seen.indexOf(val)||self.is_circular(val,seen.slice())))return!0}return!1},new circular_checker(obj).is_circular()},
    clean_string = function(string) {
      return string = string.trim().replace(/[\\"\u0000-\u001F\u0080-\u009f\u2028\u2029]/igm,"").replace(/\r?\n/g, "").replace(/[\s\xA0]+/g, " ").replace(/\u0026amp;/gim, "&").replace(/&#(\d+);/g, function(match, dec) {
        return String.fromCharCode(dec)
      }), config.values ? string.toLowerCase() : string
    },
    kindof=function(data){if("undefined"==typeof data)return"undefined";var data_type=Object.prototype.toString.call(data).match(/\s([a-zA-Z]+)/)[1].toLowerCase().replace(/^html|element/gim,"");switch(data_type){case"number":return isNaN(data)?"NaN":"number";default:return data_type}},
    is_empty_string=function(string){return"string"===kindof(string)&&!string},
    is_string = function(string) {return "string" === kindof(string)},
    is_obj = function(data) {return "[object Object]" === Object.prototype.toString.call(data)},
    /** main block */
    clean_obj = function(obj, max_depth) {
      if (max_depth = max_depth || 1, max_depth > 5) return console.warn("utag: nested objects in your datalayer"), obj;
      var keys = Object.keys(obj);
      return keys.reduce(function(n_obj, c_key) {
        var c_val_type = kindof(obj[c_key]);
        switch (c_val_type) {
          case "string":
            n_obj[c_key] = is_empty_string(obj[c_key]) ? "" : clean_string(obj[c_key]);
            break;
          case "array":
            n_obj[c_key] = [], obj[c_key].length && obj[c_key].forEach(function(value, i) {
              var val_type = kindof(value);
              value = (val_type === 'null' || val_type === 'undefined' || val_type === 'NaN') ? "": value;
              is_obj(value) ? n_obj[c_key][i] = is_circular(value) ? value : clean_obj(value, max_depth + 1) : is_string(value) ? n_obj[c_key][i] = clean_string(value) : n_obj[c_key][i] = value
            });
            break;
          case "object":
            is_circular(obj[c_key]) ? n_obj[c_key] = obj[c_key] : n_obj[c_key] = clean_obj(obj[c_key], max_depth + 1);
            break;
          case "number":
            n_obj[c_key] = obj[c_key];
            break;
          case "nan":
            n_obj[c_key] = "NaN";
            break;
          case "boolean":
            n_obj[c_key] = obj[c_key].toString();
            break;
          case "undefined":
            n_obj[c_key] = "";
            break;
          case "null":
            n_obj[c_key] = "null";
            break;
          default:
            n_obj[c_key] = obj[c_key]
        }
        return n_obj
      }, {})
    };
  return clean_obj(udo)
}

var data = cleanUDO(utag.data);
