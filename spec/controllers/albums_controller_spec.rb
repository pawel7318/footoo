require 'spec_helper'

describe AlbumsController do

  let(:album) { create(:album) }


  describe "GET #index" do
    before { get :index }
    it { expect(response).to render_template :index }
  end

  describe "GET #new" do
    before { get :new }
    it { expect(response).to render_template :new }
  end

  describe "GET #edit" do
    before { get :edit, id: album }
    it { expect(response).to render_template :edit }
  end

  describe "POST #create" do
    before { post :create, album: attributes_for(:album) }
    it { expect(response).to redirect_to(assigns[:album])}
  end

  describe "PATCH #update" do
    before { @album = create(:album) }
    it do
      patch :update, id: @album, album: attributes_for(:album, name: 'Updated name')
      @album.reload
      expect(response).to redirect_to(@album)
    end
  end

  describe "DELETE #destroy" do
    before do
      @album = create(:album)
      expect(Album.exists?(@album)).to be_true
    end
    it do
      delete :destroy, id: @album
      expect(Album.exists?(@album)).to be_false
    end
  end

end
