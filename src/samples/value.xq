(: async test
 :)
declare namespace Executor="java.util.concurrent.ScheduledThreadPoolExecutor";
declare namespace async="java:org.apb.modules.Async";
declare namespace ft="java.util.concurrent.FutureTask";
declare variable $THREADS:=xs:int(1);
declare variable $shed:=Executor:new($THREADS);

let $xq:='
let $state:=db:open("doc-doc","/state.xml")/state
return (replace value of node $state/hits with 1+$state/hits,
            db:output(1+$state/hits))
'
let $fut2:= (1 to 100)!Executor:submit($shed, async:futureTask($xq))

let $_:=Executor:shutdown($shed)
return $fut2