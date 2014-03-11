require 'spec_helper'


describe "Home page" do
	before { visit root_path }
	
	it { expect(page).to have_title('Footoo') }
	it { expect(page).to have_selector('h1', text: 'Albums') }
	it { expect(page).to have_selector('div.navbar') }
	
	it { expect(page).to have_link('New', href: new_album_path) }
end

describe "New Album page" do
	before { visit new_album_path }

	it { expect(page).to have_selector('h1', text: 'New Album') }

	let(:submit) { "Create Album" }
	describe "with invalid information" do
		it "should not create new album" do
			expect { click_button submit }.not_to change(Album, :count)
		end


	end

	describe "with valid information" do
		before do
			fill_in 'Name', with: 'Example album' 
		end
		it "should create new album" do
			expect { click_button submit }.to change(Album, :count).by(1)
		end

		describe "should redirect to the new album's page" do
			before do
				4.times { |n| FactoryGirl.create :album }
				click_button submit
			end
			it { expect(current_path).to eq album_path('5') }
		end
		
	end
end

describe "Album page" do
	let!(:album) { @album = FactoryGirl.create(:album) }

	before do
		visit album_path(@album)
	end

	it "has Album h1" do
		within 'h1' do
			expect(page).to have_content('Album')
			expect(page).to have_no_content('Albums')
		end
	end

	it { expect(page).to have_link('Back') }
	it { expect(page).to have_link('Edit') }
	it { expect(page).to have_link('Delete') }
	it { expect(page).to have_link('Add Slide') }

end

describe "New Slide page" do
	let!(:album) { @album = FactoryGirl.create(:album) }
	before do
		visit new_album_slide_path(@album)
	end

	it { expect(page).to have_selector('h1', text: 'New Slide') }

	
	let(:submit) { "Create Slide" }

	describe "with invalid information" do
		it "should not create new slide" do
			expect { click_button submit }.not_to change(Slide, :count)
		end
	end

	describe "with valid information" do
		before do
			fill_in 'Description', with: Faker::Name.name
		end
		it "should create new slide" do
			expect { FactoryGirl.create(:slide) }.to change(Slide, :count).by(1)
		end
	end

	

end
