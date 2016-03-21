class CompanyDetailController < ApplicationController
  def index
    if admin_signed_in?

      # @users = User.select("users.id, users.first_name, users.last_name, users.email, companies.comment, users.image_url, companies.company_name, companies.trade_show_name").joins("INNER JOIN companies ON companies.owner_email_id=users.owner_email_id")
      @comp = Company.where(owner_email_id: params[:owner_email_id ])

       if Company.where(owner_email_id: params[:owner_email_id ]).empty?

         @comp = Company.new(owner_email_id: current_admin.email)

         @comp.save

       end

       @company = Company.where(owner_email_id: current_admin.email)[0]

       if @company.is_admin.eql? 1

       else

          @users = User.where(owner_email_id: current_admin.email)
         puts @users
       end
    else
      redirect_to admin_session_path
    end
  end
end
