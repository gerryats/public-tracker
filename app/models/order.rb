class Order < ActiveRecord::Base
  # belongs_to :cart
  has_many :transactions, :class_name => "OrderTransaction"

  attr_accessor :card_number, :card_verification

  validate :validate_card, :on => :create

  def purchase
    response = GATEWAY.purchase(price_in_cents, credit_card,  :ip => ip_address)
    transactions.create!(:action => "purchase", :amount => price_in_cents, :response => response)
    # cart.update_attribute(:purchased_at, Time.now) if response.success?
    response.success?
  end

  def price_in_cents

    # @company = Company.where(owner_email_id: current_admin.email)[0]
    #
    # retrun @company.cost
100
  end


  private

  def purchase_options
    {
        :ip => ip_address,
        :billing_address => {
            :name     => "Ryan Bates",
            :address1 => "123 Main St.",
            :city     => "New York",
            :state    => "NY",
            :country  => "US",
            :zip      => "10001"
        }
    }
  end

  def validate_card
    unless credit_card.valid?
      credit_card.errors.full_messages.each do |message|
        errors[:base] <<  message
      end
    end
  end

  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
        :type               => card_brand,
        :number             => card_number,
        :verification_value => card_verification,
        :month              => card_expires_on.month,
        :year               => card_expires_on.year,
        :first_name         => first_name,
        :last_name          => last_name
    )
  end
end
