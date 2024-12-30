#F5、A10、Horizon都是用的TCL语言
when HTTP_REQUEST {
   if { [HTTP::host] contains "www.demo-host-1.com"} {
        if { [HTTP::uri] == "/equals"} {
            pool POOL_DEMO_SLB_1_80 
            #www.demo-host-1.com的uri等于/equals分发到POOL_DEMO_SLB_1_80
        } else {pool POOL_DEMO_SLB_2_80 
            #www.demo-host-1.com的uri不等于/equals分发到POOL_DEMO_SLB_2_80
        }    
	} elseif { [HTTP::host] contains "www.demo-host-2.com"} {
       HTTP::header insert "InsetHeader" Horizon
      pool POOL_DEMO_SLB_2_80
      #insert "InsetHeader" Horizon
      #www.demo-host-2.com分发到POOL_DEMO_SLB_2_80    	
    } elseif { [HTTP::host] contains "www.demo-host-3.com"} {
        if {[IP::addr [IP::client_addr] equals 10.168.11.208/32]} {
            HTTP::respond 200 content "<html><head><title>Horizon DEMO</title></head>
                <body>Your Address Is Forbidden</body>
                </html>" "Content-Type" "text/html"
            #www.demo-host-3.com并且Client IP是100.136.11.208时，响应html页面
            #如果想用CLASS::match，只能用CLIENT_ACCEPTED event
        }
    } else { 
      HTTP::redirect "http://youtube.com" 
         log local0. "[IP::client_addr] request VIP:10.168.11.26 has been redirect"	
         #这个vs其他域名，重定向到youtube,并且print log
    }
}
