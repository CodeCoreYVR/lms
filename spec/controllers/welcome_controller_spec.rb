require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  describe "#home" do
    it "renders the home page" do
      get :home
      expect(response).to render_template(:home)
    end
  end
end
