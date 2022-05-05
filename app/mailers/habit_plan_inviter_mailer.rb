class HabitPlanInviterMailer < ApplicationMailer
  def plan_invite_email(user, habit_plan, recipient_info)
    @recipient_name = recipient_info[:name]
    @user_name = user.name
    @habit_name = habit_plan.habit.name
    @start_date = habit_plan.start_datetime
    @end_date = habit_plan.end_datetime
    mail(
      reply_to: user.email,
      to: recipient_info[:email],
      subject: "#{user.name} wants you to join their habit: #{habit_plan.habit.name}"
    )
  end
end
