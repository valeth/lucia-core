Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"

  # All unmatched requests, as well as the root, should render a 404 response
  match "*unmatched_route", via: :all, to: "application#route_not_found"
  match "/", via: :all, to: "application#route_not_found"
end
