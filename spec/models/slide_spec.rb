require 'spec_helper'

describe Slide, :type => :model do
  let (:slide) { build(:slide) }

  it "is valid with a photo" do
    slide.save
    expect(slide).to be_valid
  end

  it "is invalid without a photo" do
    @slide = build(:slide_without_photo)
    expect(@slide).to_not be_valid
  end
  
  it "is invalid with a duplicate photo fingerprint" do
    slide.save
    @slide = slide.dup
    @slide.valid?
    expect(@slide.errors[:photo_fingerprint].size).to eq(1)
  end

  # paranoid2 gem Trash implementation
  describe "after .destroy(force: false)" do
    before do
      @slide = slide
      slide.save
    end
    it "is invisible" do
      expect{@slide.destroy(force: false)}.to change(Slide, :count).by(-1)
    end
    it "visible if .only_deleted" do
      expect{@slide.destroy(force: false)}.to change(Slide.only_deleted, :count).by(1)
    end    
    it "visible if .with_deleted" do
      expect{@slide.destroy(force: false)}.to_not change(Slide.with_deleted, :count)
    end
  end

  describe "after .destroy(force: true)" do
    before do
      slide.save
      slide.destroy(force: false)
      @slide = Slide.with_deleted.find(slide.id)
    end
    it "is invisible" do
      expect{@slide.destroy(force: true)}.to_not change(Slide, :count)
    end
    it "visible if .only_deleted" do
      expect{@slide.destroy(force: true)}.to change(Slide.only_deleted, :count).by(-1)
    end
    it "visible if .with_deleted" do
      expect{@slide.destroy(force: true)}.to change(Slide.with_deleted, :count).by(-1)
    end
  end
end
