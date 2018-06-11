environment = ENV.fetch("RAILS_ENV") { "development" }

working_directory File.expand_path("../", __dir__)

worker_processes ENV.fetch("UNICORN_WORKERS") { `nproc`&.to_i || 4 }

listen ENV.fetch("UNICORN_PORT") { 8080 }

socket_dir = Pathname.new(ENV["XDG_RUNTIME_DIR"] || ENV["TMPDIR"] || Dir.tmpdir).join("lucia_core")
socket_dir.mkpath
listen socket_dir.join("unicorn.sock").to_s

preload_app true

timeout 30

worker_user = ENV.fetch("UNICORN_WORKER_USER") { Etc.getpwuid(Process.euid).name }
worker_group = ENV.fetch("UNICORN_WORKER_GROUP") { Etc.getgrgid(Process.egid).name }

after_fork do |server, worker|
  uid = Process.euid
  gid = Process.egid
  target_uid = Etc.getpwnam(worker_user).uid
  target_gid = Etc.getgrnam(worker_group).gid

  if uid != target_uid || gid != target_gid
    Process.initgroups(worker_user, target_gid)
    Process::GID.change_privilege(target_gid)
    Process::UID.change_privilege(target_uid)
  end
rescue => e
  if environment == "development"
    $stderr.puts "Failed to change user"
  else
    raise e
  end
end
