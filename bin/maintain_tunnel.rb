#!/usr/bin/env ruby
port = 2114
pid=`ps -axo pid,command,args | grep -i "#{port}" | grep -v grep | awk '{ print $1 }'`.strip

if `ping -t 1 -c 1 4.2.2.1 | grep 100`.include? "100.0% packet loss"
  puts "network down"
  if pid.to_i > 0
    puts "killing tunnel #{pid}"
    `kill -9 #{pid}`
  end
else
  puts "network up"
  unless pid.to_i > 0
    puts "starting tunnel"
    `ssh -fN -R #{port}:localhost:22 marshally@yountlabs.com`
  end
end

# NOTE: get back in with `ssh -p #{port} -l macmini localhost`
