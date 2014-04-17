def create_album(name)
	visit new_album_path
	fill_in 'Name', with: name
	click_button "Create Album"
end

def has_flash_error
  expect(flash[:notice]).to be_nil    
  expect(flash[:error]).to_not be_nil
end

def has_flash_notice
  expect(flash[:notice]).to_not be_nil    
  expect(flash[:error]).to be_nil
end
