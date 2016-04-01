module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :verify_authenticity_token
      def create
          @user = User.new(email: params[:email], first_name: params[:first_name], last_name: params[:last_name], owner_email_id: params[:owner_email_id], image_url: params[:image_url])
          if @user.save
            render status: 201, json: {
                                  error_code: 0,
                                  success: true,
                                  message: "Account created successfully."
                              }
          else
            render status: 402, json:{
                                  error_code: 1,
                                  success: false,
                                  message: []
                              }
          end
        end

    

      private
      def user_params
        params.permit(:id, :email, :first_name, :last_name, :owner_email_id, :image_url)
      end

    end
  end
end