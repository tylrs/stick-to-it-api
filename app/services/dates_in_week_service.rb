module DatesInWeekService 
  def self.get_week_start(week_type)
    case week_type
    when HabitLogsCreationService::WEEK_TYPES[:current]
      Date.today.beginning_of_week(:sunday)
    when HabitLogsCreationService::WEEK_TYPES[:next]
      Date.today.next_occurring(:sunday)
    end
  end

  def self.get_week_end(week_type)
    case week_type
    when HabitLogsCreationService::WEEK_TYPES[:current]
      Date.today.end_of_week(:sunday)
    when HabitLogsCreationService::WEEK_TYPES[:next]
      Date.today.next_occurring(:sunday).end_of_week(:sunday)
    end
  end
end
