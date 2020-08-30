var fso=new ActiveXObject("Scripting.FileSystemObject");
var f=fso.OpenTextFile("device.json",1,false);
var j=f.readall();
d=eval("("+j+")");
s="";
for(var p in d){
    s+="["+p+"]";
    if(typeof(d[p])=="string"){
        s+=d[p];
    }else if(typeof(d[p])=="object"&&typeof(d[p][0])=="number"){
        for(var i=0;i<d[p].length;i++){
            s+=String.fromCharCode(d[p][i]);
        }
    }
    s+="\n";
}
WScript.Echo(s);
