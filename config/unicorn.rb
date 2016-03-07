root = "/var/www/public_tracker.com/current"
shared_root = "/var/www/public_tracker.com/shared"
working_directory root
pid "#{shared_root}/pids/unicorn.pid"
stderr_path "#{shared_root}/log/unicorn-stderr.log"
stdout_path "#{shared_root}/log/unicorn-stdout.log"

listen "#{shared_root}/sockets/unicorn.public_tracker.com.sock"
worker_processes 2
timeout 120