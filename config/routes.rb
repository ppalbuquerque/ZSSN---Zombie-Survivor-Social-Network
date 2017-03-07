Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # I choose not to use resource authomatic Route generations because i do not want all the routes provide by that method
  match '/items', controller: 'items', action: 'list', via: 'get'
  match '/items', controller: 'items', action: 'create', via: 'post'
  match '/survivors', controller: 'survivors', action: 'list', via: 'get'
  match '/survivors/:id', controller: 'survivors', action: 'show', via: 'get'
  match '/survivors/:id/inventory', controller: 'survivors', action: 'inventory_show', via: 'get'
  match '/survivors', controller: 'survivors', action: 'create', via: 'post'
  match '/survivors/update_location', controller: 'survivors', action: 'update_location', via: 'put'
  match '/survivors/report_infection', controller: 'survivors', action: 'report_infection', via: 'put'
  match '/survivors/trade', controller: 'survivors', action: 'trade', via: 'put'
  match '/infected_rel', controller: 'report', action: 'infected', via: 'get'
  match '/resources_rel', controller: 'report', action: 'resources', via: 'get'
  match '/infected/:id', controller: 'report', action: 'points_lost', via: 'get'
end
