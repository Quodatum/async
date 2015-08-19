(:~
 : This module contains some basic examples for RESTXQ annotations
 : @author BaseX Team
 :)
module namespace page = 'http://basex.org/modules/web-page';
import module namespace session = "http://basex.org/modules/session";
import module namespace async = 'quodatum.async';  

(:~
 : This function generates the welcome page.
 : @return HTML page
 :)
declare
  %rest:path("test")
  %rest:method("GET")
  %output:method("html")
  %output:version("5.0")
  function page:start()
  as element(html)
{
 	
  <html >
    <head>
      <title>test</title>
      <link rel="stylesheet" type="text/css" href="static/style.css"/>
    </head>
    <body>
     <div>{async:info()}</div>
	 <form method="post" action="test"> 
	 <input type="submit" value="submit"/> 
	  </form>
    </body>
  </html>
};

declare
  %rest:path("test")
  %rest:method("POST")
  %output:method("html")
  %output:version("5.0")
  function page:post()
{
 let $xq:="
declare variable $state as element(state):=doc('doc-doc/state.xml')/state;
(
  replace value of node $state/hits with 1+$state/hits,
db:output(1+$state/hits)
)
"

let $fut2:= (1 to 10000)!async:submit(async:futureTask($xq))
return 	web:redirect('/test')
  
};
