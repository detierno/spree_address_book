Order.class_eval do
  attr_accessible :bill_address_id, :ship_address_id

  def clone_billing_address
    if self.bill_address
      self.ship_address = self.bill_address
    end
    true
  end
  
  def bill_address_id=(id)
    address = Address.find(id)
    if address && address.user_id == self.user_id
      self["bill_address_id"] = address.id
      self.bill_address.reload
    else
      self["bill_address_id"] = nil
    end
  end
  
  def bill_address_attributes=(attributes)
    self.bill_address = update_or_create_address(attributes)
  end

  def ship_address_id=(id)
    address = Address.find(id)
    if address && address.user_id == self.user_id
      self["ship_address_id"] = address.id
      self.ship_address.reload
    else
      self["ship_address_id"] = nil
    end
  end
  
  def ship_address_attributes=(attributes)
    self.ship_address = update_or_create_address(attributes)
  end
  
  private
  
  def update_or_create_address(attributes)
    address = nil
    if attributes[:id]
      address = Address.find(attributes[:id])
      if address && address.editable?
        address.update_attributes(attributes)
      else
        attributes.delete(:id)
      end
    end
    
    if !attributes[:id]
      address = Address.new(attributes)
      address.save
    end
    
    address
  end
    
end
