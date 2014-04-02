require 'spec_helper'
require 'rack/test'

describe SlidesController do

  let(:album) { create(:album) }
  let(:slide) { build(:slide) }

  describe "GET #index" do
    before do
      slide.save
      get :index, album_id: slide.album
    end
    it { expect(assigns(:slides)).to match_array([slide]) }
    it { expect(response).to render_template :index }
  end

  describe "GET #new" do
    before { get :new, album_id: album.id }
    it { expect(response).to render_template :new }
  end

  describe "GET #edit" do
    before do
      slide.save
      get :edit, id: slide
    end
    it { expect(response).to render_template :edit }
  end

  describe "GET #show" do
    pending
  end

  describe "POST #create" do
    before { post :create, album_id: album.id, slide: attributes_for(:slide_array) }
    it { expect(response).to redirect_to(assigns[:album_slides]) }
  end

  describe "PATCH #update" do
    pending
  end

  describe "DELETE #destroy" do
    before do
      @slide = create(:slide)
      expect(Slide.exists?(@slide)).to be_true
    end
    it do
      delete :destroy, id: @slide
      expect(Slide.exists?(@slide)).to be_false
    end
  end
end

