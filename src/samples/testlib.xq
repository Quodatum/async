(: async test :)
import module namespace async = 'com.quodatum.async';

let $xq:="
declare function local:prime($n){
  $n = 2 or ($n > 2 and (every $d in 2 to xs:integer(math:sqrt($n)) satisfies $n mod $d > 0))
};
(1 to 100000)[local:prime(.)]=>count()
"
let $fts:=(1 to 1)!async:futureTask($xq)
let $sft:= $fts!async:schedule(.,xs:dayTimeDuration("PT1M"))

(: let $_:=async:shutdown() :)
return ($sft!async:task-info(.),
        async:info()
      )