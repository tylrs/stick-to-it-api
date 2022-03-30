require "rails_helper"

RSpec.describe HabitLogsCreationService do
  let(:user) {create(:user)}
  let(:habit_plan) {create(:habit_plan, {user: user})}

  describe ".get_num_logs" do
    it "returns number of days between and including 2 dates" do
      date_limit = Date.new(2022,02,12)
      start_date = Date.new(2022,02,02)
      num_logs = HabitLogsCreationService.get_num_logs(start_date, date_limit)

      expect(num_logs).to eq 11
    end
  end

  describe ".create_logs" do
    let(:logs) { HabitLog.all }
    let(:start_date) { Date.new(2022,02,02) }

    before do
      HabitLogsCreationService.create_logs(3, start_date, habit_plan)
    end

    it "creates a fixed number of habit logs starting at a specified date" do
      expect(logs.count).to eq 3
    end

    it "creates a habit log with the start date" do
      expect(logs.first.scheduled_at).to eq start_date
    end

    it "schedules a habit log for specified number of days past the date limit" do
      expect(logs.last.scheduled_at).to eq(start_date + 2.days)
    end
  end

  describe ".determine_date_limit_initial_creation" do
    next_saturday = Date.new(2022,02,01).end_of_week(:sunday)

    context "when start_date is after next Saturday" do
      it "sets date limit to nil" do
        start_date = Date.new(2022,02,20)
        end_date = Date.new(2022,02,22)
        date_limit = HabitLogsCreationService.determine_date_limit_initial_creation(start_date, end_date, next_saturday)
  
        expect(date_limit).to eq nil
      end
    end

    context "when end date is before next Saturday" do
      it "sets date limit to end date" do
        start_date = Date.new(2022,02,01)
        end_date = Date.new(2022,02,04)
        date_limit = HabitLogsCreationService.determine_date_limit_initial_creation(start_date, end_date, next_saturday)
  
        expect(date_limit).to eq end_date
      end
    end
    
    context "when end date is on or after next Saturday" do
      it "sets date limit to next Saturday" do
        start_date = Date.new(2022,02,02)
        end_date = Date.new(2022,02,21)
        date_limit = HabitLogsCreationService.determine_date_limit_initial_creation(start_date, end_date, next_saturday)
        
        expect(date_limit).to eq next_saturday
      end
    end
  end

  describe "create_next_week_logs" do
    let(:habit_plan) { 
      create(:habit_plan, user: user, start_datetime: "2022-02-02 00:00:00", end_datetime: "2022-02-20 00:00:00")
    }

    it "calls determine_next_week_range with habit plan" do
      allow(Date).to receive(:today).and_return Date.new(2022,2,2)
      HabitLogsCreationService.create_next_week_logs(habit_plan)

      expect(HabitPlansFilterService).to receive(:determine_next_week_range).with(habit_plan).and_return({})
    end

    it "creates the correct amount of habit logs" do
      expect{HabitLogsCreationService.create_next_week_logs(habit_plan)}.to increase(HabitLog.count).by(7)
    end

    it "calls get_num_logs with range beginning and end" do
      
    end

    it "calls create_logs with num logs, range beginning and habit plan" do
      
    end
  end

  describe "create_current_week_logs" do
    
  end

  describe "create" do

  end
end