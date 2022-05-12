class HabitPlanInviterMailer < ApplicationMailer
  def plan_invite_email(invite_info)
    @recipient_name = invite_info[:recipient_name]
    @user_name = invite_info[:user].name
    @habit_name = invite_info[:habit_plan].habit.name
    @start_date = invite_info[:habit_plan].start_datetime
    @end_date = invite_info[:habit_plan].end_datetime

    if User.find_by email: invite_info[:recipient_email]
      @invitation_link = "http://stick-to-it-ui.herokuapp.com/login"
      @action_type = "log in"
    else
      @invitation_link = "http://stick-to-it-ui.herokuapp.com/create-account"
      @action_type = "create an account"
    end
    
    mail(
      reply_to: invite_info[:user].email,
      to: invite_info[:recipient_email],
      subject: "#{invite_info[:user].name} wants you to join their habit: #{invite_info[:habit_plan].habit.name}"
    )
  end
end
