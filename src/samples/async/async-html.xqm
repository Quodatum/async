(:~
 : This module shows usage of the async extension from RESTXQ
 : @author Quodatum
 :)
module namespace page = 'http://basex.org/modules/web-page';
import module namespace session = "http://basex.org/modules/session";
import module namespace async = 'com.quodatum.async';  

(: code samples :)
declare variable $page:update:="
declare variable $state as element(state):=doc('doc-doc/state.xml')/state;
(
  replace value of node $state/hits with 1+$state/hits,
db:output(1+$state/hits)
)
";

(:~
 : This function generates the welcome page.
 : @return HTML page 
 :)
declare
  %rest:path("async")
  %rest:method("GET")
  %output:method("html")
  %output:version("5.0")
  function page:start()
  as element(html)
{
  let $info:=async:info()
 (: let $c:=Q{java:org.apb.modules.TestModule}makeCollection($async:Executor) :)
  return   
  <html >
    <head>
      <title>Async web demo v0.1</title>
	  <link href="//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.1/css/bootstrap.css" rel="stylesheet" type="text/css" /> 
      <link rel="stylesheet" type="text/css" href="static/style.css"/>
    </head>
    <body>
     <div>{$info}</div>
     <button onclick="location.reload(true);">Reload</button>
	 <div classs="container-fluid">
	  <div class="col-md-8">
      <h2>Tasks</h2>
      <ol>{
      for $t in async:queue()
      return <li>{serialize($t)}</li>
      }</ol></div>
    	 <form method="post" action="async" class="col-md-4 well">
        	<div class="form-group">
        		<label for="style">Task style</label>	 
        		 <select name="style" class="form-control">
        			  <option value="submit">submit 10000</option>
        			  <option value="schedule">schedule after (30.5 seconds)</option>
        			  <option value="fixedrate">fixedrate</option>
        		</select>
        	</div>
        	<div class="form-group">
                <label for="size">size</label>
                <input type="number" class="form-control" id="size" name="size" value="1" placeholder="number of tasks"/>
             </div>
    	   <button type="submit" >Run</button> 
    	  </form>
	 
	  </div>
    </body>
  </html>
};

declare
  %rest:path("async")
  %rest:method("POST")
  %rest:form-param("style","{$style}", "submit")
  %rest:form-param("size","{$size}", 1)
  %output:method("html")
  %output:version("5.0")
  function page:post($style as xs:string,$size as xs:integer)
{ 
    let $delay:=xs:dayTimeDuration('PT30.5S')
	let $period:=xs:dayTimeDuration('PT20S')
	let $ft:=async:futureTask($page:update)
	let $fut:= switch($style)	          
			   case "schedule" return (1 to $size)!async:schedule($ft,$delay)
			   case "fixedrate" return (1 to $size)!async:scheduleAtFixedRate($ft,$delay,$period)
               case "submit" return (1 to $size)!async:submit($ft)
               default return (1 to $size)!async:submit($ft)
			   
	return 	web:redirect(web:create-url('/async', map { 'style': $style }))
};
