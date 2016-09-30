class Roman
  def self.method_missing(name, _args)
    roman = name.to_s
    roman.gsub!('IV', 'IIII')
    roman.gsub!('IX', 'VIIII')
    roman.gsub!('XL', 'XXXX')
    roman.gsub!('XC', 'LXXXX')

    (roman.count('I') * 1 +
     roman.count('V') * 5 +
     roman.count('X') * 10 +
     roman.count('L') * 50 +
     roman.count('C') * 100)
  end
end

## Day 3 problems

module ActsAsCsv
  class CsvRow
    def initialize(csv, contents)
      @csv = csv
      @contents = contents
    end

    def method_missing(name, *args)
      position = @csv.headers.index name.to_s
      @contents[position] if position
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def acts_as_csv
      include InstanceMethods
    end
  end

  module InstanceMethods
    def read
      @csv_contents = []
      filename = 'seven_languages_in_seven_weeks/' + self.class.to_s.downcase + '.txt'
      file = File.new(filename)
      @headers = file.gets.chomp.split(', ')
      file.each do |row|
        @csv_contents << row.chomp.split(', ')
      end
    end

    def each(&block)
      csv_contents.each do |contents|
        block.call(CsvRow.new(self, contents))
      end
    end

    attr_accessor :headers, :csv_contents

    def initialize
      read
    end
  end
end

class RubyCsv # no inheritance! You can mix it in
  include ActsAsCsv
  acts_as_csvj
end

# Modify the CSV application to support an each method to return a CsvRow
# object. Use method_missing on that CsvRow to return the value for the column
# for a given heading.

# For example, for the file:

## one, two
## lions, tigers

# allow an API that works like this:

csv = RubyCsv.new
csv.each { |row| puts row.one }

# This should print "lions".
