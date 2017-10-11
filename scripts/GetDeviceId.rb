#!/usr/bin/ruby

class Device
  attr_accessor :ios_version, :id, :status, :iphone_version

  def <=>(other)
    self.ios_version <=> other.ios_version
  end
end

def parse_devices_file
  current_os = nil
  devices = []

  STDIN.read.split("\n").each do |line|
    if line[0..1] == "--"
      m = line.match(/-- iOS (\d+\.\d+) --/)
      unless m.nil?
        current_os = m[1]
      else
        current_os = nil
      end
    end

    unless current_os.nil?
      m = line.match(/\s+iPhone (.+) \(([0-9A-F\-]+)\) \((\w+)\)/)
      unless m.nil?
        device = Device.new
        device.iphone_version = m[1]
        device.id = m[2]
        device.status = m[3]
        device.ios_version = current_os.to_f

        devices << device
      end
    end
  end

  devices
end

d = parse_devices_file.sort.last
puts "#{d.id}\t#{d.status}"
