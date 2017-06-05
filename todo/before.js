var before = function before(bfn,ofn) {
    var ret = bfn.apply(this, arguments);
    ofn.apply(this, ret);
};

var ofn = utag.track;
utag.track = before(function() {
    var args = Array.prototype.slice.call(arguments);
    args[0].fb_event_trigger = 'AddPaymentInfo';
},ofn)
