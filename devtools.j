(function(exports) {

var _ = lodash;
/*
TODO:
-Add functionality to only update selected conditions
*/

// Add check condition handler
jQuery(document.body).on('mousedown', '#conditionCheck', function() {conditionChecker();});

// Add fix condition handler
jQuery(document.body).on('mousedown', '#fixExtensionConditions', function() {
    fixConditions();
});

// Toggle click funciton
(function($) {
    $.fn.clickToggle = function(func1, func2) {
        var funcs = [func1, func2];
        this.data('toggleclicked', 0);
        this.click(function() {
            var data = $(this).data();
            var tc = data.toggleclicked;
            $.proxy(funcs[tc], this)();
            data.toggleclicked = (tc + 1) % 2;
        });
        return this;
    };
}(jQuery));

// Add button
jQuery('<button id="conditionCheck" class="btn btn-info tmui" style="float: left;margin-top:0;margin-left:10px;">Condition Check</button>').insertAfter('#customize_addDebugBtn');

window.key_obj = {}
var conditionChecker = function() {
    var buttonCount = 0;
    var ext_conds = {};
    var new_object = {};
    var previous_condition_number_from_same_and = "";

    // Declare flag and variable keeper
    var safe_condition = false;
    var ignore = false;
    var save_off_variable = "";
    var condition_check = {
        "contains_ignore_case": 1,
        "contains": 1,
        "does_not_contain_ignore_case": 1,
        "does_not_end_with_ignore_case": 1,
        "does_not_start_with_ignore_case": 1,
        "equals_ignore_case": 1,
        "starts_with_ignore_case": 1,
        "less_than": 1,
        "less_than_equal_to": 1,
        "greater_than": 1,
        "greater_than_equal_to": 1
    };




    // loop through all extensions and save each variable in the conditions only
    Object.keys(utui.data.customizations).forEach(function(id) {
        Object.keys(utui.data.customizations[id]).sort().reverse().forEach(function(keys) {

            if(utui.data.customizations[id].repaired != undefined && utui.data.customizations[id].repaired == 1)
            {
                return false;
            }

            // Assign extension id as a nested obj using condition stamps
            if (keys.match(/^\d/)) {
                if (!key_obj[id]) {
                    key_obj[id] = {};
                }

                // Remove underscores from keys
                var key_nums = keys.replace(/\D/g, '');

                if (keys.indexOf('_source') > 0) {

                    if (typeof key_obj[id][key_nums] === 'undefined') {
                        key_obj[id][key_nums] = {};
                    }

                    // Save the current variable name
                    key_obj[id][key_nums]["variable"] = utui.data.customizations[id][keys]
                }
                if (keys.indexOf('_filtertype') > 0) {

                    if (typeof key_obj[id][key_nums] === 'undefined') {
                        key_obj[id][key_nums] = {};
                    }

                    // Save the current condition
                    key_obj[id][key_nums]["condition"] = utui.data.customizations[id][keys];
                }
            }
        });
    });

    // Look over each extension
    Object.keys(key_obj).forEach(function(extension_number) {
        // Loop over each condition in extension
        Object.keys(key_obj[extension_number]).forEach(function(condition_id) {
            // Create array of AND conditions
            // Check to see if condition_id is first in AND
            if (condition_id.length <= 18) {
                // Save off condition number to use for rest of AND
                previous_condition_number_from_same_and = condition_id;
                // Check if extension number key is defined, otherwise make a new obj
                if (new_object[extension_number] === undefined) {
                    new_object[extension_number] = {};
                }
                // Check if condition id key is defined, otherwise make a new array
                if (new_object[extension_number][condition_id] === undefined) {
                    new_object[extension_number][condition_id] = [];
                }
                // Push variable and condition into current AND key
                var v = key_obj[extension_number][condition_id].variable || "";
                var c = key_obj[extension_number][condition_id].condition || "";
                new_object[extension_number][condition_id].push(v);
                new_object[extension_number][condition_id].push(c);
                // Check to see if condition id is second, third, in same AND
            } else if (condition_id.length > 18 && condition_id.indexOf(previous_condition_number_from_same_and) > -1) {
                // Push variable and condition into initial AND
                new_object[extension_number][previous_condition_number_from_same_and].push(key_obj[extension_number][condition_id].variable);
                new_object[extension_number][previous_condition_number_from_same_and].push(key_obj[extension_number][condition_id].condition);
            }
        });
    });


    // Loop through the new object and check each AND condition to make sure
    // required variables are checking for defined or populated
    // otherwise, create an error for the extension and condition row

    window.fix_conditions_array = [];
    // Start by looping through each extension
    Object.keys(new_object).forEach(function(extension_number) {
        // Loop through each condition AND block in extension
        Object.keys(new_object[extension_number]).forEach(function(and_condition_block) {
            window.and_condition_block = and_condition_block;

            // Save the h3 element of the current extension
            var $extension = jQuery('#customizations_' + extension_number + ' h3');

            // Creaet variables for easier referencing
            var and_block_array = new_object[extension_number][and_condition_block];
            var current_variable, position_of_safe_condition;
            var variable_from_safe_condition = [];

            // Loop through array of the AND block
            for (var i = 0; i < and_block_array.length; i++) {

                // Reset flag
                var found_defined_or_populated = 0;

                // Check current index to see if it is variable then save variable for error application
                // If the variable type is 'dom', ignore the row (always safe)
                if (and_block_array[i].indexOf('js.') == 0 ||
                    and_block_array[i].indexOf('qp.') == 0 ||
                    and_block_array[i].indexOf('cp.') == 0 ||
                    and_block_array[i].indexOf('js_page.') == 0) {
                    current_variable = and_block_array[i]; //acme_page
                    ignore = false;
                } else if (and_block_array[i].indexOf('dom.') == 0) {
                    ignore = true;
                }

                // Check to see if current index is defined or populated and save off variable
                if (and_block_array[i] == 'defined' || and_block_array[i] == 'populated' || and_block_array[i] == 'is_badge_assigned') {
                    save_off_variable = and_block_array[i - 1]; //azm_merchID
                    found_defined_or_populated = 1;
                    position_of_safe_condition = i;
                    variable_from_safe_condition.push(and_block_array[i - 1]);
                    safe_condition = true;
                }

                // if(variable_from_safe_condition.indexOf(current_variable) > -1) {
                //     found_defined_or_populated = 1;
                //     safe_condition = true;
                // }

                // Check to see if current index variable is the same as one determined to be safe
                if (save_off_variable != current_variable &&
                    found_defined_or_populated == 0 && condition_check[and_block_array[i]] && !ignore) {

                    safe_condition = false;

                    if (fix_conditions_array.indexOf(extension_number) < 0) {
                        fix_conditions_array.push(extension_number);
                        buttonCount++;
                    }

                    // Apply error highlighting since the condition was determined to be unsafe
                    $extension.attr('style', 'background: #fef1ec url("images/ui-bg_glass_95_fef1ec_1x400.png") 50% 50% repeat-x;border: 1px solid #cd0a0a;');
                    $extension.find('.container_scope, .container_exType, .container_title').attr('style', 'color:#cd0a0a;');

                    $extension.clickToggle(function() {
                        console.log("header clicked to expand")
                        // Remove bold and shadow once user expands extension (cleaner) and reapply font color once they minimize
                        $extension.find('.container_scope, .container_exType, .container_title').attr('style', 'color:#cd0a0a;text-shadow: none; font-weight: normal;');
                    }, function() {
                        console.log("header clicked to minimize")
                        $extension.find('.container_scope, .container_exType, .container_title').attr('style', 'color:#cd0a0a;text-shadow: none; font-weight: normal;');
                    });

                }
            }

        });

    });

    // Once clicked, change button text to "Check Again"
    jQuery("#conditionCheck").remove();
    jQuery("#fixExtensionConditions").remove();
    jQuery("#nothingToFix").remove();
    // Add fix it button
    if (buttonCount > 0 && fix_conditions_array.length > 0)
        jQuery('<button id="fixExtensionConditions" class="btn btn-info tmui" style="float: left;margin-top:0;margin-left:10px;background-color:#a12727;background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#e06262), to(#ad3434));">Fix Conditions (' + buttonCount + ')</button>').insertAfter('#customize_addDebugBtn');
    else
        jQuery('<button id="nothingToFix" class="btn btn-info tmui" style="float: left;margin-top:0;margin-left:10px;background-color:#36702e;background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#3ccf3c), to(#196e2a));">Conditions are good</button>').insertAfter('#customize_addDebugBtn');
}

var fixConditions = function() {

    // set update flag so that the rebuildCondition function doesn't run twice
    // window.ext_conditions_repaired = 0;

    // get timestamp for condition id
    var ts = Date.now().toString();

    // create a new array to hold the extension key/value pairs
    var safeArray = [];

    // we track if the input is already being safely handled here
    var safeObject = {};

    // keeps track of incrementing number for both xx_xx and xx_xx_xx keys
    var extensionCounter = 1;
    var extensionCounter2 = 2;

    // create a new array for the renumbered keys
    var renumberedArray = [];

    // these are the keys we care about
    var interestedKeys = (/_filter|_filtertype|_source/);

    // jquery selector of current extension header - for css
    var $extension;

    // gets the starting array once we convert the re ordered object to an array
    var startingArray = function(obj) {
        return _.toPairs(obj);
    }

    // makes a new key using the previous condition id, timestamp, and type (filtertype or source)
    var makeNewKey = function(extCnt, ts) {
        return ts + padDigits(incrementExtensionCounter(extCnt), 5);
    }

    // pads number if less than 5
    var padDigits = function(number, digits) {
        return Array(Math.max(digits - String(number).length + 1, 0)).join(0) + number;
    }

    // increments the tail end of the condition keys
    var incrementExtensionCounter = function(extCnt) {
        extCnt++;
        return extCnt;
    }

    // returns how many underscores in key (for tracking order of conditions)
    var scoreCount = function(str) {
        return (str.match(/_/g) || []).length;
    }

    // removes the keys we will be manipulating so as not to produce duplicates
    var removeOldKeys = function(obj) {
        var interestedKeys = (/_filter|_filtertype|_source/);
        Object.keys(obj).forEach(function(key) {
            if (key.match(interestedKeys)) {
                delete obj[key];
            }
        });
        return obj;
    }

    // builds the update view object check
    var buildUpdateViewObj = function(extension) {
        if (typeof(extension) === 'object' && Object.keys(extension).length) {
            return {
                'action': 'updated_extension',
                'data': {
                    'id': '' + extension._id,
                    'name': extension.title,
                    'type': ''+extension.id,
                    'kind': 'Extension',
                    'operation': 'updated',
                    'container': 'customizations_'+extension._id,
                    'tab_name': 'customizations'
                }
            };
        }
        return false;
    };

    // adds is defined to every condition row in the extension
    var addDefined = function(arr) {
        var resultArray = [];
        for (var i = 0; i < arr.length; i++) {
            // only push into result array if _filtertype is found
            if (arr[i][0].indexOf('_filter') > -1 && arr[i][0].indexOf('_filtertype') == -1) {
                // push defined block
                resultArray.push([
                    [arr[i][0].substring(0, 18) + "_" + arr[i][0].substring(0, 18) + "_filter", ""],
                    [arr[i][0].substring(0, 18) + "_" + arr[i][0].substring(0, 18) + "_filtertype", "defined"],
                    [arr[i][0].substring(0, 18) + "_" + arr[i][0].substring(0, 18) + "_source", arr[i + 2][1]],
                ])
                // push the original condition row
                resultArray.push([
                    [arr[i][0], arr[i][1]],
                    [arr[i + 1][0], arr[i + 1][1]],
                    [arr[i + 2][0], arr[i + 2][1]]
                ]);
            }

        }
        return resultArray;
    }


    var pushUniqueHelper = function(safeArray, currentArray, safeObject) {
        var last, length;
        var last_filter, last_filtertype, last_source, last_key_pattern;
        var current_filter, current_filtertype, current_source, current_key_pattern;

        for (var i = 0; i < currentArray.length; i++) {

            // record the current row information
            current_source = currentArray[i][2][1];
            current_filtertype = currentArray[i][1][1];
            current_filter = currentArray[i][0][1];
            current_key_pattern = currentArray[i][0][0];


            // if it is the first condition, just push it for now and compare later
            if (safeArray.length === 0) {
                safeArray.push(currentArray[i]);
                if (current_filtertype === 'defined' || current_filtertype === 'populated' || current_filtertype === 'is_badge_assigned') {
                    safeObject[current_source] = current_filtertype === 'populated' || current_filtertype === 'is_badge_assigned' ? 2 : 1;
                    safeObject[current_source + "_loc"] = safeArray.length - 1;
                }
                continue;
            }

            // if we're deeper into the block, get the row information for comparison later
            if (safeArray.length >= 1) {
                length = safeArray.length;
                last = safeArray[length - 1];
                last_source = last[0][1];
                last_filtertype = last[1][1];
                last_filter = last[2][1];
                last_key_pattern = last[0][0];
            }

            // checks for populated vs defined and assigns weight
            if (current_filtertype === "populated" && typeof(safeObject[current_source]) !== "undefined" && safeObject[current_source] === 1) {
                safeArray[safeObject[current_source + "_loc"]][1][1] = "populated";
                safeObject[current_source] = 2;
            }

            // checks for is badge assigned vs defined and assigns weight
            if (current_filtertype === "is_badge_assigned" && typeof(safeObject[current_source]) !== "undefined" && safeObject[current_source] === 1) {
                safeArray[safeObject[current_source + "_loc"]][1][1] = "is_badge_assigned";
                safeObject[current_source] = 2;
            }

            // checks for populated/defined/is_badge_assigned and doesn't push defined in that case
            if (current_filtertype === 'populated' && typeof(safeObject[current_source]) !== 'undefined' && safeObject[current_source] === 2) {
                continue;
            }

            if (current_filtertype === 'defined' && typeof(safeObject[current_source]) !== 'undefined') {
                continue;
            }

            if (current_filtertype === 'is_badge_assigned' && typeof(safeObject[current_source]) !== 'undefined') {
                continue;
            }

            // checks for dupes and prevent pushing unecessary is_defined checks to a lodrule statement credit for hash check JP
            if (current_source === last_source) {
                if (current_filtertype === 'defined' && (last_filtertype === 'defined' || last_filtertype === 'populated' || typeof(safeObject[current_source]) !== 'undefined')) {
                    continue;
                }
            }

            // prevents dupes, update loadrule block and track if we're already check for is_defined
            if (last_source + last_filtertype + last_filter !== current_source + current_filtertype + current_filter) {
                safeArray.push(currentArray[i]);
                if (current_filtertype === 'defined' || current_filtertype === 'populated') {
                    safeObject[current_source] = current_filtertype === 'populated' ? 2 : 1;
                    safeObject[current_source + "_loc"] = safeArray.length - 1;
                }
            }

            // checks each key and see if it should be x_x_x or x_x (two underscores - part of OR)
            for (var i = 0; i < safeArray.length; i++) {
                for (var j = 0; j < safeArray[i].length; j++) {
                    if (scoreCount(safeArray[i][j][0]) == 1) {
                        safeArray[i][j][0] = safeArray[i][j][0].split("_")[0] + "_" + safeArray[i][j][0].split("_")[0] + "_" + safeArray[i][j][0].split("_")[1];
                    }
                }
            }
        }

    }

    // Organize each OR block so that the top condition is in this format: xx_xx
    // and all the rest in this format xx_xx_xx
    var organizeOrBlocks = function(workingArray) {
        // reset the first key record
        var first_key_in_outter_array = undefined;

        for (var i = 0; i < workingArray.length; i++) {
            for (var j = 0; j < workingArray[i].length; j++) {

                // checks the key to see if it is part of the same block or should be the start of a new
                if (j == 0 && scoreCount(workingArray[i][j][0]) == 2) {

                    // if the first key in the block has not yet been recorded, record it and then set it as the first
                    // condition in the block
                    if (!first_key_in_outter_array) {
                        first_key_in_outter_array = workingArray[i][j][0].substring(0, 18)
                        var firstPart = workingArray[i][j][0].split("_")[0] + "_" + workingArray[i][j][0].split("_")[2];
                        workingArray[i][j][0] = firstPart;
                        workingArray[i][1][0] = workingArray[i][j][0].split("_")[0] + "_filtertype";
                        workingArray[i][2][0] = workingArray[i][j][0].split("_")[0] + "_source";

                        // if the first key has been recorded and it is not the same as the current key, make sure to keep
                        // as part of the current block
                    } else if (first_key_in_outter_array && first_key_in_outter_array !== workingArray[i][j][0].substring(0, 18)) {
                        first_key_in_outter_array = safeArray[i][j][0].substring(0, 18)
                        var secondPart = workingArray[i][j][0].split("_")[0] + "_" + workingArray[i][j][0].split("_")[2];
                        workingArray[i][j][0] = secondPart;
                        workingArray[i][1][0] = workingArray[i][j][0].split("_")[0] + "_filtertype";
                        workingArray[i][2][0] = workingArray[i][j][0].split("_")[0] + "_source";
                    }
                }
            }
        }
        return workingArray;
    }

    // renumbers the keys so that they fall in the correct order in the UI
    var renumberKeys = function(arr) {
        var type, key;
        for (var i = 0; i < arr.length; i++) {
            for (var j = 0; j < arr[i].length; j++) {
                if (scoreCount(arr[i][j][0]) === 1) {
                    // make new key for second block of numbers in condition row key
                    key = makeNewKey(extensionCounter, ts);
                    type = arr[i][j][0].split("_")[1];
                    arr[i][j][0] = key + "_" + type;
                } else if (scoreCount(arr[i][j][0]) === 2) {
                    // make new key for second block of numbers in condition row key
                    var key2 = makeNewKey(extensionCounter2, ts);
                    type = arr[i][j][0].split("_")[2];
                    arr[i][j][0] = key + "_" + key2 + "_" + type;
                }
            }
            // increments the condition block key xx_xx and xx_xx_xx
            extensionCounter = incrementExtensionCounter(extensionCounter);
            extensionCounter2 = incrementExtensionCounter(extensionCounter2);

        }
        return arr;
    }

    // rebuilds the condition blocks by merging the new, repaired, reordered, renumbered, array into old object
    var rebuildConditionBlocks = function(masterObject, uniqueArray) {
        for (var i = 0; i < uniqueArray.length; i++) {
            masterObject = Object.assign(masterObject, _.fromPairs(uniqueArray[i]));
        }
        return masterObject;
    }

    var updateExtensionValue = function(id, key, value) {
        // this freezes UI
        utui.data.customizations[id][key] = value, utui.customizations.render()
    }

    var toggle_unsaved_changes_btn = function (bSaved) {
        var $save_publish_btn = $('#global_save'),
            $publish_diff_btn = $('#global_diff');

        if (bSaved) {
            $save_publish_btn.parent().removeClass('btn-group');
            $save_publish_btn.removeClass('btn-warning');
            $publish_diff_btn.hide();
            utui.profile.hideModifiedTabLabel();
        } else {
            if (!utui.permissions.isReadOnly()) {
                if (utui.historyManager.getNetChanges().length > 0) {
                    $save_publish_btn.parent().addClass('btn-group');
                    $save_publish_btn.addClass('btn-warning');
                    if ($save_publish_btn.is(':visible')) {
                        $publish_diff_btn.show();
                    }
                } else {
                    $save_publish_btn.parent().removeClass('btn-group');
                    $save_publish_btn.addClass('btn-warning');
                    $publish_diff_btn.hide();
                }
            }
        }
    };

    // update UI
    var updateView = function() {

        // redraw extension conditions
        utui.customizations.drawJUIAccordion();

        // loop through the extensions that should have been updated
        for (var i = 0; i < fix_conditions_array.length; i++) {

            utui.data.customizations[fix_conditions_array[i]].repaired = 1;

            // build the update object
            updateObject = buildUpdateViewObj(utui.data.customizations[fix_conditions_array[i]]);

            // updates the view to track changes
            if (updateObject) {
                utui.profile.showModifiedTabLabel(updateObject);
                utui.historyManager.addEvent(updateObject);
                updateObject = null;
            }

            // save the h3 element of the current extension
            $extension = jQuery('#customizations_' + fix_conditions_array[i] + ' h3');

            // remove error highlighting
            $extension.removeAttr('style');
            $extension.find('.container_scope, .container_exType, .container_title').removeAttr('style');
        }

        // remove the fix conditions button
        // jQuery('#fixExtensionConditions').remove();
        toggle_unsaved_changes_btn();

    }

    // main method
    exports.repairConditions = function(object) {

        // checks to see if object has changed, if not - doesn't do anything
        function checkModifications(a, b) {
            var mod = false;
            if (Object.keys(a).length !== Object.keys(b).length) {
                mod = true;
            } else {
                for (var key in a) {
                    if (a[key] !== b[key]) {
                        mod = true;
                        break;
                    }
                }
            }
            return mod;
        }

        Object.keys(object).forEach(function(extension_number, idx) {


            var extensionObject = object[extension_number];

            // re order the keys of the utui.data.customizations object for each extension
            var reorderedObject = _(extensionObject)
                .toPairs()
                .sortBy(function(pair) {
                    return pair[0].replace(/_/, pair[0].split('_').length);
                })
                .fromPairs()
                .value();

            // clone the reordered object for use when we merge objects
            var clonedResultObject = Object.assign({}, reorderedObject);

            // old object with manipulated keys removed
            var oldObject = removeOldKeys(clonedResultObject);

            // this is the starting array (entire object's key/value pairs)
            var startingConditionArray = _.toPairs(reorderedObject);

            // clear out safeArray for new extension's conditions
            safeArray = [];

            if (fix_conditions_array.indexOf(extension_number) > -1) {
            // add 'defined' to everything
            var uniqueArray = addDefined(startingConditionArray);

            // filter through each condition row to make sure 'defined' is appropriate
            pushUniqueHelper(safeArray, uniqueArray, safeObject);

            // organize the OR blocks into the correct key formats are in the correct order (xx_xx and xx_xx_xx)
            var currentArray = organizeOrBlocks(safeArray);

            // renumber all the keys to make sure they are placed in the correct order in UI
            var renumberedArray = renumberKeys(currentArray);

                // if we modified an extension object
                if (checkModifications(extensionObject, rebuildConditionBlocks(oldObject, renumberedArray))) {
                    // set master object to UTUI
                    object[extension_number] = rebuildConditionBlocks(oldObject, renumberedArray);
                }
            }

        });

        updateView();
    }
    window.backupThenRepair = function() {
        // backup the current extensions before updating
        var curr_date = (new Date()).getTime();
        var label = "extension_data_" + curr_date;
        var backup = Object.assign({}, utui.data.customizations);
        localforage.setItem(label, backup).then(function(data) {
            console.log(data);
            repairConditions(utui.data.customizations);
        }).catch(function(err) {
            if (err) {
                console.warn(err);
            }
        });

        // capture all the backups currently in indexdb
        localforage.keys().then(function(keys) {
            // An array of all the key names.
            for(var i=0;i< keys.length;i++) {
                if (i >= 5) {
                    // Remove more than 5 backups
                    localforage.removeItem(keys[i]).then(function() {
                    }).catch(function(err) {
                        console.log(err);
                    });
                }
            }
        }).catch(function(err) {
            console.log(err);
        });
    };

    backupThenRepair();

}

})(window);
