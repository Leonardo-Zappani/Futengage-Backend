# frozen_string_literal: true

class Tabs::NavComponent < ApplicationComponent
  renders_many :items, 'Tabs::NavItemComponent'
end
