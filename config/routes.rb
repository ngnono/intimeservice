class VersionConstraint
  def initialize(*version)
    @version = version[0].to_i unless version.nil?
    @version = 2*100+1*10+1 if @version.nil? || @version ==0
  end
 
  def matches?(request)
    current_ver = request.query_parameters[:client_version]
    return false if current_ver.nil?
    current_ver_value = 0
    current_ver.split('.'). each_with_index do |v,i|
      break if i > 2
      current_ver_value += v.to_i*(10 ** (2-i))
    end
    return @version <= current_ver_value
  end
end

IntimeService::Application.routes.draw do
  
  match "wxmsg/update"=>"wxReply#update"

  match "version/latest"=>"version#latest"
  match "version/insert"=>"version#insert"

  match "storecoupon/consume"=>"storeCoupon#consume"
  match "storecoupon/logs"=>"storeCoupon#logs"
  match "storecoupon/void"=>"storeCoupon#void"

  scope :module => "v22" do
    constraints VersionConstraint.new do
     match "promotion/list" =>"promotion#list"
     match "storepromotion/list"=>"storePromotion#list"
     match "storepromotion/detail"=>"storePromotion#detail"
     match "specialtopic/list"=>"specialTopic#list"
     match "banner/list"=>"banner#list"
    end
  end
 
  match "hotword/list"=>"hotword#list"
  match "banner/list"=>"banner#list"

  match "store/list"=>"store#list"
  match "store/all"=>"store#list"
  match "store/detail"=>"store#detail"
  match "store/:id"=>"store#index"

  match "brand/list"=>"brand#list"
  match "brand/all"=>"brand#list"
  match "brand/groupall"=>"brand#list_by_group"

  match "tag/list"=>"tag#list"
  match "tag/all"=>"tag#list"

  match "specialtopic/list" => "specialTopic#list"

  match "product/search" => "product#search"
  match "product/list" => "product#list"
  match "promotion/list" => "promotion#list"
  match "product/:id" => "product#show"
  match "promotion/:id" => "promotion#show"

  match "wx_object/search" => "wxobject#validate", :via=>:get, :defaults=>{:format=>'html'}
  match "wx_object/search" => "wxobject#search", :via=>:post, :defaults=>{:format=>'xml'}
  
  match "ping/mock"=>"ping#mock"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
   namespace :front do
       # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)

       resources :products, :only=>[:show]
       resources :promotions, :only=>[:show]
     end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
