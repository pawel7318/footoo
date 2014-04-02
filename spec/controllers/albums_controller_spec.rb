require 'spec_helper'

describe AlbumsController do

  let(:album) { create(:album) }


  describe "GET #index" do
    before do 
      album.save
      get :index
    end
    it { expect(assigns(:albums)).to match_array([album]) }
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
    before do
      @attr = attributes_for(:album)
      post :create, album: @attr
    end
    it { expect(Album.exists?(@attr)).to be_true }
    it { expect(response).to redirect_to(assigns[:album]) }    
  end

  describe "PATCH #update" do
    before do
      @album = create(:album)
      patch :update, id: @album, album: attributes_for(:album, name: 'Updated name')
      @album.reload
    end
    it { expect(Album.exists?(@album)).to be_true }
    it { expect(Album.where(name: 'Updated name')).to exist }
    it { expect(response).to redirect_to(@album) }    
  end

  describe "DELETE #destroy" do
    before { @album = create(:album) }
    it { expect{ delete :destroy, id: @album }.to change(Album, :count).by(-1) }
  end

end
