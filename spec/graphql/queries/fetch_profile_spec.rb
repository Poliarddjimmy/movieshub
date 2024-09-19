require 'rails_helper'

RSpec.describe Queries::FetchProfile, type: :request do
  before(:each) do
    @user = create(:user)
    @profile = create(:profile, user: @user)
  end

  def perfom(args:, current_user:)
    Queries::FetchProfile.new(field: nil, object: nil, context: {current_user: current_user}).resolve(**args)
  end

  it "should return a profile" do
    result = perfom(
      args: { id: @profile.id },
      current_user: @user
    )

    expect(result).to eq(@profile)
  end

  it "should return an error if the user is not authenticated" do
    expect { perfom(args: { id: @profile.id }, current_user: nil) }.to raise_error(GraphQL::ExecutionError, "not authorized")
  end
end
