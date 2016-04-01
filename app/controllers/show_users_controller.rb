class ShowUsersController < ApplicationController


    def showusers

          @users = User.where(owner_email_id: params[:email])
          # raise @users.inspect
          puts @users
          
    end

end