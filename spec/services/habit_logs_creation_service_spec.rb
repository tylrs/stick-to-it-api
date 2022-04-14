require "rails_helper"

RSpec.describe HabitLogsCreationService do
  let(:user) { create(:user) }
  let(:habit_plan) { create(:habit_plan, { user: user }) }
  let(:next_saturday) { Date.new(2022, 2, 1).end_of_week(:sunday) }

  describe ".create" do
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

      it "calls create_current_week_logs with correct arguments" do
        expect(HabitLogsCreationService).to receive(:create_current_week_logs).with(start_date, 
                                                                                    end_date, habit_plan, next_saturday)

        HabitLogsCreationService.create(habit_plan, user)
      end

      it "does not call create_next_week_logs" do
        expect(HabitLogsCreationService).not_to receive(:create_next_week_logs).with(habit_plan)

        HabitLogsCreationService.create(habit_plan, user)
      end
    end

    context "when today is Saturday and start date is on or before next Saturday" do
      before do
        allow(Date).to receive(:today).and_return Date.new(2022, 2, 5)
      end

      it "calls create_current_week_logs with correct arguments" do
        expect(HabitLogsCreationService).to receive(:create_current_week_logs).with(start_date, 
                                                                                    end_date, habit_plan, next_saturday)

        HabitLogsCreationService.create(habit_plan, user)
      end

      it "calls create_next_week_logs" do
        expect(HabitLogsCreationService).to receive(:create_next_week_logs).with(habit_plan)

        HabitLogsCreationService.create(habit_plan, user)
      end
    end
  end

  describe ".create_current_week_logs" do
    let(:habit_plan) do
      create(:habit_plan, user: user, start_datetime: Date.new(2022, 2, 2), 
                          end_datetime: Date.new(2022, 2, 20))
    end

    it "calls create_logs with correct date range and habit plan" do
      allow(Date).to receive(:today).and_return Date.new(2022, 2, 2)
      start_date = Date.new(2022, 2, 2)
      end_date = Date.new(2022, 2, 20)
      range = Date.new(2022, 2, 2)..Date.new(2022, 2, 5)

      expect(HabitLogsCreationService).to receive(:create_logs).with(range, habit_plan)
      
      HabitLogsCreationService.create_current_week_logs(start_date, end_date, habit_plan, 
                                                        next_saturday)
    end
  end

  describe ".create_next_week_logs" do
    let(:habit_plan) do
      create(:habit_plan, user: user, start_datetime: Date.new(2022, 2, 2), 
                          end_datetime: Date.new(2022, 2, 20))
    end

    it "calls create_logs with correct range and habit plan" do
      allow(Date).to receive(:today).and_return Date.new(2022, 2, 2)
      range = Date.new(2022, 2, 6)..Date.new(2022, 2, 12)

      expect(HabitLogsCreationService).to receive(:create_logs).with(range, habit_plan)
      
      HabitLogsCreationService.create_next_week_logs(habit_plan)
    end
  end

  describe ".determine_date_limit_initial_creation" do
    context "when start date is after next Saturday" do
      it "sets date limit to nil" do
        start_date = Date.new(2022, 2, 20)
        end_date = Date.new(2022, 2, 22)
        date_limit = HabitLogsCreationService.determine_date_limit_initial_creation(start_date, 
                                                                                    end_date, next_saturday)
  
        expect(date_limit).to be_nil
      end
    end

    context "when end date is before next Saturday" do
      it "sets date limit to end date" do
        start_date = Date.new(2022, 2, 0o1)
        end_date = Date.new(2022, 2, 0o4)
        date_limit = HabitLogsCreationService.determine_date_limit_initial_creation(start_date, 
                                                                                    end_date, next_saturday)
  
        expect(date_limit).to eq end_date
      end
    end
    
    context "when end date is on or after next Saturday" do
      it "sets date limit to next Saturday" do
        start_date = Date.new(2022, 2, 2)
        end_date = Date.new(2022, 2, 21)
        date_limit = HabitLogsCreationService.determine_date_limit_initial_creation(start_date, 
                                                                                    end_date, next_saturday)
        
        expect(date_limit).to eq next_saturday
      end
    end
  end

  describe ".determine_date_range" do
    before do
      allow(Date).to receive(:today).and_return Date.new(2022, 2, 2)
    end
    context "when creating logs for current week" do
      context "when start date is before next Saturday and on or after the current Sunday" do
        it "returns a date range starting on habit plan start date" do
          habit_plan = create(:habit_plan, user: user, start_datetime: Date.new(2022, 2, 2), 
          end_datetime: Date.new(2022, 2, 20))
          date_range = HabitLogsCreationService.determine_date_range(habit_plan, "current_week")
          
          expect(date_range).to eq Date.new(2022, 2, 2)..Date.new(2022, 2, 5)
        end
      end
      
      context "when start date is after next Saturday" do
        it "returns nil" do
          habit_plan = create(:habit_plan, user: user, start_datetime: Date.new(2022, 2, 20), 
          end_datetime: Date.new(2022, 2, 22))
          date_limit = HabitLogsCreationService.determine_date_range(habit_plan, "current_week")
          
          expect(date_limit).to be_nil
        end
      end
      
      context "when end date is before next Saturday" do
        it "returns a date range ending on habit plan end date" do
          habit_plan = create(:habit_plan, user: user, start_datetime: Date.new(2022, 2, 2), 
          end_datetime: Date.new(2022, 2, 4))
          date_range = HabitLogsCreationService.determine_date_range(habit_plan, "current week")
          
          expect(date_range).to eq Date.new(2022, 2, 2)..Date.new(2022, 2, 4)
        end
      end
      
      context "when end date is on or after next Saturday" do
        it "returns a date range ending on next Saturday" do
          habit_plan = create(:habit_plan, user: user, start_datetime: Date.new(2022, 2, 2), 
          end_datetime: Date.new(2022, 2, 20))
          date_range = HabitLogsCreationService.determine_date_range(habit_plan, "current week")
          
          expect(date_range).to eq Date.new(2022, 2, 2)..Date.new(2022, 2, 5)
        end
      end
      
    end

    context "when creating logs for next week" do
      context "when a habit plan start and end date occur within next week" do
        it "returns a date range starting on habit plan start date" do
          expect(range[:range_beginning]).to eq habit_plan.start_datetime
        end 
    
        it "returns a date range ending on habit plan end date" do
          expect(range[:range_end]).to eq habit_plan.end_datetime
        end
      end
  
      context "when habit plan start date is before next Sunday" do
        let(:habit_plan) do
          create(:habit_plan, start_datetime: Date.new(2022, 2, 2), 
                              end_datetime: Date.new(2022, 2, 20))
        end      
        let(:range) { HabitPlansFilterService.determine_next_week_range(habit_plan) }
  
        it "returns a date range starting on next sunday" do
          expect(range[:range_beginning]).to eq next_sunday
        end
      end
  
      context "when habit plan end date is after the following Saturday" do
        let(:habit_plan) do
          create(:habit_plan, start_datetime: Date.new(2022, 2, 2), 
                              end_datetime: Date.new(2022, 2, 20))
        end      
        let(:range) { HabitPlansFilterService.determine_next_week_range(habit_plan) }
  
        it "returns a date range ending on the following saturday" do
          expect(range[:range_end]).to eq following_saturday
        end
      end
    end
  end

  describe ".create_logs" do
    let(:start_date) { Date.new(2022, 2, 2) }

    before do
      date_limit = Date.new(2022, 2, 4)
      HabitLogsCreationService.create_logs(start_date..date_limit, habit_plan)
    end

    it "creates a fixed number of habit logs based on a date range" do
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
