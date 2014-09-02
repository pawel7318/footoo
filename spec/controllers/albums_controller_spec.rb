require 'spec_helper'

describe AlbumsController, :type => :controller do

  let(:album) { create(:album) }

  before(:all) do
    @user = create :user
  end

  before(:each) do
    sign_in_and_switch_schema @user
  end

  after(:all) do
    destroy_users_schema @user
    destroy_user @user
  end

  # describe "dummy" do
  #   it { expect(1).to eq(1) }
  # end

  describe "GET #edit" do
    before { get :edit, id: album }
    it { expect(response).to render_template :edit }
  end

  describe "GET #new" do
    before { get :new }
    it { expect(response).to render_template :new }
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
        allow_any_instance_of(Album).to receive(:save).and_return(false)
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
        allow_any_instance_of(Album).to receive(:update).and_return(false)
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
        allow_any_instance_of(Album).to receive(:destroy).and_return(false)
      end
      
      it do
        expect{ send_delete }.to_not change(Album, :count)
        has_flash_error
      end
    end
  end
end
