(: async test :)
import module namespace async = 'com.quodatum.async';
declare namespace jsync="java:com.quodatum.async.Async";
jsync:queue()!async:task-info(.)