class ShowUsersController < ApplicationController


    def showusers
    	  
          @users = User.where(owner_email_id: params[:email])
          # raise @users.inspect
          puts @users
          
    end

    def license_detail
    	license = rand(36**6).to_s(36)

	      begin
	        license = rand(36**6).to_s(36)
	      end while not Company.find_by_license(license).nil?

	      Validlicense.create(:generated_licenses=>license, :owner_email=>current_admin.email).save

	      @company = Company.where(owner_email_id: current_admin.email)[0]


	      @company.update_attribute(:license, license)

	      @company.update_attributes(License_creation_date: Time.now, License_renewed_date: Time.now, License_valid_days:@company.License_valid_days,License_state: "deactivate" )

	      @lic = LicenseRecord.new(email:current_admin.email,license:@company.license ,cost:@company.cost)

	      @lic.save
	      
	      # flash['alert'] = "Your License Number: #{license}"
	      # redirect_to root_path	
    end	
end