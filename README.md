# Async

A very experimental asynchronous XQuery execution 

````
Q{java:com.quodatum.async.ExecutorSingleton}getInstance()
````

Background task experiments. See `shed.xq`

### futureTask

````
declare namespace async="java:com.quodatum.async.Async";

async:futureTask("2+2")

async:submit($futureTask)
````

### timeUnit
`async:timeUnit("SECONDS")`