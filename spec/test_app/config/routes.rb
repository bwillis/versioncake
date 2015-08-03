RendersTest::Application.routes.draw do
  resources :renders, only: :index
  resources :unversioned, only: :index
end
