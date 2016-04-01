class CompanyDetailController < ApplicationController
  def index
    if admin_signed_in?

      # @users = User.select("users.id, users.first_name, users.last_name, users.email, companies.comment, users.image_url, companies.company_name, companies.trade_show_name").joins("INNER JOIN companies ON companies.owner_email_id=users.owner_email_id")
      # @comp = Company.where(owner_email_id: params[:owner_email_id ])

       if Company.where(owner_email_id: current_admin.email).empty?

         @comp = Company.new(owner_email_id: current_admin.email,License_state: "deactivate")

         @comp.save

       end

       @company = Company.where(owner_email_id: current_admin.email)[0]

       if @company.is_admin.eql? 1

          @allcompaniesdata = Company.all

       else

          @users = User.where(owner_email_id: current_admin.email)

       end
    else
      redirect_to admin_session_path
    end
  end

  def save_license_cost

    @updateLicense_cost = Company.where(owner_email_id: current_admin.email)[0]

    @updateLicense_cost.update_attribute(:cost, params[:cost][:license_key_cost])

    @updateLicense_cost.save

    redirect_to root_path

  end

  def get_license_cost

    @company = Company.where(is_admin:1)[0]

    render status: 200, json:{
                          success: true,
                          cost: @company.cost
                      }
  end

  def generate_license_for_Company_user

    # @company = Company.where(owner_email_id: current_admin.email)[0]
    #
    # puts "sssssssssssssssss"
    # puts params
    #
    # @company.update_attribute(:License_valid_days ,params[:days])
    # @company.update_attribute(:cost ,params[:cost])

  #   license = rand(36**6).to_s(36)
  #
  #   begin
  #     license = rand(36**6).to_s(36)
  #   end while not Company.find_by_license(license).nil?
  #
  #   Validlicense.create(:generated_licenses=>license, :owner_email=>params[:email]).save
  #
  #   @company = Company.where(owner_email_id: params[:email])[0]
  #
  #   @company.update_attribute(:license, license)
  #
  #   flash['alert'] = "Your License Number: #{license}"
     redirect_to root_path

  end

end
