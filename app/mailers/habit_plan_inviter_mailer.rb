class HabitPlanInviterMailer < ApplicationMailer
  def plan_invite_email(user, habit_plan, friend_email)
    mail(
      reply_to: user.email,
      to: friend_email,
      subject: "#{user.name} wants you to join their habit: #{habit_plan.habit.name}"
    )
  end
end
