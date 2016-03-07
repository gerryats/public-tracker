class CompanyDetailController < ApplicationController
  def index
    if admin_signed_in?
      @users = User.select("users.id, users.first_name, users.last_name, users.email, companies.comment, users.image_url, companies.company_name, companies.trade_show_name").joins("INNER JOIN companies ON companies.owner_email_id=users.owner_email_id")
    else
      redirect_to admin_session_path
    end
  end
end
