require 'rails_helper'

RSpec.describe 'mechanics show page', type: :feature do

  it 'displays the name, years_experience and rides for mechanic' do
    john = Mechanic.create!(name: 'John', years_experience: 5)
    six_flags = AmusementPark.create!(name: 'Six Flags', admission_cost: 75)
    coaster = john.rides.create!(name: 'Coaster', thrill_rating: 5, open: true, amusement_park_id: six_flags.id)
    water_slide = john.rides.create!(name: 'Water Slide', thrill_rating: 3, open: true, amusement_park_id: six_flags.id)
    tower = john.rides.create!(name: 'Tower', thrill_rating: 1, open: true, amusement_park_id: six_flags.id)
    bungee = john.rides.create!(name: 'Bungee', thrill_rating: 5, open: false, amusement_park_id: six_flags.id)
    visit "/mechanics/#{john.id}"
    within "#mechanic_info" do
      expect(page).to have_content("John")
      expect(page).to have_content("5")
    end
    within "#rides" do
      expect(page.text.index("Coaster")).to be < page.text.index("Water Slide")
      expect(page.text.index("Water Slide")).to be < page.text.index("Tower")
      expect(page).to_not have_content("Bungee")
    end
  end

  it 'allows the user to add a ride to a mechanic' do
    john = Mechanic.create!(name: 'John', years_experience: 5)
    six_flags = AmusementPark.create!(name: 'Six Flags', admission_cost: 75)
    coaster = john.rides.create!(name: 'Coaster', thrill_rating: 5, open: true, amusement_park_id: six_flags.id)
    water_slide = john.rides.create!(name: 'Water Slide', thrill_rating: 3, open: true, amusement_park_id: six_flags.id)
    tower = john.rides.create!(name: 'Tower', thrill_rating: 1, open: true, amusement_park_id: six_flags.id)
    bungee = john.rides.create!(name: 'Bungee', thrill_rating: 5, open: false, amusement_park_id: six_flags.id)
    twister = six_flags.rides.create!(name: 'Twister', thrill_rating: 2, open: true)
    visit "/mechanics/#{john.id}"
    fill_in "ride_id", with: twister.id
    click_on "Submit"
    expect(current_path).to eq("/mechanics/#{john.id}")
    expect(page).to have_content("Twister")
  end
end
