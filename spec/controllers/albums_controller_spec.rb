require 'spec_helper'

describe AlbumsController do

  let(:user) { create :user }
  let(:album) { create(:album) }

  around :each do |scenario|
    login_and_switch_schema user
    scenario.run
    destroy_users_schema user
    destroy_user user
  end

  describe "GET #index" do
    before do
      @album = album
      get :index
    end
    it { expect(assigns(:albums)).to match_array([@album]) }
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
    before { @attr = attributes_for(:album) }
    
    let (:send_post) { post :create, album: @attr }

    context "success" do
      it do
        expect{ send_post }.to change(Album, :count).by(1)
        expect(response).to redirect_to(assigns[:album])
        has_flash_notice
      end
    end

    context "failure" do
      before do
        Album.any_instance.stub(:save).and_return(false)
      end

      it do
        expect{send_post}.to_not change(Album, :count)        
        expect(response).to render_template :new
        has_flash_error
      end
    end
  end

  describe "PATCH #update" do
    before { @album = create(:album, name: 'foo') }

    let(:send_patch) do
      patch :update, id: @album, album: attributes_for(:album, name: 'bar')
      @album.reload
    end

    context "success" do
      it do
        expect{send_patch}.to change(@album, :name).from('foo').to('bar')      
        expect(response).to redirect_to @album
        has_flash_notice
      end
    end

    context "failure" do
      before do
        Album.any_instance.stub(:update).and_return(false)
      end

      it do
        expect{send_patch}.to_not change(@album, :name)
        expect(response).to render_template :edit
        has_flash_error
      end      
    end
  end

  describe "DELETE #destroy" do

    before { @album = create(:album) }
    
    let(:send_delete) { delete :destroy, id: @album }

    context "success" do
      it do
        expect{ send_delete }.to change(Album, :count).by(-1)
        expect(response).to redirect_to albums_url
        has_flash_notice
      end
    end

    context "failure" do
      before do
        Album.any_instance.stub(:destroy).and_return(false)
      end
      
      it do
        expect{ send_delete }.to_not change(Album, :count)
        has_flash_error
      end
    end
  end
end
