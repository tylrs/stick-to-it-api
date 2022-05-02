module Api
  module V2
    class HabitPlansController < ApplicationController
      def show_week
        week_habit_plans = HabitPlansFilterService.get_week_and_partner_plans(params[:user_id])
        render json: week_habit_plans,
               include: [habit: { only: %i[creator_id name
                                           description] }, user: { only: [:name] }, habit_logs: { only: %i[id habit_id scheduled_at
                                                                                                           completed_at] }], 
               status: :ok
      end

      def show_today
        today_habit_plans = HabitPlansFilterService.get_today_and_partner_plans(params[:user_id])
        render json: today_habit_plans,
               include: [habit: { only: %i[creator_id name
                                           description] }, user: { only: [:name] }, habit_logs: { only: %i[id habit_id scheduled_at
                                                                                                           completed_at] }], 
               status: :ok
      end

      def destroy
        user = User.find params[:user_id]
        user.habit_plans.destroy(params[:id])
      end
    end
  end
end
