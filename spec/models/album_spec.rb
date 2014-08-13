require 'spec_helper'

describe Album do
	let (:album) { Album.new }

	it "is valid with valid name" do
		album.name = 'Some name'		
		expect(album).to be_valid
	end

	it "is invalid without a name" do
		album.name = nil		
		expect(album).not_to be_valid
	end

	it "is invalid with a duplicate name" do
		
		Album.create(name: 'Some name')

		album.name = 'Some name'				
    album.valid?
    expect(album.errors[:name].size).to eq(1)
	end
end
