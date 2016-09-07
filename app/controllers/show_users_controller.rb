class ShowUsersController < ApplicationController


    def showusers
    	  
          @users = User.where(owner_email_id: params[:email])
          # raise @users.inspect
          puts @users
          
    end

    def license_detail
    	
    	@company = Company.where(owner_email_id: current_admin.email)[0]

	      # flash['alert'] = "Your License Number: #{license}"
	      # redirect_to root_path	
    end	

    def generate_license
    	license = rand(36**6).to_s(36)

	      begin
	        license = rand(36**6).to_s(36)
	      end while not Company.find_by_license(license).nil?

	      Validlicense.create(:generated_licenses=>license, :owner_email=>current_admin.email).save

	      @company = Company.where(owner_email_id: current_admin.email)[0]


	      @company.update_attributes(:license => license, :License_valid_days => params[:days], :cost => params[:cost])

	      @company.update_attributes(License_creation_date: Time.now, License_renewed_date: Time.now, License_valid_days:@company.License_valid_days)

	      @lic = LicenseRecord.new(email:current_admin.email,license:@company.license ,cost:@company.cost)

	      @lic.save
	      redirect_to show_users_license_detail_path
    end	
end