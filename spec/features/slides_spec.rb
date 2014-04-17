require 'spec_helper'

feature "Slide Pages" do

  given(:album) { create :album }
  given(:slide) { create :slide }

  scenario "Create one slide" do
    visit new_album_slide_path album

    attach_file 'slide_photo', "#{Rails.root}/spec/fixtures/sample_1.jpg"
    expect{click_button "Create Slide"}.to change(Slide, :count).by(1)
  end

  scenario "Create multiple slides" do
    visit new_album_slide_path album

    attach_file 'slide_photo', [ "#{Rails.root}/spec/fixtures/sample_1.jpg", "#{Rails.root}/spec/fixtures/sample_2.jpg" ]    
    expect{click_button "Create Slide"}.to change(Slide, :count).by(2)
  end

  scenario "Create same slide twice (failure expected)" do
    visit new_album_slide_path album
    attach_file 'slide_photo', "#{Rails.root}/spec/fixtures/sample_1.jpg"
    click_button "Create Slide"

    visit new_album_slide_path album
    expect {
      attach_file 'slide_photo', "#{Rails.root}/spec/fixtures/sample_1.jpg"
      click_button "Create Slide"
      }.to_not change(Slide, :count)
  end

  scenario "Create same slide twice in two different albums (failure expected)" do

   visit new_album_slide_path album
   attach_file 'slide_photo', "#{Rails.root}/spec/fixtures/sample_1.jpg"
   click_button "Create Slide"

   visit new_album_slide_path create(:album)
   expect {
    attach_file 'slide_photo', "#{Rails.root}/spec/fixtures/sample_1.jpg"
    click_button "Create Slide"
    }.to_not change(Slide, :count)
  end

  scenario "Create slide without a photo (failure expected)" do
    visit new_album_slide_path album
    expect{click_button "Create Slide"}.to_not change(Slide, :count)    
  end

  scenario "Create slide with invalid file contents (failure expected)" do
    visit new_album_slide_path album

    attach_file 'slide_photo', "#{Rails.root}/spec/fixtures/fake.jpg"
    expect{click_button "Create Slide"}.to_not change(Slide, :count)
    expect(page).to have_content "Photo has an extension that does not match its contents"
  end

  scenario "Create slide with unsuported file type (failure expected)" do
    visit new_album_slide_path album

    attach_file 'slide_photo', "#{Rails.root}/spec/fixtures/test_file.txt"
    expect{click_button "Create Slide"}.to_not change(Slide, :count)
    expect(page).to have_content "Photo content type is invalid"
  end
  
  scenario "Update slide's description" do
    visit edit_slide_path slide
    @slide = build(:slide)
    fill_in "Description", with: @slide.description

    expect{click_button "Update Slide"}.to change{Slide.last.description}
  end

  scenario "Delete slide" do
    visit album_slides_url slide.album
    expect{page.find('.btn.btn-mini.btn-danger').click}.to change(Slide, :count).by(-1)
  end

  scenario "Delete selected slide (one)" do
    @album = album
    @slide1 = create(:slide, album: @album)
    @slide2 = create(:slide, album: @album)

    visit album_slides_url @album
    
    page.check("slide_select_#{@slide1.id}")
    expect{click_button('Delete selected')}.to change(Slide, :count).by(-1)
  end

  scenario "Delete selected slides (many)" do
    @album = album
    @slide1 = create(:slide, album: @album)
    @slide2 = create(:slide, album: @album)

    visit album_slides_url @album
    
    page.check("slide_select_#{@slide1.id}")
    page.check("slide_select_#{@slide2.id}")
    expect{click_button('Delete selected')}.to change(Slide, :count).by(-2)
  end

  scenario "Show slide"

end
