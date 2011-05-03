Address.class_eval do
  belongs_to :user
  
  # can modify an address if it's not been used in an order 
  def editable?
    new_record? || (shipments.empty? && (Order.where("bill_address_id = ?", self.id).count + Order.where("bill_address_id = ?", self.id).count <= 1) && Order.complete.where("bill_address_id = ? OR ship_address_id = ?", self.id, self.id).count == 0)
  end
  
  def can_be_deleted?
    shipments.empty? && Order.where("bill_address_id = ? OR ship_address_id = ?", self.id, self.id).count == 0
  end
  
  def to_s
    "#{firstname} #{lastname}: #{zipcode}, #{country}, #{state || state_name}, #{city}, #{address1} #{address2}"
  end
  
  def destroy_with_saving_used
    if can_be_deleted?
      destroy_without_saving_used
    else
      update_attribute(:deleted_at, Time.now)
    end
  end
  alias_method_chain :destroy, :saving_used

end
