environment = ENV.fetch("RAILS_ENV") { "development" }

working_directory File.expand_path("../", __dir__)

worker_processes ENV.fetch("UNICORN_WORKERS") { `nproc`&.to_i || 4 }

listen ENV.fetch("UNICORN_PORT") { 8080 }

socket_dir = Pathname.new(ENV["TMPDIR"] || Dir.tmpdir).join("lucia_core")
socket_dir.mkpath
listen socket_dir.join("unicorn.sock").to_s

preload_app true

timeout 30

initialized = false

before_fork do |server, worker|
  next if initialized

  Thread.new do
    require "childprocess"

    ChildProcess.build("sidekiq").tap do |p|
      p.io.inherit!
      p.start
      p.wait
      p.close
    end
  end

  initialized = true
rescue => e
  raise e if environment == "development"
  warn e.message
  warn e.backtrace.join("\n")
  exit 1
end

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
  raise e if environment == "development"
  warn "Failed to change user"
end
