module HabitPlansCreationService
  def self.create_partner_plans(habit_plan_id, recipient_id)
    sender_habit_plan = HabitPlan.find habit_plan_id
    recipient_habit_plan = HabitPlan.create(sender_habit_plan.attributes.merge(id: nil, user_id: recipient_id))
    HabitLogsCreationService.create_initial_logs(recipient_habit_plan)
  end
end
