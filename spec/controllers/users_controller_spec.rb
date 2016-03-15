require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) {FactoryGirl.create(:user)}

  describe "#new" do
    it "renders new template" do
      get :new
      expect(response).to render_template(:new)
    end
    it "instatiates a user object and sets it to @user instance variable" do
      get :new
      expect(assigns[:user]).to be_a_new(User)
    end
  end

  describe "#create" do
    context "with valid attributes" do
      def valid_user
        post :create, user: FactoryGirl.attributes_for(:user)
      end
      it "creates a record in the database" do
        expect{valid_user}.to change{User.count}.by(1)
      end
      it "redirects to the user show page" do
        valid_user
        expect(response).to redirect_to(user_path(User.last.id))
      end
      it "sets a flash notice message" do
        valid_user
        expect(flash[:notice]).to be
      end
      it "sets the session[:user_id] to user id" do
        valid_user
        expect(session[:user_id]).to eq(User.last.id)
      end
    end
    context "with invalid attributes" do
      def invalid_user
        post :create, user: FactoryGirl.attributes_for(:user, {first_name: nil})
      end
      it "does not create a record in the database" do
        expect{invalid_user}.to change{User.count}.by(0)
      end
      it "renders the new template" do
        invalid_user
        expect(response).to render_template(:new)
      end
      it "sets a flash alert messages" do
        invalid_user
        expect(flash[:alert]).to be
      end
    end
  end

end
