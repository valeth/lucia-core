json.array! @services do |s|
  json.name s.name
  json.desc s.desc
  json.status s.status
  json.pid s.pid
  json.executable s.executable
  json.tasks s.tasks
  json.memory s.memory
  json.cpu_time s.cpu_time
end
