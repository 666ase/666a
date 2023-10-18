require "time"

class DayJob < ApplicationJob
  queue_as :default

  def perform(date, cascade = false)
    puts "DayJob: begin"

    day = Day.find_by(date:)

    puts day.inspect
    if day.nil? then
      return
    end

    if day.looks_dormant? then
      day.ingestion_complete!
      return
    end

    if Time.now < Time.parse("22:00") then
      self.class.set(wait: 1.minutes).perform_later(date, cascade)
    end

    if cascade then
      SearchJob.perform_later(day.date, cascade)
    end

    puts "DayJob: end"
  end
end