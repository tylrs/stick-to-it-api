require "rails_helper"

RSpec.describe HabitPlanInviterMailer, type: :mailer do
  describe ".plan_invite_email" do
    let(:invite_info) do
      {
        recipient_name: registered_user.name,
        recipient_email: registered_user.email,
        habit_plan: habit_plan,
        user: user
      }
    end
    let(:registered_user) { create(:user) }
    let(:email) { described_class.plan_invite_email(invite_info) }
    let(:habit_plan) { create(:habit_plan) }
    let(:user) { habit_plan.user }
    
    describe "headers" do
      it "has the correct sender" do
        expect(email.from).to eq ["tylr123tennis@aim.com"]
      end
      
      it "has the correct recipient" do
        expect(email.to).to eq [invite_info[:recipient_email].to_s]
      end

      it "has the correct reply-to" do
        expect(email.reply_to).to eq [user.email.to_s]
      end

      it "has the correct subject" do
        expect(email.subject).to eq "#{user.name} wants you to join their habit: #{habit_plan.habit.name}"
      end
    end

    context "when the recipient is already registered" do
      describe "body" do
        it "returns the correct plain text" do
          expect(email.text_part.body.to_s).to include("Hello #{invite_info[:recipient_name]}")
          expect(email.text_part.body.to_s).to include("#{user.name} would like you to join them on their new habit: #{habit_plan.habit.name}")
          expect(email.text_part.body.to_s).to include("They are planning on working on the habit from #{habit_plan.start_datetime} to #{habit_plan.end_datetime}")
          expect(email.text_part.body.to_s).to include("If you would like to view the invitation, please log in with the email address this message was sent to.")
          expect(email.text_part.body.to_s).to include("Go to log in screen: http://stick-to-it-ui.herokuapp.com/login")
        end
        
        it "returns the correct html" do
          expect(email.html_part.body.to_s).to include("Hello #{invite_info[:recipient_name]}")
          expect(email.html_part.body.to_s).to include("#{user.name} would like you to join them on their new habit: #{habit_plan.habit.name}")
          expect(email.html_part.body.to_s).to include("They are planning on working on the habit from #{habit_plan.start_datetime} to #{habit_plan.end_datetime}")
          expect(email.html_part.body.to_s).to include("If you would like to view the invitation, please log in with the email address this message was sent to.")
          expect(email.html_part.body.to_s).to include("Go to log in screen")
        end
      end
    end

    context "when the recipient is not registered" do
      let(:invite_info) do
        {
          recipient_name: "Bob",
          recipient_email: "Bob.friend@example.com",
          habit_plan: habit_plan,
          user: user
        }
      end

      describe "body" do
        it "returns the correct plain text" do
          expect(email.text_part.body.to_s).to include("Hello #{invite_info[:recipient_name]}")
          expect(email.text_part.body.to_s).to include("#{user.name} would like you to join them on their new habit: #{habit_plan.habit.name}")
          expect(email.text_part.body.to_s).to include("They are planning on working on the habit from #{habit_plan.start_datetime} to #{habit_plan.end_datetime}")
          expect(email.text_part.body.to_s).to include("If you would like to view the invitation, please create an account with the email address this message was sent to.")
          expect(email.text_part.body.to_s).to include("Go to create an account screen: http://stick-to-it-ui.herokuapp.com/create-account")
        end
        
        it "returns the correct html" do
          expect(email.html_part.body.to_s).to include("Hello #{invite_info[:recipient_name]}")
          expect(email.html_part.body.to_s).to include("#{user.name} would like you to join them on their new habit: #{habit_plan.habit.name}")
          expect(email.html_part.body.to_s).to include("They are planning on working on the habit from #{habit_plan.start_datetime} to #{habit_plan.end_datetime}")
          expect(email.html_part.body.to_s).to include("If you would like to view the invitation, please create an account with the email address this message was sent to.")
          expect(email.html_part.body.to_s).to include("Go to create an account screen")
        end
      end
    end

    it "can enqueue an email as a job" do
      expect { described_class.plan_invite_email(invite_info).deliver_later }.to have_enqueued_job
    end

    it "sends the email" do
      expect do
        described_class.plan_invite_email(invite_info).deliver_now
      end.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
