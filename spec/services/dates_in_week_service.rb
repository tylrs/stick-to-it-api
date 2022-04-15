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
        
      end
    end
  end

  describe ".get_week_end" do
    context "when week_type is current_week" do
      it "should return the next Saturday of the current week" do
        
      end
    end

    context "when week_type is next_week" do
      it "should return the next Saturday of next week" do
        
      end
    end
  end
end