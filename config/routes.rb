# -*- encoding : utf-8 -*-
App::Application.routes.append do
  root to: 'base#home', via: :get
  get 'home_index_page' => redirect('/')

  namespace :admin do
    resources :sections do
      resources :page_sections
    end
    resources :pages
  end

  resources :sections, only: :show do
    get ':id', to: 'page_sections#show', as: :page_section
  end

  mount AuthenticationUser::Engine => '/', as: :authentication_user
  mount Seo::Engine => '/', as: :seo
  if defined? TemplateSystemLayout
    mount TemplateSystemLayout::Engine => '/', as: :template_system_layout
  end
  mount TemplateSystem::Engine => '/', as: :template_system

  get ':id', to: 'pages#show', as: :page, constraints: { format: 'html' }
end
