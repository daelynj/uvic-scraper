require './scraper'

class Timer
  def initialize
    while true
      Scraper.new.call
      sleep 10
    end
  end
end

Timer.new
