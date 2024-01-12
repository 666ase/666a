class WorkEnvironment::MorningJob < ApplicationJob
  queue_as :default

  def perform(date, options = {})
    day = TimePeriod::Day.find_by(date:)
    if day.nil? then
      week_code = Date.parse(date).strftime("%Y-W%W")
      week = TimePeriod::Week.find_by(week_code: week_code)
      if week.nil? then
        week = TimePeriod::Week.create(
          week_code: week_code
        )
        week.save!
      end
      day = TimePeriod::Day.create(
        week_id: week.id,
        date: date,
        ingestion_status: :ingestion_pending,
      )
      day.ingestion_active!
    end

    active_days = TimePeriod::Day.ingestion_active
    active_days.each_with_index do |day, index|
      if options[:cascade] then
        WorkEnvironment::DayJob.set(wait: index.seconds).perform_later(day.date, options)
      end
    end
  end
end