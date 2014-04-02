require 'spec_helper'

shared_examples_for "slide_form" do
	it { expect(page).to have_field('slide_description')}
	it { expect(page).to have_field('slide_photo')}
end

shared_examples_for "navbar" do
	it { expect(page).to have_selector('div.navbar') }
	it { expect(page).to have_link('Albums')}
	it { expect(page).to have_link('Trash')}
	it { expect(page).to have_link('About')}
end

describe "Home page" description
	before { visit root_path }

	it_behaves_like "navbar"
	
	it { expect(page).to have_title('Footoo') }
	it { expect(page).to have_selector('h1', text: 'Albums') }
	it { expect(page).to have_link('New', href: new_album_path) }
end

describe "New Album page" do
	before { visit new_album_path }

	it_behaves_like "navbar"

	it { expect(page).to have_selector('h1', text: 'New Album') }
	
	describe "with invalid data" do
		it { expect { create_album nil }.not_to change(Album, :count) }
	end

	describe "with valid data" do
		it { expect { create_album "Foo-Bar"}.to change(Album, :count).by(1) }

		describe "should redirect to the new album's page" do
			before do
				4.times { |n| FactoryGirl.create :album }
				create_album "one more"
			end
			it { expect(current_path).to eq album_path('5') }
		end
	end
end

describe "Album page" do
	let!(:album) { @album = FactoryGirl.create(:album) }

	before { visit album_path(@album) }

	it_behaves_like "navbar"

	it "has Album h1" do
		within 'h1' do
			expect(page).to have_content(@album.name)
			expect(page).to have_no_content('Albums')
		end
	end

	it { expect(page).to have_link('Back') }
	it { expect(page).to have_link('Edit') }
	it { expect(page).to have_link('Delete') }
	it { expect(page).to have_link('Add Slide') }
end

describe "New Slide page" do
	before do
		@album = create_album_by_factory("Sample Album")
		visit new_album_slide_path(@album)
	end

	it_behaves_like "navbar"
	it_behaves_like "slide_form"

	describe "with invalid data" do

		let (:submit) { "Create Slide" }
		it { expect { click_button submit }.not_to change(Slide, :count) }
		
	end

	describe "with valid data" do
		it { expect { create_slide(@album) }.to change(Slide, :count).by(1) }
	end
end


describe "Slides page" do
	before do
		@album = create_album_by_factory("Sample Album")
		@slide = create_slide(@album)

		visit album_slides_path(@album)
	end

	it_behaves_like "navbar"

	it { expect(page).to have_selector('h1', text: "slides")}
	it { expect(page).to have_content('Actions')}
	it { expect(page).to have_link('Edit', href: edit_slide_path(@slide))}
	it { expect(page).to have_link('Delete')}
=begin
	describe "edit" do
		before do
			visit edit_slide_path(@slide)			
		end

		it_behaves_like "slide_form"
		it { expect(page).to have_button('Update Slide')}

		describe "change description" do
			
			before { fill_in 'slide_description', with: 'ABC' }
			it do
				expect { click_button 'Update Slide' }.to change(Slide.first, :description)
			end
			after do
				pp Slide.first
				pp @slide
			end
		end
	end
=end
end
