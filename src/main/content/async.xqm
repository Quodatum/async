xquery version "3.0" encoding "UTF-8";
(:~
 : EXPERIMENTAL - run tasks in background  
 : @author andy bunce
 : @since 2015-08-18  
 :)
module namespace async = 'quodatum.async';

declare namespace Executor="java.util.concurrent.ScheduledThreadPoolExecutor";
declare namespace sf="java.util.concurrent.ScheduledFuture";
declare namespace jsync="java:org.apb.modules.Async";

declare variable $async:THREADS:=xs:int(1);
declare variable $async:Executor:=Executor:new($async:THREADS);

(:~  
 : create submitable object to run query
 :)
declare function async:futureTask($xq as xs:string)
{
  jsync:futureTask($xq)
};


declare function async:futureTask($xq as xs:string,$opts as map(*))
{
  jsync:futureTask($xq)
};

declare function async:submit($ft)
{
  Executor:submit($async:Executor, $ft)
};

(:~ 
 : java.util.concurrent.ScheduledThreadPoolExecutor@20a9578a[Shutting down, pool size = 1, active threads = 1, queued tasks = 9, completed tasks = 0]
 :)
declare function async:info() as xs:string
{
  Executor:toString($async:Executor)
};

(:~  
 : shutdown scheduler when jobs finished 
 :)
declare function async:shutdown(){
  Executor:shutdown($async:Executor)
};

declare function async:task-info($task) as xs:string
{
   out:format("task $s - canceled:%b, done:%b","?",sf:isCancelled($task), sf:isDone($task))
};