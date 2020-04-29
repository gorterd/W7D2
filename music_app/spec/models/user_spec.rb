require 'rails_helper'

RSpec.describe User, type: :model do
  
  describe "validations" do
    it {should validate_presence_of(:email)}
    it {should validate_presence_of(:password_digest)}
    it {should validate_length_of(:password).is_at_least(8)}
  end

  describe "methods" do
    subject(:user) { User.create!(email: 'email@email.com', password: 'ilovecats') }
    
    describe "#is_password?" do
      it "should return true if password matches" do
        expect(user.is_password?('ilovecats')).to be true
      end
      it "should return false if password doesn't match" do
        expect(user.is_password?('ilovedogs')).not_to be true
      end
    end
  
    describe "#reset_session_token!" do
      it "should call generate_session_token" do
        expect(user).to receive(:generate_session_token)
        user.reset_session_token!
      end

      it "should save user to database" do
        expect(user).to receive(:save!)
        user.reset_session_token!
      end

      it "should return new session token" do
        return_val = user.reset_session_token!
        expect(user.session_token).to eq(return_val)
      end

    end

    describe "::find_by_credentials" do
      it "should return user with matching email and password" do
        user
        expect(User.find_by_credentials("email@email.com", "ilovecats")).to eq(user)
      end
      
      it "should return nil if no matching email and password" do
        user
        expect(User.find_by_credentials("email@email.com", "ilovedogs")).not_to eq(user)
      end
    end
    
  end
end
