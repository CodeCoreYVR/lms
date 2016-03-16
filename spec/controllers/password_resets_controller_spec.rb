require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do
  let(:user) {FactoryGirl.create(:user)}

  describe "#create" do
    before do
      post :create, user: FactoryGirl.attributes_for(:user)
    end
    it "redirects to root page " do
      expect(response).to redirect_to(root_path)
    end
  end

  describe "#edit" do
    before do
      user.generate_token(:password_reset_token)
      user.save
    end
    it "renders edit template" do
      # Simulate getting a password_reset_token
      # localhost:3000/password_resets/password_reset_token/edit
      get :edit, id: user.password_reset_token
      expect(response).to render_template(:edit)
    end
  end

  describe "#update" do
    before do
      user.generate_token(:password_reset_token)
      user.password_reset_sent_at = Time.zone.now
      user.save
    end
    it "finds the user by password_reset_token" do
      patch :update, id: user.password_reset_token, user: FactoryGirl.attributes_for(:user)
      expect(assigns[:user]).to eq(user)
    end
  end

end
