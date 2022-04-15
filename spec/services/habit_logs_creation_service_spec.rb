require "rails_helper"

RSpec.describe HabitLogsCreationService do
  let(:user) { create(:user) }
  let(:habit_plan) { create(:habit_plan, { user: user }) }
  let(:next_saturday) { Date.new(2022, 2, 1).end_of_week(:sunday) }

  describe ".create_logs" do
    context "when a habit plan has a date within the week type" do
      before do
        allow(Date).to receive(:today).and_return Date.new(2022, 2, 2)
  
        HabitLogsCreationService.create_logs(habit_plan, "current_week")
      end
  
      it "creates habit_logs based on the habit plan and week type" do
        expect(user.habit_logs.count).to eq 4
      end
  
      it "schedules the first habit log with the start date" do
        expect(user.habit_logs.first.scheduled_at).to eq habit_plan.start_datetime
      end
  
      it "schedules the last habit log with a chosen number of days past the start date" do
        expect(user.habit_logs.last.scheduled_at).to eq(habit_plan.start_datetime + 3.days)
      end
    end

    context "when a habit plan does not have a date within the week type" do
      before do
        allow(Date).to receive(:today).and_return Date.new(2022, 2, 25)
  
        HabitLogsCreationService.create_logs(habit_plan, "current_week")
      end

      it "does not create any logs" do
        expect(user.habit_logs.count).to eq 0
      end
    end
  end

  describe ".create_initial_logs" do
    let(:habit_plan) do
      create(:habit_plan, user: user, start_datetime: Date.new(2022, 2, 2), 
                          end_datetime: Date.new(2022, 2, 10))
    end
    let(:params) do 
      {
        name: "Running", 
        description: "Run every day",
        user_id: 1,
        start_datetime: "2022/02/02",
        end_datetime: "2022/02/10"  
      }
    end    
    let(:start_date) { Date.new(2022, 2, 2) }
    let(:end_date) { Date.new(2022, 2, 10) }

    context "when today is not Saturday and start date is on or before next Saturday" do
      before do
        allow(Date).to receive(:today).and_return Date.new(2022, 2, 2)
      end

      it "calls create_logs with correct arguments" do
        expect(HabitLogsCreationService).to receive(:create_logs).with(habit_plan, "current_week")

        HabitLogsCreationService.create_initial_logs(habit_plan)
      end

      it "does not call create_logs again" do
        expect(HabitLogsCreationService).not_to receive(:create_logs).with(habit_plan, "next_week")

        HabitLogsCreationService.create_initial_logs(habit_plan)
      end
    end

    context "when today is Saturday and start date is on or before next Saturday" do
      before do
        allow(Date).to receive(:today).and_return Date.new(2022, 2, 5)
      end

      it "calls create_logs twice with current_week option and next_week option" do
        expect(HabitLogsCreationService).to receive(:create_logs).with(habit_plan, "current_week")
        expect(HabitLogsCreationService).to receive(:create_logs).with(habit_plan, "next_week")

        HabitLogsCreationService.create_initial_logs(habit_plan)
      end
    end
  end

  describe ".determine_date_range" do
    before do
      allow(Date).to receive(:today).and_return Date.new(2022, 2, 2)
    end
    context "current week" do
      context "when start date is before current Saturday and on or after the current Sunday" do
        it "returns a date range starting on habit plan start date" do
          habit_plan = create(:habit_plan, user: user, start_datetime: Date.new(2022, 2, 2), 
                                           end_datetime: Date.new(2022, 2, 20))
          date_range = HabitLogsCreationService.determine_date_range(habit_plan, "current_week")
          
          expect(date_range).to eq Date.new(2022, 2, 2)..Date.new(2022, 2, 5)
        end
      end
      
      context "when start date is after current Saturday" do
        it "returns nil" do
          habit_plan = create(:habit_plan, user: user, start_datetime: Date.new(2022, 2, 20), 
                                           end_datetime: Date.new(2022, 2, 22))
          date_limit = HabitLogsCreationService.determine_date_range(habit_plan, "current_week")
          
          expect(date_limit).to be_nil
        end
      end

      context "when end date is before current Sunday" do
        it "returns nil" do
          habit_plan = create(:habit_plan, user: user, start_datetime: Date.new(2022, 2, 20), 
                                           end_datetime: Date.new(2022, 2, 22))
          date_limit = HabitLogsCreationService.determine_date_range(habit_plan, "current_week")
          
          expect(date_limit).to be_nil
        end
      end
      
      context "when end date is before current Saturday" do
        it "returns a date range ending on habit plan end date" do
          habit_plan = create(:habit_plan, user: user, start_datetime: Date.new(2022, 2, 2), 
                                           end_datetime: Date.new(2022, 2, 4))
          date_range = HabitLogsCreationService.determine_date_range(habit_plan, "current_week")
          
          expect(date_range).to eq Date.new(2022, 2, 2)..Date.new(2022, 2, 4)
        end
      end
      
      context "when end date is on or after current Saturday" do
        it "returns a date range ending on current Saturday" do
          habit_plan = create(:habit_plan, user: user, start_datetime: Date.new(2022, 2, 2), 
                                           end_datetime: Date.new(2022, 2, 20))
          date_range = HabitLogsCreationService.determine_date_range(habit_plan, "current_week")
          
          expect(date_range).to eq Date.new(2022, 2, 2)..Date.new(2022, 2, 5)
        end
      end
      
    end

    context "next week" do
      context "when a habit plan start and end date occur within next week" do
        it "returns a date range starting on habit plan start date and ending on habit plan end date" do
          habit_plan = create(:habit_plan, user: user, start_datetime: Date.new(2022, 2, 7), 
                                           end_datetime: Date.new(2022, 2, 11))
          date_range = HabitLogsCreationService.determine_date_range(habit_plan, "next_week")
          
          expect(date_range).to eq Date.new(2022, 2, 7)..Date.new(2022, 2, 11)
        end 
      end
  
      context "when habit plan start date is before next Sunday" do  
        it "returns a date range starting on next sunday" do
          habit_plan = create(:habit_plan, user: user, start_datetime: Date.new(2022, 2, 2), 
                                           end_datetime: Date.new(2022, 2, 11))
          date_range = HabitLogsCreationService.determine_date_range(habit_plan, "next_week")
          
          expect(date_range).to eq Date.new(2022, 2, 6)..Date.new(2022, 2, 11)
        end
      end
  
      context "when habit plan end date is after the following Saturday" do  
        it "returns a date range ending on the following saturday" do
          habit_plan = create(:habit_plan, user: user, start_datetime: Date.new(2022, 2, 6), 
                                           end_datetime: Date.new(2022, 2, 20))
          date_range = HabitLogsCreationService.determine_date_range(habit_plan, "next_week")
          
          expect(date_range).to eq Date.new(2022, 2, 6)..Date.new(2022, 2, 12)
        end
      end

      context "when habit plan end date is before next Sunday" do
        it "returns nil" do
          habit_plan = create(:habit_plan, user: user, start_datetime: Date.new(2022, 2, 2), 
                                           end_datetime: Date.new(2022, 2, 4))
          date_range = HabitLogsCreationService.determine_date_range(habit_plan, "next_week")
          
          expect(date_range).to be_nil
        end
      end

      context "when habit plan start date is after the following Saturday" do
        it "returns nil" do
          habit_plan = create(:habit_plan, user: user, start_datetime: Date.new(2022, 2, 20), 
                                           end_datetime: Date.new(2022, 2, 24))
          date_range = HabitLogsCreationService.determine_date_range(habit_plan, "next_week")
          
          expect(date_range).to be_nil
        end
      end
    end
  end
end
