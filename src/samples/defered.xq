(: async test :)
import module namespace async = 'com.quodatum.async';
(: https://github.com/james-jw/xq-mustache :)
import module namespace mustache = 'http://xq-mustache';
declare namespace ft="java.util.concurrent.FutureTask";

declare function local:get($uri) as xs:string {
   'let $req := <http:request method="GET"  />
    return http:send-request($req, "{{uri}}")[2]
   '!mustache:render(.,map{"uri":$uri})
};

let $uris:=("https://github.com/","http://basex.org/")
let $tasks:=$uris! async:futureTask(local:get(.))
let $fut2:=$tasks!async:submit(.)

return $tasks!ft:get(.)