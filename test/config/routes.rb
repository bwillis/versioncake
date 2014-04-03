RendersTest::Application.routes.draw do
  resources :renders

  namespace 'api' do
    resource :renders
  end
end