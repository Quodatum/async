# Async

A very experimental asynchronous XQuery execution. Packaged in the EXpath `xar` format. Async is built from an XQuery module and a java jar package. 

## Usage
````xquery
(: async test :)
import module namespace async = 'com.quodatum.async';

let $xq:='2+3'
let $fut2:=async:submit(async:futureTask($xq))
return ($fut2,async:info())
````

## Logging
Entries are written to the BaseX log for execution start and end
````
21:44:16.647    ASYNC   admin   INFO    STARTED: let $a:="C:\tmp"!file:list(.)!<file name="{.}"/> return db:replace("!ASYNC","dir.xml",<foo>{$a}</foo>)
21:44:16.693    ASYNC   admin   INFO    ENDED   40.91 ms
````

## API
### futureTask

````
declare namespace async="java:com.quodatum.async.Async";

async:futureTask("2+2")

async:submit($futureTask)
````

### timeUnit
`async:timeUnit("SECONDS")`
