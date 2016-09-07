include ActionView::Helpers::DateHelper

module Api
  module V1
    class CompanyController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :Check_Validity, except: [:create , :get_valid_days_left ,:get_license_cost]

      # def create
      #   @company = Company.where(owner_email_id: params[:owner_email_id])[0]
      #   # raise @company.inspect
      #   if @company.present?
      #     if @company.company_name != params[:company_name]
      #       render status: 200, json:{
      #                             error_code:3,
      #                             message: "There is already another company registered for this Email."
      #                         }
      #     else
      #       @validity = @company.validity
      #       @created_at = @company.created_at
      #       @create_int = @created_at.to_i
      #       @valid_until = @validity * 24 * 60 * 60 + @create_int
      #       if Time.now.to_i > @valid_until
      #         render status: 200, json: {
      #                               error_code: 2,
      #                               message: "Your validity is over. Please contact Admin.",
      #                               company: @company,
      #                               validity: @validity,
      #                               valid_until: @valid_until
      #                           }
      #       else
      #         render status: 200, json:{
      #                    ##for direct login##
      #                               error_code:0,
      #                               succuss: true,
      #                               company: @company.as_json(:except => [:created_at, :updated_at, :comment])
      #                           }
      #       end
      #     end
      #
      #   else
      #     @company = Company.new(company_name: params[:company_name], trade_show_name: params[:trade_show_name], owner_email_id: params[:owner_email_id], validity: params[:validity])
      #     @company.save
      #     render status: 200, json: {
      #                           error_code: 1,
      #                           success: true,
      #                           message: "Account created successfully.",
      #                           company: @company.as_json(:except => [:created_at, :updated_at, :comment]),
      #                           validity: @company.validity
      #                       }
      #   end
      # end

      def get_valid_days_left

        @company = Company.where(owner_email_id: params[:email])[0]
        @activation_date = @company.License_activation_date
        @validity = @company.License_valid_days
        @expiry_date = (@activation_date.to_i + (@validity * (24*60*60)))
        # @expiry_dateintimeformat = @activation_date + @validity
        @days_left = nil
        if Time.now.utc.to_i >= @expiry_date
          @days_left = 0
        else
          @days_left = ((@expiry_date - Time.now.utc.to_i)/((24 * 60 * 60).to_f)).round(2).ceil

          # @validity_left = Time.at(((@expiry_date - Time.now.utc.to_i)/((24 * 60 * 60)))

          # @validity_left = distance_of_time_in_words(@expiry_dateintimeformat, Time.now.utc,include_seconds: true) + "left"

        end

        render status: 200, json:{
                   success: true,
                   days_left: @days_left
                          }
      end

      def get_license_cost

        @company = Company.where(is_admin:1)[0]

        render status: 200, json:{
                              success: true,
                              cost: @company.cost
                          }
      end

      def create
          @company = Company.where(license: params[:license])[0]

          if @company.present?

              @validity = @company.License_valid_days
              #@company.update_attributes(company_name: params[:company_name], trade_show_name: params[:trade_show_name])
              # license renewed date will be updated when company's user license has actually expired expired or on avail of fresh license from web app
              if @company.License_activation_date.nil? or (@company.License_activation_date.to_i < @company.License_renewed_date.to_i and @company.License_state.eql? 'deactivate')
                @company.update_attribute("License_activation_date", Time.now)

              end

              @activated_at = @company.License_activation_date
              @create_int = @activated_at.to_i
              @valid_until = @validity * 24 * 60 * 60 + @create_int

              # puts @validity
              puts Time.now.utc.to_i
              puts @company.License_activation_date.to_i
              puts Time.now.utc.to_datetime
              puts @company.License_activation_date.to_datetime

              if Time.now.to_i > @valid_until

                if @company.License_state.eql? 'activated'
                  @company.update({License_state: "deactivate"})


                end
                render status: 200, json: {
                                      error_code: 3,
                                      message: "Your validity is over. Please contact Admin.",
                                      company: @company
                                  }
              else
                if @company.License_state.eql? 'deactivate'
                  @company.update({License_state: "activated"})


                   render status: 200, json:{
                                         ##for direct login##
                                         error_code:1,
                                         succuss: true,
                                         message: "Account activated successfully.",
                                         company: @company.as_json(:except => [:created_at, :updated_at, :comment])
                                     }
                else
                  render status: 200, json:{
                                        error_code: 0,
                                        succuss: true,
                                        #message: "Account is already activated.",
                                        company: @company.as_json(:except => [:created_at, :updated_at, :comment])
                                    }
                end
              end

          else
            render status: 200, json: {
                                  error_code: 4,
                                  success: true,
                                  message: "This License key does not exist. Please enter valid license key."
                              }
          end
      end

      def add_comment
        @company = Company.where(owner_email_id: params[:owner_email_id])[0]
        # raise @company.inspect
        if @company.present?
          @validity = @company.License_valid_days
          @activated_at = @company.License_activation_date
          @create_int = @activated_at.to_i
          @valid_until = @validity * 24 * 60 * 60 + @create_int
          # raise Time.now.to_i.inspect
          if Time.now.to_i > @valid_until
            render status: 200, json: {
                                  error_code: 3,
                                  message: "Your validity is over. Please contact Admin."
                              }
          else                    
            @company.update_attributes(comment: comment_params[:comment])
            @company.save
            render status: 201, json:{
                                  error_code: 0,
                                  success: true,
                                  message: 'Comment added successfully.'
                              }
          end                    
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
                                message: 'no comment',
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