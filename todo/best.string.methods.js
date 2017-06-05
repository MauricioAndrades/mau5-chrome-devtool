var unescape_html = function(string) {
    return string.replace(/&lt;/g, "<").replace(/&gt;/g, ">").replace(/&#58;/g, ":").replace(/&quot;/g, '"').replace(/&#60;/g, "<").replace(/&#62;/g, ">").replace(/&amp;/g, "&");
}

trim_url = function(value) {
    var result = value.replace(/^(https|http|file):\/\//i, "");
    if (document.URL) {
        if (result.toLowerCase().startsWith(document.URL.toLowerCase())) {
            result = result.substr(document.URL.length);
        }
    }
    return result;
};

check_same = function(a, b) {
    a = a.toUpperCase();
    b = b.toUpperCase();
    if (a === b) {
        return 0;
    }
    return a > b ? 1 : -1;
};
