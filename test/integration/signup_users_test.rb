require 'test_helper'

class SignupUsersTest < ActionDispatch::IntegrationTest
    def setup
        @user = User.new(username: "Jonhdo", email: "jonhdo@gmail.com",password: "password", admin: false)
    end
    
    test "sign up user" do
        get signup_path
        assert_template "users/new"
       
        assert_difference 'User.count',1 do
            post_via_redirect users_path, user: {username: @user.username, email: @user.email, password: @user.password, admin: false }
        end

        assert_template "users/show" 
        assert_match @user.username,response.body
        
        @usersaved = User.find_by(username: @user.username)
        assert_equal @user.email ,@usersaved.email
        assert_equal true, !!@usersaved.authenticate(@user.password)
        assert_equal @user.admin , @usersaved.admin
    end
    
end