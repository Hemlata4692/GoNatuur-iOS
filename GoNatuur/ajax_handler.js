//
//var s_ajaxListener = new Object();
//s_ajaxListener.tempOpen = XMLHttpRequest.prototype.open;
//s_ajaxListener.tempSend = XMLHttpRequest.prototype.send;
//s_ajaxListener.callback = function () {
//    window.location = this.url;
//};
//
//XMLHttpRequest.prototype.open = function (a, b) {
//    if (!a)
//        var a = '';
//    if (!b)
//        var b = '';
//    s_ajaxListener.tempOpen.apply(this, arguments);
//    s_ajaxListener.method = a;
//    s_ajaxListener.url = b;
//    //    alert(s_ajaxListener.method);
//    
//    alert(s_ajaxListener.url);
//    //  if (a.toLowerCase() == 'get') {
//    //    s_ajaxListener.data = b.split('?');
//    //    s_ajaxListener.data = s_ajaxListener.data[1];
//    //  }
//}
//
//XMLHttpRequest.prototype.send = function (a, b) {
//    if (!a)
//        var a = '';
//    if (!b)
//        var b = '';
//    s_ajaxListener.tempSend.apply(this, arguments);
//    //if(s_ajaxListener.method.toLowerCase() == 'post')s_ajaxListener.data = a;
//    s_ajaxListener.callback();
//}
////
//var s_ajaxListener = new Object();
//s_ajaxListener.tempOpen = XMLHttpRequest.prototype.open;
//s_ajaxListener.tempSend = XMLHttpRequest.prototype.send;
//s_ajaxListener.callback = function () {
//    window.location='mpAjaxHandler://' + this.url;
//};
//
//XMLHttpRequest.prototype.open = function(a,b) {
//    if (!a) var a='';
//    if (!b) var b='';
//    s_ajaxListener.tempOpen.apply(this, arguments);
//    s_ajaxListener.method = a;
//    s_ajaxListener.url = b;
//    if (a.toLowerCase() == 'get') {
//       // s_ajaxListener.data = b.split('?');
//        s_ajaxListener.data = s_ajaxListener.data[1];
//       // s_ajaxListener.data = s_ajaxListener.url;
//    }
//}
//
//XMLHttpRequest.prototype.send = function(a,b) {
//    if (!a) var a='';
//    if (!b) var b='';
//    s_ajaxListener.tempSend.apply(this, arguments);
//    if(s_ajaxListener.method.toLowerCase() == 'post')s_ajaxListener.data = a;
//    s_ajaxListener.callback();
//}


try {
    var s_ajaxListener = new Object();
    s_ajaxListener.tempOpen = XMLHttpRequest.prototype.open;
    s_ajaxListener.tempSend = XMLHttpRequest.prototype.send;
    
    XMLHttpRequest.prototype.open = function(a, b) {
        if (!a)
            a = '';
        if (!b)
            b = '';
        s_ajaxListener.tempOpen.apply(this, arguments);
        s_ajaxListener.method = a;
        s_ajaxListener.url = b;
        if (a.toLowerCase() == 'get') {
            s_ajaxListener.data = b.split('?');
            s_ajaxListener.data = s_ajaxListener.data[1];
        }
        
    }
    
    XMLHttpRequest.prototype.send = function(a, b) {
        if (!a)
            a = '';
        if (!b)
            b = '';
        s_ajaxListener.tempSend.apply(this, arguments);
        if (s_ajaxListener.method.toLowerCase() == 'get')
            s_ajaxListener.data = a;
        alert(s_ajaxListener.data);
        alert("test"+b);
////        if (s_ajaxListener.url.indexOf("trackdata") == -1
//            && s_ajaxListener.url.indexOf("getOnlineUsers") == -1
//            && typeof jQuery == 'undefined') {
            console = new Object();
        alert("alert 1"+a);
            console.log = function(log) {
                var iframe = document.createElement("IFRAME");
                iframe.setAttribute("src", "ios-log:#iOS#" + log);
                document.documentElement.appendChild(iframe);
                iframe.parentNode.removeChild(iframe);
                iframe = null;
            };
            console.debug = console.log;
            console.info = console.log;
            console.warn = console.log;
            console.error = console.log;
            tagManagerQue.push('event.ajax',{{fullUrl}},{{timestamp}},{{element id}},null,s_ajaxListener.url,s_ajaxListener.data,''); 
//        }
    }
} catch (e) {
}
