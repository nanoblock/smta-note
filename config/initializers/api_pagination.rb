ApiPagination.configure do |config|
  config.paginator = :will_paginate
  config.total_header = 'X-Total'
  config.per_page_header = 'X-Per-Page'
  config.page_header = 'X-Page'

  # Optional: what parameter should be used to set the page option
  config.page_param = :page

  # config.page_param do |params|
  #   params[:page][:number]
  # end

  config.per_page_param = :per_page

  # config.per_page_param do |params|
  #   params[:page][:size]
  # end
end