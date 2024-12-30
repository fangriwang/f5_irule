#F5、A10、Horizon都是用的TCL语言
when HTTP_REQUEST {
    if { [HTTP::uri] starts_with "/start" } {
        pool POOL_DEMO_SLB_3_80
        #uri以/start开始分发到POOL_DEMO_SLB_3_80
    } elseif { [HTTP::uri] ends_with "/end" } {
        pool POOL_DEMO_SLB_4_80
        #uri以d/en结束分发到POOL_DEMO_SLB_4_80
    } elseif { [HTTP::uri] contains "/contains" } {
            HTTP::respond 200 content "<html><head><title>Horizon DEMO</title></head>
               <body>Horizon URI Respond Test</body>
               </html>" "Content-Type" "text/html"
        #uri包含/contains返回html页面
    } elseif { [HTTP::uri] equals "/equals" } {
        HTTP::redirect "https://google.com"
        #uri等于/equals的重定向到https://google.com
    } elseif {[HTTP::uri] starts_with "/web/"} {
                set web_uri [string map -nocase {"/web/" "/"} [HTTP::uri]]
                HTTP::uri $web_uri
                pool POOL_DEMO_SLB_3_80
        #uri以/web/开始，将/web/替换成/然后分发到POOL_DEMO_SLB_3_80
    } elseif {[HTTP::uri] equals "/agent"} {
        if {[HTTP::header "User-Agent"] contains "Edg" } {
            HTTP::respond 200 content "<html><head><title>Horizon DEMO</title></head>
               <body>User-Agent contains Edg</body>
               </html>" "Content-Type" "text/html"
        #uri等于/agent并且HTTP Header的User-Agent包含Edg,响应html页面
        }
    }
}