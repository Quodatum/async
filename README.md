# Async

A very experimental asynchronous XQuery execution. Packaged in the EXpath `xar` format. Async is built from an XQuery module and a java jar package. 


# Install

````
"https://github.com/Quodatum/async/releases/download/v0.1.2/async-0.1.2.xar"
!repo:install(.)
````

NOTE: It works much better if the jar file is then copied to the BaseX `lib` folder. As this gives a persistant scheduler.

## Scope
The following features are implemented or planned

1. [x] Execute XQuery string $xq asynchronously 
1. [x] specify XQuery string to be executed on successful execution of $xq 
1. [x] specify XQuery string to be executed on failure of execution of $xq 
1. [x] specify delay before execution of $xq 
1. [x] list active tasks 
1. [ ] cancel active task
1. [ ] shutdown all tasks


## Usage
````xquery
(: async test :)
import module namespace async = 'com.quodatum.async';

let $xq:="
declare function local:prime($n){
  $n = 2 or ($n > 2 and (every $d in 2 to xs:integer(math:sqrt($n)) satisfies $n mod $d > 0))
};
(1 to 100000)[local:prime(.)]=>count()
"
let $fts:=(1 to 3)!async:futureTask($xq)
let $sft:= $fts!async:schedule(.,xs:dayTimeDuration("PT30S"))

(: let $_:=async:shutdown() :)
return ($sft!async:task-info(.),
        async:info()
      )
````

`samples/async/async-html.xqm` is a basic restxq demo.
## Logging
Entries are written to the BaseX log for execution start and end
````
20:51:02.865    ASYNC   admin   INFO    com.quodatum.async.CallableQuery@765b889e STARTED: declare function local:prime($n){ $n = 2 or ($n > 2 and (every $d in 2 to xs:integer(math:sqrt($n)) satisfies $n mod $d > 0)) }; (1 to 100000)[local:prime(.)]=>count()
20:51:03.365    ASYNC   admin   INFO    com.quodatum.async.CallableQuery@765b889e ENDED 503.82 ms
20:55:51.931    ASYNC   admin   INFO    com.quodatum.async.CallableQuery@3fc72f8d STARTED: declare function local:prime($n){ $n = 2 or ($n > 2 and (every $d in 2 to xs:integer(math:sqrt($n)) satisfies $n mod $d > 0)) }; (1 to 100000)[local:prime(.)]=>count()

````

## API
### futureTask

````
import module namespace async = 'com.quodatum.async';

(: todo better example :)
let $opts:=map{
    "fulfilled":"'went ok'",
    "rejected":"'failed'"
}

let $futureTask:=async:futureTask("2+2",$opts)
return async:submit($futureTask)
 
````
### writeLog
`async:writeLog("hello")`
### timeUnit
`async:timeUnit("SECONDS")`
