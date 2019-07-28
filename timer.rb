require './scraper'

class Timer
  def initialize
    while true
      Scraper.new.call
      sleep 10

      puts rand(0-5)
    end
  end
end

Timer.new
