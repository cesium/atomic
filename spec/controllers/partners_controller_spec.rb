require "rails_helper"

RSpec.describe PartnersController, type: :controller do
  before { admin_sign_in }

  describe "GET #new" do
    it "render the correct template" do
      get :new

      expect(response).to render_template("new")
    end
  end

  describe "GET #index" do
    context "show all partners" do
      it "assigns all the partners" do
        create_list(:partner, 5)

        get :index

        assigned_partners = assigns(:partners).sort
        sorted_partners = Partner.all.sort
        expect(assigned_partners).to eq(sorted_partners)
      end
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a partner" do
        partner_params = attributes_for(:partner)

        expect do
          post :create, params: { partner: partner_params }
        end.to change { Partner.count }.by(1)
      end

      it "redirects to the partners page" do
        partner_params = attributes_for(:partner)

        post :create, params: { partner: partner_params }

        expect(response).to redirect_to(partners_path)
      end
    end

    context "with invalid params" do
      it "does not create an partner" do
        partner_params = attributes_for(:partner, name: nil)

        expect do
          post :create, params: { partner: partner_params }
        end.not_to(change { Partner.count })
      end

      it "renders the correct template" do
        partner_params = attributes_for(:partner, name: nil)

        post :create, params: { partner: partner_params }

        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      it "updates an existing partner" do
        partner = create(:partner)
        partner_params = { name: "A new name" }

        put :update, params: { partner: partner_params, id: partner.id }

        expect(partner.reload.name).to eq("A new name")
      end

      it "redirects to the partners page" do
        partner = create(:partner)
        partner_params = { name: "A new name" }

        put :update, params: { partner: partner_params, id: partner.id }

        expect(response).to redirect_to(partners_path)
      end
    end

    context "with invalid params" do
      it "does not update the partner" do
        partner = create(:partner)
        partner_params = { name: nil }

        put :update, params: { partner: partner_params, id: partner.id }

        expect(partner.reload.name).to be
      end

      it "renders the edit template" do
        partner = create(:partner)
        partner_params = { name: nil }

        put :update, params: { partner: partner_params, id: partner.id }

        expect(response).to render_template("edit")
      end
    end

    context "for an inexistant partner" do
      it "404s" do
        partner_params = { name: nil }

        put :update, params: { partner: partner_params, id: 1 }

        expect(response.status).to eq(404)
      end
    end
  end

  describe "DELETE #destroy" do
    context "for an existing partner" do
      it "deletes the partner" do
        partner = create(:partner)

        expect do
          delete :destroy, params: { id: partner.id }
        end.to change { Partner.count }.by(-1)
      end

      it "redirects to the index page" do
        partner = create(:partner)

        delete :destroy, params: { id: partner.id }

        expect(response).to redirect_to(partners_path)
      end
    end

    context "for an inexistant partner" do
      it "doesn't delete any partner" do
        expect do
          delete :destroy, params: { id: 1 }
        end.not_to(change { Partner.count })
      end

      it "404s" do
        delete :destroy, params: { id: 1 }

        expect(response.status).to eq(404)
      end
    end
  end
end
