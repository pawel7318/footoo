require 'spec_helper'

describe TrashController do

  let(:album) { create(:album) }
  let(:slide) { build(:slide) }

  describe "GET #index" do
    before do
      slide.save
      slide.destroy
      get :index
    end
    it { expect(assigns(:trashed_slides)).to match_array([slide])}
    it { expect(response).to render_template :index }
  end

  describe "GET #show" do

    before do
      slide.save
      slide.destroy

      get :show, id: slide.id
    end
    it { expect(assigns(:trashed_slide)).to eq Slide.only_deleted.last } 
    it { expect(response).to render_template :show }
  end

  describe "DELETE #destroy" do
    before do
      slide.save
      slide.delete
    end

    let(:delete_it) {delete :destroy, id: slide.id}
    
    context "success" do

      it { expect{delete_it}.to_not change(Slide, :count) }
      it { expect{delete_it}.to change(Slide.only_deleted, :count).by(-1) }    
      it { expect{delete_it}.to change(Slide.with_deleted, :count).by(-1) }    

      context do
        before { delete_it }
        it {expect(response).to redirect_to(trash_index_url) }
        it {expect(flash[:notice]).to_not be_nil}
      end
    end

    context "failure" do
      before do
        Slide.any_instance.stub(:destroy).with({:force=>true}).and_return(false)
      end

      it { expect{delete_it}.to_not change(Slide, :count) }
      it { expect{delete_it}.to_not change(Slide.only_deleted, :count) }    
      it { expect{delete_it}.to_not change(Slide.with_deleted, :count) }    

      context do
        before { delete_it }
        it {expect(response).to redirect_to(trash_index_url) }
        it {expect(flash[:error]).to_not be_nil}
      end
    end
  end

  describe "DELETE #destroy_all" do
    before do
      @slide1 = create(:slide)
      @slide1.save
      @slide2 = create(:slide, album: @slide1.album) # create another slide for the same album
      @slide2.save

      @slide1.delete
      @slide2.delete
    end

    let(:delete_all) {delete :destroy_all}

    context "success" do

      it { expect{delete_all}.to_not change(Slide, :count) }
      it { expect{delete_all}.to change(Slide.only_deleted, :count).by(-2) }
      it { expect{delete_all}.to change(Slide.with_deleted, :count).by(-2) }

      context do
        before { delete_all }
        it { expect(response).to redirect_to root_path }
        it { expect(flash[:notice]).to_not be_nil }
      end
    end

    context "failure" do
      before do
        Slide.only_deleted.any_instance.stub(:destroy).and_return(false)
      end

      it { expect{delete_all}.to_not change(Slide, :count) }
      it { expect{delete_all}.to_not change(Slide.only_deleted, :count) }
      it { expect{delete_all}.to_not change(Slide.with_deleted, :count) }

      pending "destroy_all! returns no false ?" do
        context do
          before { delete_all }
          it { expect(response).to redirect_to trash_index_url }
          it { expect(flash[:error]).to_not be_nil }
        end
      end
    end
  end

  describe "PATCH #restore" do
    before do
      slide.save
      slide.delete
    end

    let(:restore_it) {patch :restore, id: slide.id}

    context "success" do

      it { expect{restore_it}.to change(Slide, :count).by(1) }
      it { expect{restore_it}.to change(Slide.only_deleted, :count).by(-1) } 
      it { expect{restore_it}.to_not change(Slide.with_deleted, :count) }

      context do
        before { restore_it }
        it { expect(response).to redirect_to(trash_index_url) }
        it { expect(flash[:notice]).to_not be_nil }
      end

    end

    context "failure" do
      before do
        Slide.any_instance.stub(:restore).and_return(false)
      end

      it { expect{restore_it}.to_not change(Slide, :count) }
      it { expect{restore_it}.to_not change(Slide.only_deleted, :count) } 
      it { expect{restore_it}.to_not change(Slide.with_deleted, :count) }

      context do
        before { restore_it}
        it { expect(response).to redirect_to(trash_index_url) }
        it { expect(flash[:error]).to_not be_nil }
      end

    end
  end

  describe "PATCH #restore_all" do
    before do
      @slide1 = create(:slide)
      @slide1.save
      @slide2 = create(:slide, album: @slide1.album) # create another slide for the same album
      @slide2.save

      @slide1.delete
      @slide2.delete
    end

    let(:restore_all) {patch :restore_all}

    context "success" do
      it { expect{restore_all}.to change(Slide, :count).by(2) }
      it { expect{restore_all}.to change(Slide.only_deleted, :count).by(-2) }
      it { expect{restore_all}.to_not change(Slide.with_deleted, :count) }

      context do
        before { restore_all }
        it { expect(response).to redirect_to root_path }
        it { expect(flash[:notice]).to_not be_nil }
      end  
    end

    context "failure" do
      before do
        Slide.any_instance.stub(:restore).and_return(false)
      end

      it { expect{restore_all}.to_not change(Slide, :count) }
      it { expect{restore_all}.to_not change(Slide.only_deleted, :count) }
      it { expect{restore_all}.to_not change(Slide.with_deleted, :count) }

      pending "restore_all returns no false ?" do
        context do
          before { restore_all }
          it { expect(response).to redirect_to trash_index_url }
          it { expect(flash[:error]).to_not be_nil }
        end  
      end

    end
  end
end
