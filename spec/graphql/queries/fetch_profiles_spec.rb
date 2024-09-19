require 'rails_helper'

RSpec.describe Queries::FetchProfiles, type: :request do
  before(:each) do
    @user = create(:user)
    @profiles = 10.times.map { create(:profile, user: @user) }
  end

  def perfom(current_user = nil)
    Queries::FetchProfiles.new(field: nil, object: nil, context: {current_user: current_user}).resolve
  end

  it "should return all profiles" do
    result = perfom(@user)

    expect(result).to eq(@profiles)
    expect(result.count).to eq(10)
  end

  it "should return an error if the user is not authenticated" do
    expect { perfom }.to raise_error(GraphQL::ExecutionError, "not authorized")
  end
end
