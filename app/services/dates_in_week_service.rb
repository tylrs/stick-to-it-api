module DatesInWeekService 
  def self.get_week_start(week_type)
    case week_type
    when "current_week"
      Date.today.beginning_of_week(:sunday)
    when "next_week"
      Date.today.next_occurring(:sunday)
    end
    # week_start = Date.today.beginning_of_week(:sunday)
    # week_end = Date.today.end_of_week(:sunday)
    # week_start = Date.today.next_occurring(:sunday)
    # week_end = week_start.end_of_week(:sunday)
  end
end