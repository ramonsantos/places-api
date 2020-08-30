# frozen_string_literal: true

module Pagination
  extend ActiveSupport::Concern

  private

  def page
    params[:page] || 1
  end
end
