class IoHelper
  def self.gets_most_recent(io)
    line = nil
    read_ready, write_ready = IO.select([io], nil, nil, 0)
    while read_ready && read = read_ready[0]
      break if read.eof?
      break if read.closed?

      line = read.gets
      read_ready, write_ready = IO.select([io], nil, nil, 0)
    end
    line
  end

  def self.readall_nonblocking(io)
    lines = []
    read_ready, write_ready = IO.select([io], nil, nil, 0)
    while read_ready && read = read_ready[0]
      break if read.eof?
      break if read.closed?

      lines << read.gets
      read_ready, write_ready = IO.select([io], nil, nil, 0)
    end
    lines
  end

end
