module EventsHelper
  def events_calendar_proc
    proc do |time|
      date = time.strftime('%Y%m%d')
      events = Event.select { |e| e.starts_at.strftime('%Y%m%d') == date }

      if events.size > 0
        link_to time.day, url_for(events.first)
      else
        time.day
      end
    end
  end
end
