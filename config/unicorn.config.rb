working_directory File.expand_path("../", __dir__)

worker_processes ENV.fetch("UNICORN_WORKERS", 4)

listen ENV.fetch("UNICORN_PORT", 8080)

preload_app true
