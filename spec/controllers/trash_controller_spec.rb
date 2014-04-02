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
    pending do
      before do
        slide.save
        slide.destroy

        get :show, id: slide.id
      end
      it { expect(assigns(:trashed_slide)).to match_array Slide.only_deleted.to_a } 
      it { expect(response).to render_template :show }
    end
  end

  describe "DELETE #destroy" do
    before do
      slide.save
      slide.delete
    end
    
    it do
      delete :destroy, id: slide.id
      expect(response).to redirect_to(trash_index_url)
    end

    it { expect{delete :destroy, id: slide.id}.to_not change(Slide, :count) }
    it { expect{delete :destroy, id: slide.id}.to change(Slide.only_deleted, :count).by(-1) }    
    it { expect{delete :destroy, id: slide.id}.to change(Slide.with_deleted, :count).by(-1) }    
  end

  describe "PATCH #restore"

end
