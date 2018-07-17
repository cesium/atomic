require "rails_helper"

RSpec.describe JobsController, type: :controller do
  before { admin_sign_in }

  describe "GET #new" do
    it "render the correct template" do
      get :new

      expect(response).to render_template("new")
    end
  end

  describe "GET #show" do
    context "when the job exists" do
      it "assigns the correct variable" do
        job = create(:job)

        get :show, params: { id: job.id }

        expect(assigns(:job)).to eq(job)
      end
    end
  end

  describe "GET #index" do
    context "show jobs" do
      it "assigns jobs" do
        create_list(:job, 5)

        get :index

        assigned_jobs = assigns(:jobs).sort
        sorted_jobs = Job.all.sort
        expect(assigned_jobs).to eq(sorted_jobs)
      end
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates an job" do
        job_params = attributes_for(:job)

        expect do
          post :create, params: { job: job_params }
        end.to change { Job.count }.by(1)
      end

      it "redirects to the created job page" do
        job_params = attributes_for(:job)

        post :create, params: { job: job_params }

        job = Job.last
        expect(response).to redirect_to(job_path(job))
      end
    end

    context "with invalid params" do
      it "does not create an job" do
        job_params = attributes_for(:job, position: nil)

        expect do
          post :create, params: { job: job_params }
        end.not_to(change { Job.count })
      end

      it "renders the correct template" do
        job_params = attributes_for(:job, position: nil)

        post :create, params: { job: job_params }

        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      it "updates an existing job" do
        job = create(:job)
        job_params = { position: "A new position" }

        put :update, params: { job: job_params, id: job.id }

        expect(job.reload.position).to eq("A new position")
      end

      it "redirects to the job page" do
        job = create(:job)
        job_params = { position: "A new position" }

        put :update, params: { job: job_params, id: job.id }

        expect(response).to redirect_to(job_path(job))
      end
    end

    context "with invalid params" do
      it "does not update the job" do
        job = create(:job)
        job_params = { position: nil }

        put :update, params: { job: job_params, id: job.id }

        expect(job.reload.position).to be
      end

      it "renders the edit template" do
        job = create(:job)
        job_params = { position: nil }

        put :update, params: { job: job_params, id: job.id }

        expect(response).to render_template("edit")
      end
    end

    context "for an inexistant job" do
      it "404s" do
        job_params = { position: nil }

        put :update, params: { job: job_params, id: 1 }

        expect(response.status).to eq(404)
      end
    end
  end

  describe "DELETE #destroy" do
    context "for an existing job" do
      it "deletes the job" do
        job = create(:job)

        expect do
          delete :destroy, params: { id: job.id }
        end.to change { Job.count }.by(-1)
      end

      it "redirects to the index page" do
        job = create(:job)

        delete :destroy, params: { id: job.id }

        expect(response).to redirect_to(jobs_path)
      end
    end

    context "for an inexistant job" do
      it "doesn't delete any job" do
        expect do
          delete :destroy, params: { id: 1 }
        end.not_to(change { Job.count })
      end

      it "redirects to the index page" do
        delete :destroy, params: { id: 1 }

        expect(response).to redirect_to(jobs_path)
      end
    end
  end
end
