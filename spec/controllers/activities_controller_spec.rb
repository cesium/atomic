require "rails_helper"

RSpec.describe ActivitiesController, type: :controller do
  before { admin_sign_in }

  describe "GET #new" do
    it "render the correct template" do
      get :new

      expect(response).to render_template("new")
    end
  end

  describe "GET #show" do
    context "when the activity exists" do
      it "assigns the correct variable" do
        activity = create(:activity)

        get :show, params: { id: activity.id }

        expect(assigns(:activity)).to eq(activity)
      end
    end
  end

  describe "GET #index" do
    context "for next activities" do
      it "assigns all the next activities" do
        create_list(:activity, 5, end_date: 10.days.from_now)

        get :index

        assigned_activities = assigns(:activities).sort
        sorted_activities = Activity.all.sort
        expect(assigned_activities).to eq(sorted_activities)
      end
    end

    context "for previous activities" do
      it "assigns all the previous activities" do
        create_list(:activity, 5, start_date: 4.days.ago, end_date: 3.days.ago)

        get :index, params: { show: "previous" }

        assigned_activities = assigns(:activities).sort
        sorted_activities = Activity.all.sort
        expect(assigned_activities).to eq(sorted_activities)
      end
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates an activity" do
        activity_params = attributes_for(:activity)

        expect do
          post :create, params: { activity: activity_params }
        end.to change { Activity.count }.by(1)
      end

      it "redirects to the created activity page" do
        activity_params = attributes_for(:activity)

        post :create, params: { activity: activity_params }

        activity = Activity.last
        expect(response).to redirect_to(activity_path(activity))
      end
    end

    context "with invalid params" do
      it "does not create an activity" do
        activity_params = attributes_for(:activity, name: nil)

        expect do
          post :create, params: { activity: activity_params }
        end.not_to(change { Activity.count })
      end

      it "renders the correct template" do
        activity_params = attributes_for(:activity, name: nil)

        post :create, params: { activity: activity_params }

        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      it "updates an existing activity" do
        activity = create(:activity)
        activity_params = { name: "A new name" }

        put :update, params: { activity: activity_params, id: activity.id }

        expect(activity.reload.name).to eq("A new name")
      end

      it "redirects to the activity page" do
        activity = create(:activity)
        activity_params = { name: "A new name" }

        put :update, params: { activity: activity_params, id: activity.id }

        expect(response).to redirect_to(activity_path(activity))
      end
    end

    context "with invalid params" do
      it "does not update the activity" do
        activity = create(:activity)
        activity_params = { name: nil }

        put :update, params: { activity: activity_params, id: activity.id }

        expect(activity.reload.name).to be
      end

      it "renders the edit template" do
        activity = create(:activity)
        activity_params = { name: nil }

        put :update, params: { activity: activity_params, id: activity.id }

        expect(response).to render_template("edit")
      end
    end

    context "for an inexistant activity" do
      it "404s" do
        activity_params = { name: nil }

        put :update, params: { activity: activity_params, id: 1 }

        expect(response.status).to eq(404)
      end
    end
  end

  describe "DELETE #destroy" do
    context "for an existing activity" do
      it "deletes the activity" do
        activity = create(:activity)

        expect do
          delete :destroy, params: { id: activity.id }
        end.to change { Activity.count }.by(-1)
      end

      it "redirects to the index page" do
        activity = create(:activity)

        delete :destroy, params: { id: activity.id }

        expect(response).to redirect_to(activities_path)
      end
    end

    context "for an inexistant activity" do
      it "doesn't delete any activity" do
        expect do
          delete :destroy, params: { id: 1 }
        end.not_to(change { Activity.count })
      end

      it "redirects to the index page" do
        delete :destroy, params: { id: 1 }

        expect(response).to redirect_to(activities_path)
      end
    end
  end
end
