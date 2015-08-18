(: async test :)
import module namespace async = 'quodatum.async' at "async.xqm";

let $xq:='
let $a:="C:\tfs"!file:list(.)!<file name="{.}"/>
return db:replace("!ASYNC","dir.xml",<foo>{$a}</foo>)
'


let $fut2:=async:submit(async:futureTask($xq))

let $_:=async:shutdown()
return map{"a":$async:Executor}