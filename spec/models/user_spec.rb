require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) {FactoryGirl.create(:user)}

  describe "validations" do
    it "requires a first name" do
      u = User.new(first_name: nil)
      u.valid?
      expect(u.errors).to have_key(:first_name)
    end
    it "requires an email" do
      u = User.new(email: nil)
      u.valid?
      expect(u.errors).to have_key(:email)
    end
    it "requires a password" do
      u = User.new(password: nil)
      u.valid?
      expect(u.errors).to have_key(:password)
    end
    it "requires a password with at least 5 characters" do
      u = User.new(password: "1234")
      u.valid?
      expect(u.errors).to have_key(:password)
    end
    it "requires a unique email" do
      u1 = User.new(email: user.email)
      u1.valid?
      expect(u1.errors).to have_key(:email)
    end
    it "requires a valid email address" do
      # To check email validation regex
      ["",
      "bad",
      "bad@",
      "bad@@",
      "@bad",
      "@bad.com",
      "@@bad.com",
      "bad@@example.com",
      "bad@example",
      "bad@example..com",
      "bad@.com"].each do |bad_address|
        expect(FactoryGirl.build(:user, email: bad_address)).to be_invalid
      end
    end
  end

  describe ".full_name" do
    it "concatenates the first name and last name" do
      # user = FactoryGirl.build(:user, first_name: "Rahul", last_name: "Mc Laughlin")
      expect(user.full_name).to eq("#{user.first_name} #{user.last_name}")
    end
    it "returns the first name if the last name is missing" do
      u = FactoryGirl.build(:user, last_name: nil)
      expect(u.full_name).to eq(u.first_name)
    end
  end

  describe "password generating" do
    it "generates a password digest on creation" do
      u = FactoryGirl.create(:user)
      expect(u.password_digest).to be
    end
  end

  describe ".send_password_reset" do
    it "generates a new password_reset_token" do
      expect{user.send_password_reset}.to change(user, :password_reset_token)
    end
    it "updates password_reset_sent_at with the current datetime" do
      user.send_password_reset # password_reset_sent_at is `nil` for new users
      last_reset = user.password_reset_sent_at
      user.send_password_reset
      expect(user.password_reset_sent_at).to be >=(last_reset)
    end
    it "sends a password reset email to the user" do
      expect{user.send_password_reset}.to change{ActionMailer::Base.deliveries.count}.by(1)
    end
  end
end
