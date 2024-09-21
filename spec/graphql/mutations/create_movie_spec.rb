require 'rails_helper'

RSpec.describe Mutations::CreateMovie, type: :request do
  before(:each) do
    @user = create(:user)
    @params = build(:movie)
  end

  def perfom(args:, current_user:)
    Mutations::CreateMovie.new(object: nil, field: nil, context: { current_user: current_user }).resolve(**args)
  end

  it "should create a movie successfully" do
    result = perfom(args: @params.attributes, current_user: @user)
    expect(result[:movie].title).to eq @params.title
  end

  it "should not create a movie with invalid title" do
    @params.title = 'Te'
    result = perfom(args: @params.attributes, current_user: @user)
    expect(result[:errors]).to include('The title must be at least 3 characters')
  end

  it "should not create a movie with invalid plot" do
    @params.plot = 'Te'
    result = perfom(args: @params.attributes, current_user: @user)
    expect(result[:errors]).to include('The plot must be at least 10 characters')
  end

  it 'should not create a movie with invalid synopsis' do
    @params.synopsis = 'Te'
    result = perfom(args: @params.attributes, current_user: @user)
    expect(result[:errors]).to include('The synopsis must be at least 10 characters')
  end

  it 'should not create a movie with invalid actors' do
    @params.actors = []
    result = perfom(args: @params.attributes, current_user: @user)
    expect(result[:errors]).to include('The actors must be at least 1 character')
  end

  it 'should not create a movie with invalid release year' do
    @params.release_year = 1799
    result = perfom(args: @params.attributes, current_user: @user)
    expect(result[:errors]).to include('The release year must be at least 1800')
  end

  it 'should not create a movie with invalid director' do
    @params.director = 'Te'
    result = perfom(args: @params.attributes, current_user: @user)
    expect(result[:errors]).to include('The director must be at least 3 characters')
  end

  it 'should not create a movie with invalid language' do
    @params.language = ''
    result = perfom(args: @params.attributes, current_user: @user)
    expect(result[:errors]).to include('The language is Required')
  end
end
