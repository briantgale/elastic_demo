Rails.application.routes.draw do
  get "db_report", to: "reports#db"
  get "es_report", to: "reports#es"
  get "add_people", to: "homes#add_people"
  root to: "homes#index"
end
