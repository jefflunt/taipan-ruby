infile = ARGV.shift

def strip_line_number(line)
  has_line_number?(line) ? line.split(' ', 2)[1] : line
end

def has_line_number?(line)
  line.start_with?(/\A[0-9]+\s/)
end

# main

compound_line = ''
File.open('taipan.rb', 'w') do |f|
  IO.read(infile).lines.each do |line|
    if has_line_number?(line)
      f.puts compound_line.strip
      compound_line = ''
    end

    compound_line << line.strip
  end
end
