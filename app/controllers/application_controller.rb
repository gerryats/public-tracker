class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_devise_permitted_parameters, if: :devise_controller?

  def Check_Validity

    @company = Company.where(license: params[:license])[0]

    if @company.present?

      @validity = @company.License_valid_days
      @activated_at = @company.License_activation_date
      @create_int = @activated_at.to_i
      @valid_until = @validity * 24 * 60 * 60 + @create_int

      if Time.now.to_i > @valid_until

        if @company.License_state == 'activated'
          @company.update_attribute(:License_state, "deactivate")
        end
        render status: 200, json: {
                              error_code: 2,
                              message: "Your validity is over. Please contact Admin.",
                              company: @company
                          }
      end
    end
  end


  protected

  def configure_devise_permitted_parameters
    registration_params = [:username, :email, :password, :password_confirmation]

    if params[:action] == 'update'
      devise_parameter_sanitizer.for(:account_update) {
          |u| u.permit(registration_params << :current_password)
      }
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.for(:sign_up) {
          |u| u.permit(registration_params)
      }
    end
  end
end
