(: async test :)
declare namespace Executor="java.util.concurrent.ScheduledThreadPoolExecutor";
declare namespace sf="java.util.concurrent.ScheduledFuture";
declare namespace async="java:org.apb.modules.Async";

let $shed:=Executor:new(xs:int(10))

let $xq:="
declare function local:prime($n){
  $n = 2 or ($n > 2 and (every $d in 2 to xs:integer(math:sqrt($n)) satisfies $n mod $d > 0))
};
(1 to 100000)[local:prime(.)]=>count()
"

let $tasks:=(1 to 20)! async:futureTask($xq)
(: let $fut:= Executor:schedule($shed,$run, xs:int(4), async:timeUnit("SECONDS")) :)
let $fut2:= $tasks!Executor:submit($shed,.)

let $_:=Executor:shutdown($shed)
(: wait for 1st to return value :)
return sf:get(head($tasks))