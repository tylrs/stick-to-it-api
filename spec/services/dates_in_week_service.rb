require "rails_helper"

RSpec.describe DatesInWeekService do
  describe ".get_week_start" do
    before do
      allow(Date).to receive(:today).and_return(Date.new(2022, 2, 2))
    end

    context "when week_type is current_week" do
      it "should return the most recent Sunday of the current week" do
        week_start = DatesInWeekService.get_week_start("current_week")

        expect(week_start).to eq Date.new(2022, 1, 30)
      end
    end

    context "when week_type is next_week" do
      it "should return the most recent Sunday of next week" do
        week_start = DatesInWeekService.get_week_start("next_week")

        expect(week_start).to eq Date.new(2022, 2, 6)
      end
    end
  end

  describe ".get_week_end" do
    before do
      allow(Date).to receive(:today).and_return(Date.new(2022, 2, 2))
    end
    
    context "when week_type is current_week" do
      it "should return the next Saturday of the current week" do
        week_end = DatesInWeekService.get_week_end("current_week")

        expect(week_end).to eq Date.new(2022, 2, 5)
      end
    end

    context "when week_type is next_week" do
      it "should return the next Saturday of next week" do
        week_end = DatesInWeekService.get_week_end("next_week")

        expect(week_end).to eq Date.new(2022, 2, 12)
      end
    end
  end
end