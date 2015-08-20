(: async test :)
import module namespace async = 'com.quodatum.async';

let $xq:='2+3'


let $fut2:=async:submit(async:futureTask($xq))

return ($fut2,async:info())