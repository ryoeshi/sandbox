javascript:(function(){
    F=function(v){
        return (v<10?'0':'')+v;
    };
    DF=function(r){
        var hh=r.getHours();
        var mm=r.getMinutes();
        var ss=r.getSeconds();
        return F(r.getFullYear())+F(r.getMonth()+1)+F(r.getDate())+(hh+mm+ss>0?'T'+F(hh)+F(mm)+F(ss):'');
    };
    R=function(v){
        return v.replace(/[%EF%BC%90-%EF%BC%99%EF%BC%8F%EF%BC%9A]/g,function ($0){
            return String.fromCharCode($0.charCodeAt(0)-65248);
        }).replace(/[%E5%B9%B4%E6%9C%88]/g,'/').replace(/[%E6%99%82]/g,':').replace(/[^0-9:\/%EF%BD%9E]+/g,' ');
    };
    D=function(v){
            if(isNaN(new Date(v))){
                v=new Date().getFullYear()+'/'+v;
            }else if(v.match(/^\d\d[^\d]/)){
                v='20'+v;
            }return new Date(v);
    };
    var t=((window.getSelection&&window.getSelection())||(document.getSelection&&document.getSelection())||(document.selection&&document.selection.createRange&&document.selection.createRange().text));
    var s=String(t).split('%EF%BD%9E');
    var m=t+'\n'+location.href;
    var d='';
    if(!isNaN(D(R(s[0])))){
        m=location.href;
        d='&dates='+DF(D(R(s[0])))+'/'+DF(D(R(s[s.length-1])));
    }var w=window.open('https://www.google.com/calendar/event?action=TEMPLATE&text='+escape(document.title)+'&details='+escape(m)+d,'_blank');
})()
