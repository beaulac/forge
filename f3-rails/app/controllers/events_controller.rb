class EventsController < ApplicationController
  caches_page :index, :show

  helper LaterDude::CalendarHelper

  def index
    @page_title = 'Listing Events'
    @events = Event.published.order('starts_at DESC')

    if Forge::Settings[:events][:display] == 'calendar'
      @now = Time.now

      @year = (params[:year] || @now.year).to_i
      @month = (params[:month] || @now.month).to_i

      template = 'events/index_calendar'
    else
      template = 'events/index_list'
    end

    respond_to do |format|
      format.html { render :template => template }
      format.mobile { render :template => 'mobile/events' }
    end
  end

  def show
    @event = Event.find_by_id!(params[:id])
    @page_title = @event.title

    respond_to do |format|
      format.html
      format.mobile { render :template => 'mobile/event' }
    end
  end
end
