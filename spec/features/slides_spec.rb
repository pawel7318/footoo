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
    visit album_slides_path slide.album
    expect{page.find('.btn.btn-mini.btn-danger').click}.to change(Slide, :count).by(-1)
  end

  scenario "Delete selected slide (one)", js: true, resynchronize: true do
    @to_delete = []
    @to_leave = []

    @album = album

    @to_leave << create(:slide, album: @album)
    @to_delete << create(:slide, album: @album)
    @to_leave << create(:slide, album: @album)

    visit album_slides_path @album

    visit album_slides_path @album
    expect{
      remove_slides_from_page(@to_delete, @to_leave) { click_button("Delete selected") }
    }.to change(Slide, :count).by(@to_delete.length*(-1))
  end

  scenario "Delete selected slides (many)", js: true do
    @to_delete = []
    @to_leave = []

    @album = album

    @to_delete << create(:slide, album: @album)
    @to_leave << create(:slide, album: @album)
    @to_delete << create(:slide, album: @album)

    visit album_slides_path @album
    expect{
      remove_slides_from_page(@to_delete, @to_leave) { click_button("Delete selected") }
    }.to change(Slide, :count).by(@to_delete.length*(-1))
  end

  scenario "Show slide"

  scenario "Move selected slide (one)", js: true do
    @to_move = []
    @to_leave = []

    @album1 = create(:album)
    @album2 = create(:album)
    @album3 = create(:album)
    @album4 = create(:album)


    @to_leave << create(:slide, album: @album2)
    @to_move << create(:slide, album: @album2)
    @to_leave << create(:slide, album: @album2)

    visit album_slides_path @album2

    expect{
      remove_slides_from_page(@to_move, @to_leave) {
        click_button("Move selected")
        select @album3.name, from: "new_album_id"    
        click_button("Move")
      }
    }.to change{@to_move.map { |slide| Slide.find(slide.id).album_id }}.from([@album2.id]*@to_move.count).to([@album3.id]*@to_move.count)
  end

  scenario "Move selected slides (many)", js: true do
    @to_move = []
    @to_leave = []

    @album1 = create(:album)
    @album2 = create(:album)
    @album3 = create(:album)
    @album4 = create(:album)

    @to_move << create(:slide, album: @album2)
    @to_leave << create(:slide, album: @album2)
    @to_move << create(:slide, album: @album2)

    visit album_slides_path @album2

    expect{
      remove_slides_from_page(@to_move, @to_leave) {
        click_button("Move selected")
        select @album3.name, from: "new_album_id"    
        click_button("Move")
      }
    }.to change{@to_move.map { |slide| Slide.find(slide.id).album_id }}.from([@album2.id]*@to_move.count).to([@album3.id]*@to_move.count)
  end
end

