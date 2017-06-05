!function(f,b,e,v,n,t,s)


(function() {
    var script = document.createElement('script');
    script.src('//connect.facebook.net/en_US/fbevents.js');
    document.head.appendChild(script);
})();

fbq('init', '1111');

fbq('track', "PageView");

fbq('track', 'Purchase', {value: '1.00', currency: 'USD'});

(function(global) {
    function loadXHR(url) {
        return new Promise(load);
        function load(successCallback, failureCallback) {
            function onReadyStateChanged() {
                if (xhr.readyState !== XMLHttpRequest.DONE) return;
                if (xhr.status !== 200) {
                    xhr.onreadystatechange = null;
                    failureCallback(new Error(xhr.status));
                    return
                }
                xhr.onreadystatechange = null;
                successCallback(xhr.responseText)
            }
            var xhr = new XMLHttpRequest;
            xhr.withCredentials = false;
            xhr.open("GET", url, true);
            xhr.onreadystatechange = onReadyStateChanged;
            xhr.send(null)
        }
    }
    global.loadXHR = loadXHR;
    })(window);

loadXHR('https://connect.facebook.net/en_US/fbevents.js').then(function(data) {
    var script = document.createElement('script');
    script.setAttribute('type', 'text/javascript');
    script.innerHTML = data;
    script.id = "new_id"
    document.head.appendChild(script);
    setTimeout(function() {
        fbq('init', '100000');
        fbq('track', "PageView");
        fbq('track', 'Purchase', {
            value: '1.00',
            currency: 'USD'
        });
    }, 500);
     setTimeout(function() {
        fbq('init', '2222222');
        fbq('track', "PageView");
        fbq('track', 'Purchase', {
            value: '1.00',
            currency: 'USD'
        });
    }, 10000);
}).catch(function(err) {
    if (err) console.log(err);
})

var copy_fbq = function() {
    return new Promise(function(resolve, reject) {
        try {
            var obj = Object.create(null);
            for (var key in fbq) {
                obj[key] = fbq[key];
            }
            resolve(obj);
        } catch (error) {
            if (error) reject(error);
        }
    })
}

copy_fbq().then(function(data){
    console.log(data);
})

