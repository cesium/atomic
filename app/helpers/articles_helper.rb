module ArticlesHelper
  def can_create_article?
    can? :create, Article
  end
end
