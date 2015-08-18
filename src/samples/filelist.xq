(: async test :)
import module namespace async = 'quodatum.async';

let $xq:='
let $a:="C:\tmp"!file:list(.)!<file name="{.}"/>
return db:replace("!ASYNC","dir.xml",<foo>{$a}</foo>)
'


let $fut2:=async:submit(async:futureTask($xq))

let $_:=async:shutdown()
return $fut2