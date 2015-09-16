xquery version "3.0" encoding "UTF-8";
(:~
 : EXPERIMENTAL - run tasks in background  
 : @author andy bunce
 : @since 2015-08-18  
 :)
module namespace async = 'com.quodatum.async';

declare namespace Executor="java.util.concurrent.ScheduledThreadPoolExecutor";
declare namespace sf="java.util.concurrent.ScheduledFuture";
declare namespace jsync="java:com.quodatum.async.Async";

declare variable $async:THREADS:=xs:int(1);
declare variable $async:Executor:=Q{java:com.quodatum.async.ExecutorSingleton}getInstance();

(:~  
 : create submitable object to run query
 :)
declare function async:futureTask($xq as xs:string)
{
  jsync:futureTask($xq)
};

(:~ 
 : @return futuretask to run xquery, opts currenly ignored
 :)
declare function async:futureTask($xq as xs:string,$opts as map(*))
{
  jsync:futureTask($xq)
};

(:~
 : submit a task returns a future
 : @param $ft a futureTask
 :)
declare function async:submit($ft)
{
  Executor:submit($async:Executor, $ft)
};

(:~
 : schedule a task to run after delay returns a future
 : @param $ft a futureTask
 : @param $delay e.g. xs:dayTimeDuration('PT30.5S')
 :)
declare function async:schedule($ft,$delay as xs:dayTimeDuration)
{
  let $waitms := 1000* ($delay div xs:dayTimeDuration('PT1S'))
  return Executor:schedule($async:Executor, $ft,xs:int($waitms),jsync:timeUnit("MILLISECONDS"))
};

(:~
 : schedule a task to run after delay returns a future
 : @param $ft a futureTask
 : @param $delay e.g. xs:dayTimeDuration('PT30.5S')
 :)
declare function async:scheduleAtFixedRate($ft,$delay as xs:duration,$period as xs:duration)
{
  let $delayMs := 1000* ($delay div xs:dayTimeDuration('PT1S'))
  let $periodMs := 1000*($period  div xs:dayTimeDuration('PT1S'))
  return Executor:scheduleAtFixedRate(
		$async:Executor, 
		$ft,
		xs:int($delayMs),
		xs:int($periodMs),
		jsync:timeUnit("MILLISECONDS"))
};

(:~
: @return info about Executor state 
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

(:~  
 : info about a task
 :)
declare function async:task-info($task) as element(task)
{
   let $id:=substring-after($task,"$")
   let $delay:=sf:getDelay($task,jsync:timeUnit("MILLISECONDS"))
   return <task id="{$id}"
                canceled="{ sf:isCancelled($task)}"
                done="{sf:isDone($task)}"
                delay="{$delay}" 
                periodic="?" />
                  
};

(:~
 : sequence of task descriptors
 :)
 declare function async:queue() as element(task)*
{
    jsync:queue()!async:task-info(.)
};

(:~  
 : cancel a task
 :)
declare function async:task-cancel($sf,$mayInterruptIfRunning as xs:boolean) as xs:boolean
{
   sf:cancel($sf,$mayInterruptIfRunning)
};