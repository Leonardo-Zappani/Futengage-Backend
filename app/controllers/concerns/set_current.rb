module SetCurrent
  extend ActiveSupport::Concern

  def current_futengage
    @current_futengage = Futengage.where('day >= ?', Time.now).first
    
  end

end  