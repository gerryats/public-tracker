require 'time'

class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new

    @order = Order.new
    @order.total_cost = params[:cost]
    @order.total_days = params[:days]
    # @order.selected_date
    @company = Company.where(owner_email_id: current_admin.email)[0]

    @company.update_attribute(:License_valid_days ,params[:days])
    @company.update_attribute(:cost ,params[:cost])

  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create

    @order = Order.new(order_params)
    # @order = current_cart.build_order(params[:order])
    @order.ip_address = request.remote_ip

    if @order.save
      if @order.purchase

        if not Company.where(owner_email_id: current_admin.email)[0].license.nil?

          @company = Company.where(owner_email_id: current_admin.email)[0]

          @company.update_attributes(License_renewed_date: Time.now, License_valid_days:@company.License_valid_days,License_state: "deactivate" )

          @lic = LicenseRecord.new(email:current_admin.email,license:@company.license ,cost:@company.cost)

          @lic.save

          flash['alert'] = "Your License renewed: #{@company.license}"
          redirect_to root_path

        else

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

          flash['alert'] = "Your License Number: #{license}"
          redirect_to root_path

        end

      else
        flash['alert'] = "Transaction failure"
        redirect_to root_path
      end
    else
      render :action => 'new'
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:new, :card_verification ,:card_number ,:cart_id, :ip_address, :first_name, :last_name, :card_brand, :card_expires_on)
    end
end
