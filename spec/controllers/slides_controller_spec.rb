require 'spec_helper'
require 'rack/test'

describe SlidesController do

  let(:album) { create(:album) }
  let(:slide) { build(:slide) }
  let(:valid_attributes) { attributes_for(:slide) }

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
      it { expect { send_post }.to change(Slide, :count).by(1) } 
      context do
        before { send_post }
        it { expect(response).to redirect_to album_slides_url }
        it { expect(flash[:notice]).to_not be_nil }
      end
    end

    context "failure" do
      before do
        @album = album
        Slide.any_instance.stub(:save).and_return(false)
      end
      
      it { expect{ send_post }.to_not change(Slide, :count) }
      context do
        before { send_post }
        it { expect(response).to redirect_to album_slides_url }
        it { expect(flash[:error]).to_not be_nil }
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
      it { expect{ send_patch}.to change(@slide, :description).from('foo').to('bar') }

      context do
        before { send_patch }
        it { expect(response).to redirect_to album_slides_url(@slide.album_id) }
        it { expect(flash[:notice]).to_not be_nil }
      end
    end

    context "failure" do
      before do
        Slide.any_instance.stub(:update).and_return(false)
      end

      it { expect{ send_patch }.to_not change(@slide, :description) }
      context do
        before { send_patch }
        it { expect(response).to render_template :edit }
        it { expect(flash[:error]).to_not be_nil }
      end
    end

  end

  describe "old DELETE #destroy" do
    before do
      @slide = create(:slide)
      expect(Slide.exists?(@slide)).to be_true
    end
    it do
      delete :destroy, id: @slide
      expect(Slide.exists?(@slide)).to be_false
    end
  end

  describe "DELETE #destroy" do
    before do
      @slide = create(:slide)
    end

    let(:send_delete) { delete :destroy, id: @slide }

    context "success" do
      it { expect{ send_delete }.to change(Slide, :count).by(-1) }

      context do
        before { send_delete }
        it { expect(response).to redirect_to album_slides_url(@slide.album_id) }
        it { expect(flash[:notice]).to_not be_nil }
      end
    end

    context "failure" do
      before do
        Slide.any_instance.stub(:destroy).and_return(false)
      end
      it { expect{ send_delete }.to_not change(Slide, :count) }

      context do
        before { send_delete }
        it { expect(flash[:error]).to_not be_nil }
      end
    end
  end
end
