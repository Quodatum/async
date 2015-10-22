(: async test :)
import module namespace async = 'com.quodatum.async';
(: https://github.com/james-jw/xq-mustache :)
import module namespace mustache = 'http://xq-mustache';

declare function local:get($uri) as xs:string {
   'let $req := <http:request method="GET" login="async" password="isAwesome" />
    return http:send-request($reqIn, "{{uri}}")[2]
   '!mustache:render(.,map{"uri":$uri})
};
let $xq:=local:get("https://github.com/")
let $fulfilled:="declare variable $value external;'value' || $value "
let $future:=async:futureTask($xq,map{"fulfilled":$fulfilled})
let $fut2:=async:submit($future)
return $fut2