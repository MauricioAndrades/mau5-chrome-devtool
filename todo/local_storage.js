var loc_storage = function() {return localStorage};
loc_storage.get = function(item) {
    var data = null;
    try {
        return (data = JSON.parse(localStorage.getItem(item)));
    }
    catch (e) {
        return localStorage.getItem(item)
    };
}

loc_storage.set = function(label, item) {
    localStorage.setItem(label, typeof(item) === "object" ? JSON.stringify(item):item );
}
