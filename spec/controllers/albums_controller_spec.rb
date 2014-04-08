require 'spec_helper'

describe AlbumsController do

  let(:album) { create(:album) }

  shared_examples "flash_notice" do
    it { expect(flash[:notice]).to_not be_nil }    
    it { expect(flash[:error]).to be_nil }    
  end

  shared_examples "flash_error" do
    it { expect(flash[:notice]).to be_nil }    
    it { expect(flash[:error]).to_not be_nil }    
  end


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
    before { @attr = attributes_for(:album) }
    

    let (:send_post) { post :create, album: @attr }

    context "success" do
      it { expect{ send_post }.to change(Album, :count).by(1) }
      
      context do
        before do
          send_post
        end
        it { expect(response).to redirect_to(assigns[:album]) }   
        it_behaves_like "flash_notice"
      end
    end

    context "failure" do
      before do
        Album.any_instance.stub(:save).and_return(false)
      end

      it { expect{ send_post }.to_not change(Album, :count) }
      context do

        before do
          send_post
        end
        it { expect(response).to render_template :new }
        it_behaves_like "flash_error"
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

      it { expect{ send_patch}.to change(@album, :name).from('foo').to('bar') }

      context do
        before { send_patch }
         it { expect(response).to redirect_to @album }
         it_behaves_like "flash_notice"
      end
    end

    context "failure" do
      before do
        Album.any_instance.stub(:update).and_return(false)
      end

      it { expect{ send_patch }.to_not change(@album, :name) }
      context do
        before { send_patch }
        it { expect(response).to render_template :edit }
        it_behaves_like "flash_error"
      end
    end
  end

  describe "DELETE #destroy" do

    before { @album = create(:album) }
    
    let(:send_delete) { delete :destroy, id: @album }


    context "success" do

      it { expect{ send_delete }.to change(Album, :count).by(-1) }

      context do
        before { send_delete }
        it { expect{ send_delete }.to redirect_to albums_url }
        it_behaves_like "flash_notice"      
      end
    end

    context "failure" do
      before do
        Album.any_instance.stub(:destroy).and_return(false)
      end
      it { expect{ send_delete }.to_not change(Album, :count) }

      context do
        before do
          send_delete
        end
        it_behaves_like "flash_error"
      end
    end
  end
end
