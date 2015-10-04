(: async test :)
import module namespace async = 'com.quodatum.async';

let $xq:='2+3'
let $fulfilled:="declare variable $value external;'value' || $value "
let $future:=async:futureTask($xq,map{"fulfilled":$fulfilled})

let $fut2:=async:submit($future)
return ($fut2,async:info())