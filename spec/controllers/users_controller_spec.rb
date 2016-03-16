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

  describe "#show" do
    before do
      login(user)
    end
    it "finds the user by id and sets it to @user variable" do
      get :show, id: user.id
      expect(assigns(:user)).to eq(user)
    end
    it "renders the show template" do
      get :show, id: user.id
      expect(response).to render_template(:show)
    end
    it "raises an error if the id passed doesn't match a record in the db" do
      expect { get :show, id: 93024893028}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "#edit" do
    before do
      login(user)
      get :edit, id: user.id
    end
    it "renders the edit template" do
      expect(response).to render_template(:edit)
    end
    it "finds user by id and sets it to @user instance variable" do
      expect(assigns(:user)).to eq(user)
    end
  end

  describe "#update" do
    before { login(user) }
    context "with valid attributes" do
      before do
        patch :update, id: user.id, user: {first_name: "Johnny"}
      end
      it "updates the record with new parameters" do
        expect(user.reload.first_name).to eq("Johnny")
      end
      it "redirects to the show page" do
        expect(response).to redirect_to(user_path(user))
      end
      it "sets a flash notice message" do
        expect(flash[:notice]).to be
      end
    end

    context "with invalid attributes" do
      def invalid_request
        patch :update, id: user.id, user: {first_name: nil}
      end
      it "does not update the record" do
        first_name_before = user.first_name
        invalid_request
        first_name_after = user.first_name
        expect(first_name_before).to eq(first_name_after)
      end
      it "renders the edit template" do
        invalid_request
        expect(response).to render_template(:edit)
      end
      it "sets a flash alert message" do
        invalid_request
        expect(flash[:alert]).to be
      end
    end
  end
end
