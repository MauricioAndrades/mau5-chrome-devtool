export function elem_styles() {
  //export styles
return (function() {
  Element.prototype.export_styles=function(){var defaultStylesByTagName={};var noStyleTags={BASE:true,HEAD:true,HTML:true,META:true,NOFRAME:true,NOSCRIPT:true,PARAM:true,SCRIPT:true,STYLE:true,TITLE:true};var tagNames=["A","ABBR","ADDRESS","AREA","ARTICLE","ASIDE","AUDIO","B","BASE","BDI","BDO","BLOCKQUOTE","BODY","BR","BUTTON","CANVAS","CAPTION","CENTER","CITE","CODE","COL","COLGROUP","COMMAND","DATALIST","DD","DEL","DETAILS","DFN","DIV","DL","DT","EM","EMBED","FIELDSET","FIGCAPTION","FIGURE","FONT","FOOTER","FORM","H1","H2","H3","H4","H5","H6","HEAD","HEADER","HGROUP","HR","HTML","I","IFRAME","IMG","INPUT","INS","KBD","KEYGEN","LABEL","LEGEND","LI","LINK","MAP","MARK","MATH","MENU","META","METER","NAV","NOBR","NOSCRIPT","OBJECT","OL","OPTION","OPTGROUP","OUTPUT","P","PARAM","PRE","PROGRESS","Q","RP","RT","RUBY","S","SAMP","SCRIPT","SECTION","SELECT","SMALL","SOURCE","SPAN","STRONG","STYLE","SUB","SUMMARY","SUP","SVG","TABLE","TBODY","TD","TEXTAREA","TFOOT","TH","THEAD","TIME","TITLE","TR","TRACK","U","UL","VAR","VIDEO","WBR"];for(var i=0;i<tagNames.length;i++){if(!noStyleTags[tagNames[i]]){defaultStylesByTagName[tagNames[i]]=computeDefaultStyleByTagName(tagNames[i])}}function computeDefaultStyleByTagName(tagName){var defaultStyle={};var element=document.body.appendChild(document.createElement(tagName));var computedStyle=getComputedStyle(element);for(var i=0;i<computedStyle.length;i++){defaultStyle[computedStyle[i]]=computedStyle[computedStyle[i]]}document.body.removeChild(element);return defaultStyle}function getDefaultStyleByTagName(tagName){tagName=tagName.toUpperCase();if(!defaultStylesByTagName[tagName]){defaultStylesByTagName[tagName]=computeDefaultStyleByTagName(tagName)}return defaultStylesByTagName[tagName]}return function exportStyles(){if(this.nodeType!==Node.ELEMENT_NODE){throw new TypeError("The exportStyles method only works on elements, not on "+this.nodeType+" nodes.")}if(noStyleTags[this.tagName]){throw new TypeError("The exportStyles method does not work on "+this.tagName+" elements.")}var styles={};var computedStyle=getComputedStyle(this);var defaultStyle=getDefaultStyleByTagName(this.tagName);for(var i=0;i<computedStyle.length;i++){var cssPropName=computedStyle[i];if(computedStyle[cssPropName]!==defaultStyle[cssPropName]){styles[cssPropName]=computedStyle[cssPropName]}}var a=["{"];for(var i in styles){a[a.length]=i+": "+styles[i]+";"}a[a.length]="}";copy(a.join("\t").trim());return a.join("\t")}}();
})();
}
