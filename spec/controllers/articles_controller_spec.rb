require "rails_helper"

RSpec.describe ArticlesController, type: :controller do
  before { admin_sign_in }

  describe "GET #new" do
    it "render the correct template" do
      get :new

      expect(response).to render_template("new")
    end
  end

  describe "GET #show" do
    context "when the article exists" do
      it "assigns the correct variable" do
        article = create(:article)

        get :show, params: { id: article.id }

        expect(assigns(:article)).to eq(article)
      end
    end
  end

  describe "GET #index" do
    context "show all articles" do
      it "assigns all articles" do
        create_list(:article, 5)

        get :index

        articles = Article.all
        expect(articles.count).to eq(5)
      end
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates an article" do
        article_params = attributes_for(:article)

        expect do
          post :create, params: { article: article_params }
        end.to change { Article.count }.by(1)
      end

      it "redirects to the created article page" do
        article_params = attributes_for(:article)

        post :create, params: { article: article_params }

        article = Article.last
        expect(response).to redirect_to(article_path(article))
      end
    end

    context "with invalid params" do
      it "does not create an article" do
        article_params = attributes_for(:article, name: nil)

        expect do
          post :create, params: { article: article_params }
        end.not_to(change { Article.count })
      end

      it "renders the correct template" do
        article_params = attributes_for(:article, name: nil)

        post :create, params: { article: article_params }

        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      it "updates an existing article" do
        article = create(:article)
        article_params = { name: "A new name" }

        put :update, params: { article: article_params, id: article.id }

        expect(article.reload.name).to eq("A new name")
      end

      it "redirects to the article page" do
        article = create(:article)
        article_params = { name: "A new name" }

        put :update, params: { article: article_params, id: article.id }

        expect(response).to redirect_to(article_path(article))
      end
    end

    context "with invalid params" do
      it "does not update the article" do
        article = create(:article)
        article_params = { name: nil }

        put :update, params: { article: article_params, id: article.id }

        expect(article.reload.name).to be
      end

      it "renders the edit template" do
        article = create(:article)
        article_params = { name: nil }

        put :update, params: { article: article_params, id: article.id }

        expect(response).to render_template("edit")
      end
    end

    context "for an inexistant article" do
      it "404s" do
        article_params = { name: nil }

        put :update, params: { article: article_params, id: 1 }

        expect(response.status).to eq(404)
      end
    end
  end

  describe "DELETE #destroy" do
    context "for an existing article" do
      it "deletes the article" do
        article = create(:article)

        expect do
          delete :destroy, params: { id: article.id }
        end.to change { Article.count }.by(-1)
      end

      it "redirects to the index page" do
        article = create(:article)

        delete :destroy, params: { id: article.id }

        expect(response).to redirect_to(articles_path)
      end
    end

    context "for an inexistant article" do
      it "doesn't delete any article" do
        expect do
          delete :destroy, params: { id: 1 }
        end.not_to(change { Article.count })
      end

      it "404s" do
        delete :destroy, params: { id: 1 }

        expect(response.status).to eq(404)
      end
    end
  end
end
