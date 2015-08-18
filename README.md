# Async

````
Q{java:org.apb.modules.ExecutorSingleton}getInstance()
````

Background task experiments. See `shed.xq`
### runnable

````
declare namespace async="java:org.apb.modules.Async";

async:futureTask("2+2")
````

### timeUnit
`async:timeUnit("SECONDS")`