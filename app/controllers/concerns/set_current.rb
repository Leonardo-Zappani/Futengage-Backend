module SetCurrent
  extend ActiveSupport::Concern

  def current_futengage
    @current_futengage = Futengage.where('day >= ?', Time.now).first
    @list_futengages = Futengage.where('day >= ?', Time.now).all
  end

  def list_futengages
    
  end

end  