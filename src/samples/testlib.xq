(: async test :)
import module namespace async = 'com.quodatum.async';

let $xq:="
declare variable $state as element(state):=doc('doc-doc/state.xml')/state;

(
  replace value of node $state/hits with 1+$state/hits,
db:output(1+$state/hits)
)
"


let $fut2:= (1 to 10000)!async:submit(async:futureTask($xq))

let $_:=async:shutdown()
return async:info()