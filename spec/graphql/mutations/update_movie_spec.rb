require 'rails_helper'

RSpec.describe Mutations::UpdateMovie, type: :request do
  before(:each) do
    @user = create(:user)
    @movie = create(:movie)
    @params = attributes_for(:movie)  # Generate a hash of attributes for a movie
  end

  def perform(id:, args:, current_user:)
    Mutations::UpdateMovie.new(object: nil, field: nil, context: { current_user: current_user }).resolve(id: id, **args)
  end

  it "should update a movie successfully" do
    result = perform(id: @movie.id, args: @params, current_user: @user)

    expect(result[:movie].title).to eq @params[:title]
    expect(result[:movie].plot).to eq @params[:plot]
  end

  it "should not update a movie with invalid title" do
    @params[:title] = 'Te'
    result = perform(id: @movie.id, args: @params, current_user: @user)
    expect(result[:errors]).to include('The title must be at least 3 characters')
  end

  it "should not update a movie with invalid plot" do
    @params[:plot] = 'Te'
    result = perform(id: @movie.id, args: @params, current_user: @user)
    expect(result[:errors]).to include('The plot must be at least 10 characters')
  end

  it 'should not update a movie with invalid synopsis' do
    @params[:synopsis] = 'Te'
    result = perform(id: @movie.id, args: @params, current_user: @user)
    expect(result[:errors]).to include('The synopsis must be at least 10 characters')
  end

  it 'should not update a movie with invalid actors' do
    @params[:actors] = []
    result = perform(id: @movie.id, args: @params, current_user: @user)
    expect(result[:errors]).to include('The actors must be at least 1 character')
  end

  it 'should not update a movie with invalid release year' do
    @params[:release_year] = 1799
    result = perform(id: @movie.id, args: @params, current_user: @user)
    expect(result[:errors]).to include('The release year must be at least 1800')
  end

  it 'should not update a movie with invalid director' do
    @params[:director] = 'Te'
    result = perform(id: @movie.id, args: @params, current_user: @user)
    expect(result[:errors]).to include('The director must be at least 3 characters')
  end
end
