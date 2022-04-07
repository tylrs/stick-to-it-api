require "rails_helper"

RSpec.describe HabitLogsCreationService do
  let(:user) { create(:user) }
  let(:habit_plan) { create(:habit_plan, {user: user}) }
  let(:next_saturday) { Date.new(2022,02,01).end_of_week(:sunday) }

  describe ".create" do
    let(:habit_plan) {
      create(:habit_plan, user: user, start_datetime: "2022-02-02 00:00:00", end_datetime: "2022-02-20 00:00:00")
    }
    let(:params) { {
      name: "Running", 
      description: "Run every day",
      user_id: 1,
      start_datetime: "2022/02/02",
      end_datetime: "2022/02/10"  
    } }
    let(:start_date) { Date.new(2022,02,02) }
    let(:end_date) { Date.new(2022,02,10) }

    context "when today is not Saturday and start date is on or before next Saturday" do
      before do
        allow(Date).to receive(:today).and_return Date.new(2022,02,02)
      end

      it "calls create_current_week_logs with correct arguments" do
        expect(HabitLogsCreationService).to receive(:create_current_week_logs).with(start_date, end_date, habit_plan, next_saturday)

        HabitLogsCreationService.create(params, user)
      end

      it "does not call create_next_week_logs" do
        expect(HabitLogsCreationService).not_to receive(:create_next_week_logs).with(habit_plan)

        HabitLogsCreationService.create(params, user)
      end
    end

    context "when today is Saturday and start date is on or before next Saturday" do
      before do
        allow(Date).to receive(:today).and_return Date.new(2022,02,05)
      end

      it "calls create_current_week_logs with correct arguments" do
        expect(HabitLogsCreationService).to receive(:create_current_week_logs).with(start_date, end_date, habit_plan, next_saturday)

        HabitLogsCreationService.create(params, user)
      end

      it "calls create_next_week_logs" do
        expect(HabitLogsCreationService).to receive(:create_next_week_logs).with(habit_plan)

        HabitLogsCreationService.create(params, user)
      end
    end
  end

  describe ".create_current_week_logs" do
    let(:habit_plan) {
      create(:habit_plan, user: user, start_datetime: "2022-02-02 00:00:00", end_datetime: "2022-02-20 00:00:00")
    }

    it "calls create_logs with correct number of logs, range beginning, and habit plan" do
      allow(Date).to receive(:today).and_return Date.new(2022,02,02)
      start_date = Date.new(2022,02,02)
      end_date = Date.new(2022,02,20)

      expect(HabitLogsCreationService).to receive(:create_logs).with(4, start_date, habit_plan)
      
      HabitLogsCreationService.create_current_week_logs(start_date, end_date, habit_plan, next_saturday)
    end
  end

  describe ".create_next_week_logs" do
    let(:habit_plan) {
      create(:habit_plan, user: user, start_datetime: "2022-02-02 00:00:00", end_datetime: "2022-02-20 00:00:00")
    }

    it "calls create_logs with correct number of logs, range beginning, and habit plan" do
      allow(Date).to receive(:today).and_return Date.new(2022,02,02)
      range_beginning = Date.new(2022,02,06)

      expect(HabitLogsCreationService).to receive(:create_logs).with(7, range_beginning, habit_plan)
      
      HabitLogsCreationService.create_next_week_logs(habit_plan)
    end
  end

  describe ".determine_date_limit_initial_creation" do
    context "when start date is after next Saturday" do
      it "sets date limit to nil" do
        start_date = Date.new(2022,02,20)
        end_date = Date.new(2022,02,22)
        date_limit = HabitLogsCreationService.determine_date_limit_initial_creation(start_date, end_date, next_saturday)
  
        expect(date_limit).to be_nil
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

  describe ".get_num_logs" do
    it "returns number of days between 2 dates- inclusive of both dates" do
      start_date = Date.new(2022,02,02)
      date_limit = Date.new(2022,02,12)
      num_logs = HabitLogsCreationService.get_num_logs(start_date, date_limit)

      expect(num_logs).to eq 11
    end
  end

  describe ".create_logs" do
    let(:start_date) { Date.new(2022,02,02) }

    before do
      HabitLogsCreationService.create_logs(3, start_date, habit_plan)
    end

    it "creates a fixed number of habit logs starting at a specified date" do
      expect(user.habit_logs.count).to eq 3
    end

    it "schedules the first habit log with the start date" do
      expect(user.habit_logs.first.scheduled_at).to eq start_date
    end

    it "schedules the last habit log with a chosen number of days past the start date" do
      expect(user.habit_logs.last.scheduled_at).to eq(start_date + 2.days)
    end
  end
end