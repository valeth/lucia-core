# frozen_string_literal: true

class ServiceStatus
  METRICS = %i[name desc status pid executable tasks memory cpu_time].freeze

  def initialize(name)
    @status = `systemctl status #{name}`.lines.map(&:strip)
    @attributes = METRICS.zip([name]).to_h
    return unless available?
    populate
    METRICS.each do |metric|
      define_singleton_method(metric) { @attributes[metric] }
    end
  end

  def available?
    @status.present?
  end

private

  def populate
    description
    status
    process
    tasks
    memory
    cpu_time
  end

  def cpu_time
    @attributes[:cpu_time] =
      @status.select { |l| l.start_with?("CPU") }.first&.split&.last || "0d 0h 0min 0s 0ms"
  end

  def description
    @attributes[:desc] =
      @status.first&.split(".service - ")&.last
  end

  def tasks
    @attributes[:tasks] =
      @status.select { |l| l.start_with?("Tasks") }.first&.split&.fetch(1, nil)&.to_i
  end

  def process
    main_pid = @status.select { |l| l.start_with?("Main PID") }.first
    pid, process = /.*: (\d+) \((.*)\)/.match(main_pid)&.captures
    @attributes.update(pid: pid&.to_i, executable: process)
  end

  def memory
    @attributes[:memory] =
      @status.select { |l| l.start_with?("Memory") }.first&.split(" ")&.last
  end

  def status
    @attributes[:status] =
      /.*: (.* \(.*\)) /.match(@status[2])&.captures&.first || "unknown (unknown)"
  end
end
