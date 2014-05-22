require 'spec_helper'
require 'rack/test'

describe SlidesController do

  
  let(:album) { create :album }
  let(:slide) { build :slide }
  let(:valid_attributes) { attributes_for :slide }

  before(:all) do
    @user = create :user
  end

  after(:all) do
    destroy_users_schema @user
    destroy_user @user
  end

  before(:each) do      
    sign_in_and_switch_schema @user
  end

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
    before do
      slide.save
      get :show, id: slide
    end
    it { expect(assigns(:slide)).to eq Slide.last }
    it { expect(response).to render_template :show }
  end

  describe "POST #create" do
    let(:send_post) { post :create, album_id: album.id, slide: attributes_for(:slide_array) }
    
    context "success" do
      it do
        expect{send_post}.to change(Slide, :count).by(1)      
        expect(response).to redirect_to album_slides_url
        has_flash_notice
      end
    end

    context "failure" do
      before do
        @album = album
        Slide.any_instance.stub(:save).and_return(false)
      end
      
      it do
        expect{send_post}.to_not change(Slide, :count)      
        expect(response).to redirect_to album_slides_url
        has_flash_error
      end
    end    
  end

  describe "PATCH #update" do
    before { @slide = create(:slide, description: 'foo') }

    let(:send_patch) do
      patch :update, id: @slide, slide: { description: 'bar' }
      @slide.reload
    end

    context "success" do
      it do
        expect{send_patch}.to change(@slide, :description).from('foo').to('bar')    
        expect(response).to redirect_to album_slides_url(@slide.album_id)
        has_flash_notice
      end
    end

    context "failure" do
      before do
        Slide.any_instance.stub(:update).and_return(false)
      end

      it do
        expect{send_patch}.to_not change(@slide, :description)      
        expect(response).to render_template :edit
        has_flash_error
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      @slide1 = create(:slide)
      @slide2 = create(:slide)      
    end

    let(:send_delete) { delete :destroy, album_id: @slide1.album, ids: @ids }


    context do
      it "one of two" do
        @ids = []
        @ids << @slide1.id

        expect{send_delete}.to change(Slide, :count).by(-1)
        expect(flash[:error]).to be_nil
        expect(flash[:notice]).to_not be_nil
      end
    end

    context do
      it "two of two" do
        @ids = []
        @ids << @slide1.id
        @ids << @slide2.id  

        expect{send_delete}.to change(Slide, :count).by(-2)
        expect(flash[:error]).to be_nil
        expect(flash[:notice]).to_not be_nil      
      end
    end

    context do
      it "none" do
        @ids = []
        @ids << 7
        @ids << 8

        expect{send_delete}.to_not change(Slide, :count)
        expect(flash[:error]).to_not be_nil
        expect(flash[:notice]).to be_nil      
      end
    end

    context do
      it "some" do
        @ids = []
        @ids << 9
        @ids << @slide1.id

        expect{send_delete}.to change(Slide, :count).by(-1)
        expect(flash[:error]).to_not be_nil
        expect(flash[:notice]).to_not be_nil      
      end
    end
  end
end
