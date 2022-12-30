# frozen_string_literal: true

module Attachable
  extend ActiveSupport::Concern

  included do
    has_many_attached :attachments
  end
end
