class LogService
  class << self
    def log(text)
      File.open('log/parser_gem.log', 'a') do |fo|
        fo.puts text.force_encoding('UTF-8')
      end
    end
  end
end
