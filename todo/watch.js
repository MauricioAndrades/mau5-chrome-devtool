var watch_obj = function  watch_obj(obj) {
    return watch(obj, function(prop, action, difference, prev) {
        console.log({
            prop: prop,
            action: action,
            diff: difference
        })
    }, 0, true);
}

watch_obj(utag.data)
