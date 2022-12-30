class ApplicationInteractor
  include Interactor

  protected

  def logger
    Rails.logger
  end
end
