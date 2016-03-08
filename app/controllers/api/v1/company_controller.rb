module Api
  module V1
    class CompanyController < ApplicationController
      skip_before_action :verify_authenticity_token
      def create
        @company = Company.where(owner_email_id: params[:owner_email_id])[0]
        # raise @company.inspect
        if @company.present?
          if @company.company_name != params[:company_name]
            render status: 200, json:{
                                  error_code:3,
                                  message: "There is already another company registered for this Email."
                              }
          else
            @validity = @company.validity
            @created_at = @company.created_at
            @create_int = @created_at.to_i
            @valid_until = @validity * 24 * 60 * 60 + @create_int
            if Time.now.to_i > @valid_until
              render status: 200, json: {
                                    error_code: 2,
                                    message: "Your validity is over. Please contact Admin.",
                                    company: @company,
                                    validity: @validity,
                                    valid_until: @valid_until
                                }
            else
              render status: 200, json:{
                         ##for direct login##
                                    error_code:0,
                                    succuss: true,
                                    company: @company.as_json(:except => [:created_at, :updated_at, :comment])
                                }
            end
          end

        else
          @company = Company.new(company_name: params[:company_name], trade_show_name: params[:trade_show_name], owner_email_id: params[:owner_email_id], validity: params[:validity])
          @company.save
          render status: 200, json: {
                                error_code: 1,
                                success: true,
                                message: "Account created successfully.",
                                company: @company.as_json(:except => [:created_at, :updated_at, :comment]),
                                validity: @company.validity
                            }
        end
      end


      def add_comment
        @company = Company.where(owner_email_id: params[:owner_email_id])[0]
        # raise @company.inspect
        if @company.present?
          @company.update_attributes(comment: comment_params[:comment])
          render status: 201, json:{
                                error_code: 0,
                                success: true,
                                message: 'Comment added successfully.'
                            }
        else
          render status: 402, json:{
                                error_code: 1,
                                success: false,
                                message: []
                            }
        end

      end

      def get_comment
        @comment = Company.where(owner_email_id: params[:owner_email_id])[0]
        if @comment.present?
          render status: 201, json:{
                                error_code: 0,
                                success: true,
                                comment: @comment.comment
                            }
        else
          render status: 402, json:{
                                error_code: 1,
                                success: false,
                                comment: []
                            }
        end
      end


      private
      def company_params
        params.permit(:id, :owner_email_id, :company_name, :trade_show_name, :validity)
      end

      def comment_params
        params.permit(:id, :comment, :owner_email_id)
      end
    end
  end
end