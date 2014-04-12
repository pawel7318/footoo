require 'spec_helper'

feature "Album Pages" do

  given(:album) { create(:album) }

  scenario "Create new album" do
    visit new_album_path

    fill_in "Name", with: "foo"  
    expect {click_button "Create Album"}.to change(Album, :count).by(1)

  end

  scenario "Delete album" do
    visit album_path album
    
    expect {click_link "Delete"}.to change(Album, :count).by(-1)
  end

  scenario "Edit album" do
    
    visit edit_album_path album    
    fill_in "Name", with: "bar"
    
    expect{click_button "Update Album"}.to change(Album.last, :name)
  end

end
