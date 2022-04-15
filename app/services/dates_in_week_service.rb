module DatesInWeekService 
  def self.get_week_start(week_type)
    case week_type
    when "current_week"
      Date.today.beginning_of_week(:sunday)
    when "next_week"
      Date.today.next_occurring(:sunday)
    end
  end

  def self.get_week_end(week_type)
    case week_type
    when "current_week"
      Date.today.end_of_week(:sunday)
    when "next_week"
      Date.today.next_occurring(:sunday).end_of_week(:sunday)
    end
  end
end