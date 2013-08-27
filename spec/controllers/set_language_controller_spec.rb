require 'spec_helper'

describe SetLanguageController do

  describe "GET 'english'" do
    it "returns http success" do
      get 'english'
      response.should be_success
    end
  end

  describe "GET 'hebrew'" do
    it "returns http success" do
      get 'hebrew'
      response.should be_success
    end
  end

end
