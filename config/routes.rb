Rails.application.routes.draw do
  mount Twilio::Rails::Engine => '/twilio'
  root "home#index"
end
