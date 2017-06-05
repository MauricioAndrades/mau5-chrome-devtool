(function() {
  if (document.URL.indexOf("https://my.tealiumiq.com/tms") !== 0) {
    return;
  }

var setImmediate = function(callback) {
    var args = [...arguments].slice(1);
    Promise.resolve().then(() => callback(...args));
    return 0;
  };

mau5.copy_loadrule = function(uid) {
    function quickcopyLR(id) {
      return new Promise(function(res,rej) {
        if (typeof id !== "number") {
          throw new Error("id must be a number");
        }
        utui.automator.copyLoadRule(id);
        var data = utui.automator.getClipboard()[0].obj
        res(data)
      });
    }


    return quickcopyLR(uid).then(function(data) {
      return data;
    }).catch(function(e) {
      console.log(e)
    });
  }

  var build_regex = function(search_value) {
    if (kindof(search_value) === "string") {
      return new RegExp(search_value.escapeForRegExp(), "igm");
    } else {
      return search_value;
    }
  }

  var get_text_content = function() {
    return this.textContent.toLowerCase().collapseWhitespace().trim();
  }

  var unmatched_but_selected = function() {
    var args = Array.from(arguments);
    var text = args[0];
    var regex = args[1];
    return $(this).hasClass('selected') && !text.match(regex);
  }

  mau5.select_tag = function(vendor) {
    var regex = build_regex(vendor);
    $('.manage_container').each(function() {
      var text = get_text_content.call(this);
      if (unmatched_but_selected.apply(this, [text,regex])) {
        $(this).find('input').click();
        $(this).removeClass('selected');
      }
      if (text.match(regex)) {
        $(this).find('input').click()
        $(this).addClass('selected');
      }
    })
  }
  mau5.select_loadrule = function(vendor) {
    var regex = build_regex(vendor);
    $('.loadrules_container').each(function() {
      var text = get_text_content.call(this);
      if (unmatched_but_selected.apply(this, [text,regex])) {
        $(this).find('input').click();
        $(this).removeClass('selected');
      }
      if (text.match(regex)) {
        $(this).find('input').click()
        $(this).addClass('selected');
      }
    })
  }
    mau5.loadrules_turn_off_inactive = function() {
    $('.loadrules_container').each(function() {
      if ($(this).find('span.active')[0].textContent === "0") {
        $(this).find('input').click();
        $(this).find('.container_status_active').click()
        $(this).removeClass('selected');
      }
    })
  }
  mau5.select_extension = function(vendor) {
    var regex = build_regex(vendor);
    $('.customize_container').each(function() {
      var text = this.textContent.toLowerCase().collapseWhitespace().trim();
      if (text.match(regex)) {
        $(this).find('input').click()
        $(this).addClass('selected');
      }
    })
  }
  window.copy = copy;
  window.qcp_tag = function(id) {
    utui.automator.emptyClipboard();
    var copy_tag = function(tag_id, callback) {
      utui.automator.copyTag(tag_id);
      var tag = utui.automator.getClipboard();
      if (tag) {
        callback(tag);
      }
    }
    copy_tag(id, function(arr) {
      copy(arr[0].obj)
    })
  }
  window.qcp_loadrule = function(id) {
    var loadrule;
    utui.automator.emptyClipboard();
    function copy_loadrule(loadrule_id, callback) {
      utui.automator.copyLoadRule(loadrule_id);
      loadrule = setImmediate(utui.automator.getClipboard);
      setImmediate(copy_loadrule(loadrule))

    }
    copy_loadrule(id, function(arr) {
      var loadrule = clone(arr[0].obj);
      if(loadrule) {
        copy(loadrule);
      }
      return loadrule;
    })
  }
})(window);
