# frozen_string_literal: true

describe "Acceptance::Assessment::GreenDealPlans" do
  include RSpecAssessorServiceMixin

  context "when unauthenticated" do
    it "returns status 401" do
      add_green_deal_plan "123-456",
                          "body",
                          [401],
                          false
    end
  end
end
