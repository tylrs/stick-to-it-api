# Preview all emails at http://localhost:3000/rails/mailers/habit_plan_inviter
class HabitPlanInviterPreview < ActionMailer::Preview
  def plan_invite_email
    HabitPlanInviterMailer.plan_invite_email(User.first, HabitPlan.first, {name: "Bob", email: "bob.friend@example.com"})
  end
end
