require 'spec_helper'

feature "Album Pages" do

  given(:user) { create(:user) }
  given(:album) { create(:album) }

  around :each do
    login_and_switch_schema user
  end

  scenario "Create new album with valid data" do
    visit new_album_path

    @album = build(:album)
    fill_in "Name", with: @album.name
    expect {click_button "Create Album"}.to change(Album, :count).by(1)  
  end

  scenario "Create new album with invalid data (failure expected)" do
    visit new_album_path

    @album = build(:invalid_album)
    fill_in "Name", with: @album.name
    expect {click_button "Create Album"}.to_not change(Album, :count)
    expect(page).to have_content("Name can't be blank")
  end

  scenario "Delete album" do
    @album = create(:album, user: @user)    
    visit album_path @album
    
    expect {click_link "Delete"}.to change(Album, :count).by(-1)
  end

  scenario "Update album with valid data" do
    visit edit_album_path album
    @album = build(:album)
    fill_in "Name", with: @album.name

    expect{click_button "Update Album"}.to change{Album.last.name}    
  end

  scenario "Update album with invalid data (failure expected)" do
    visit edit_album_path album
    @album = build(:invalid_album)
    fill_in "Name", with: @album.name

    expect{click_button "Update Album"}.to_not change{Album.last.name}
    expect(page).to have_content("Name can't be blank")
  end

end

