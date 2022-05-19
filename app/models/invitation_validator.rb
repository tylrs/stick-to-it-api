class InvitationValidator < ActiveModel::Validator
  def validate(record)
    if Invitation.where(habit_plan_id: record.habit_plan_id, status: "accepted").or(Invitation.where(habit_plan_id: record.habit_plan_id, status: "pending")).exists?
      record.errors.add :habit_plan_limit, "Can only have one pending or accepted invitation per habit plan"
    end
  end
end 