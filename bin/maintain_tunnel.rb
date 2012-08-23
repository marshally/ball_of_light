#!/usr/bin/env ruby
port = 2114
pids = `ps -axo pid,command,args | grep -i "#{port}" | grep -v grep | awk '{ print $1 }'`.split

nework_is_up = `ping -c 1 -t 1 4.2.2.1 | grep -i "100.0% packet loss" | wc -l`.to_i==0
if nework_is_up
  puts "network up"
  if pids.count > 1
    `kill -9 #{pids.pop}`
  end

  if pids.count == 0
    puts "starting tunnel"
    `ssh -fN -R #{port}:localhost:22 marshally@yountlabs.com >/dev/null 2>/dev/null`
  end
else
  puts "network down"
  pids.each do |pid|
    puts "killing tunnel #{pid}"
    `kill -9 #{pid}`
  end
end

# NOTE: get back in with `ssh -p #{port} -l macmini localhost`
