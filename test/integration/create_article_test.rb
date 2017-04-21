require 'test_helper'

class CreateArticleTest < ActionDispatch::IntegrationTest
    def setup
        @user = User.create(username: "Jonhdo", email: "jonhdo@gmail.com",password: "password", admin: true)
        sign_in_as(@user, "password")
        @category = Category.create(name:"sports")
        @article = Article.new(title: "Title one", description: "Description one")
    end
    
    test "Create article" do
        get new_article_path
        assert_template "articles/new"
       
        assert_difference 'Article.count',1 do
            post_via_redirect articles_path, article: {title: @article.title, description: @article.description, category_ids: [@category.id] }
        end

        assert_template "articles/show" 
        assert_match @article.title,response.body
        assert_match @article.description,response.body
        
        @articlecreated = Article.find_by(title: @article.title)
        assert_equal @article.title ,@articlecreated.title
        assert_equal @article.description , @articlecreated.description
        assert_equal @category , @articlecreated.categories.first
    end
    
end