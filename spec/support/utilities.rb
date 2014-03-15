def create_album(name)
	visit new_album_path
	fill_in 'Name', with: name
	click_button "Create Album"
end

def create_album_by_factory(name)
	FactoryGirl.create(:album, name: name)
end

def create_slide(album)
	FactoryGirl.create(:slide, album: album)
end
