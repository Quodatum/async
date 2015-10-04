declare namespace rq="java:com.quodatum.async.RunQuery";
let $a:=rq:new("2+ 3","id")
let $b:= rq:run($a,"main")
return ( rq:time($a))