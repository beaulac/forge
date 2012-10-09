require 'spec_helper'

describe Event do
  before do
    @event = Event.new :title => "Title", :location => "Location", :description => "Description"
  end

  it "doesn't update starts_at unless asked to" do
    original_date = 3.days.ago
    @event.starts_at = original_date
    @event.ends_at = 2.days.ago
    @event.save
    @event.starts_at.strftime("%m/%d/%Y %l:%M%p").should == original_date.strftime("%m/%d/%Y %l:%M%p")
  end

  it "doesn't update ends_at unless asked to" do
    original_date = 3.days.ago
    @event.ends_at = original_date
    @event.starts_at = 4.days.ago
    @event.save
    @event.ends_at.strftime("%m/%d/%Y %l:%M%p").should == original_date.strftime("%m/%d/%Y %l:%M%p")
  end

  it "successfully updates starts_at when given valid paramters" do
    time = Time.local(1985, 11, 24, 9, 0)
    @event.starts_at_date = "1985-11-24"
    @event.starts_at_time = "9:00AM"

    @event.save!
    @event.starts_at.should == time
  end

  it "successfully updates ends_at when given valid parameters" do
    time = Time.local(1985, 11, 24, 9, 0)
    @event.ends_at_date = "1985-11-24"
    @event.ends_at_time = "9:00AM"

    @event.save!
    @event.ends_at.should == time
  end

  it "should raise an error when given junky data on starts_at_date" do
    @event.starts_at_date = "100/21/1942"
    @event.save
    @event.errors_on(:starts_at_date).should_not be_nil
  end

  it "should raise an error when given junky data on ends_at_date" do
    @event.ends_at_date = "100/21/1942"
    @event.save
    @event.errors_on(:ends_at_date).should_not be_nil
  end

  it "should raise an error when given junky data on starts_at_time" do
    @event.starts_at_time = "25:14AM"
    @event.save
    @event.errors_on(:starts_at_time).should_not be_nil
  end

  it "should raise an error when given junky data on ends_at_time" do
    @event.ends_at_time = "25:14AM"
    @event.save
    @event.errors_on(:ends_at_time).should_not be_nil
  end

  context '#next' do
    it 'returns the next newest event by starts_at' do
      oldest = Event.create(
        :title => 'oldest',
        :location => 'foo',
        :description => 'bar',
        :starts_at => Time.parse('january 1 1970'),
        :published => true)

      middle = Event.create(
        :title => 'middle',
        :location => 'foo',
        :description => 'bar',
        :starts_at => Time.parse('january 1 1985'),
        :published => true)

      newest = Event.create(
        :title => 'newest',
        :location => 'foo',
        :description => 'bar',
        :starts_at => Time.parse('january 1 2000'), 
        :published => true)

      oldest.next.should == middle # and not newest!
    end
  end

  context '#previous' do
    it 'returns the next oldest event by starts_at' do
      oldest = Event.create(
        :title => 'oldest',
        :location => 'foo',
        :description => 'bar',
        :starts_at => Time.parse('january 1 1970'),
        :published => true)

      middle = Event.create(
        :title => 'middle',
        :location => 'foo',
        :description => 'bar',
        :starts_at => Time.parse('january 1 1985'),
        :published => true)

      newest = Event.create(
        :title => 'newest',
        :location => 'foo',
        :description => 'bar',
        :starts_at => Time.parse('january 1 2000'), 
        :published => true)

      newest.previous.should == middle # and not oldest!
    end
  end
end


