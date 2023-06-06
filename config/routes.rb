Rails.application.routes.draw do
	devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations',passwords: 'users/passwords'}
	
	devise_scope :user do
		get 'login', to: 'users/sessions#new' 
		get 'logout', to: 'users/sessions#destroy' 
		get 'change_my_password', to: 'users/registrations#edit' 
		get '/users/password', to:'users/passwords#new'
		get '/users', to:'users/registrations#new'
		authenticated :user do
			root to: redirect('/admin_panel')
		end 
		unauthenticated do
			# root to: redirect('/')
			# redirect_to root_path
			redirect('/')
		end
	end 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  #sas_2021
  # get 'sas', to: 'sunshines#index'
  get 'site_up', to: 'sunshines#site_ok'
  get '/', to:'sunshines#index'
  get 'home', to:'sunshines#home'
  get 'about', to:'sunshines#about'
  get 'contact_us', to:'sunshines#contact_us'
  # post 'send_mail', to:'sunshines#send_mail'
  post 'mail_send_to_customer', to:'sunshines#mail_send_to_customer'
  get 'admin_panel', to:'sunshines#admin_panel'
  
  get 'upload_brochure', to:'image_pdf#upload_brochure'
  get 'download_documentation', to:'image_pdf#download_documentation'
  get 'download_documentation_admin', to:'image_pdf#download_documentation_admin'
  get 'download_file', to:'image_pdf#download_file'
  post 'upload_documentation_file', to:'image_pdf#upload_documentation_file'
  post 'get_documentation_aggrid_data', to:'image_pdf#get_documentation_aggrid_data'
  post 'delete_document_file', to:'image_pdf#delete_document_file'
  
  get 'upload_project_images', to:'image_pdf#upload_project_images'
  post 'upload_project_images_form', to:'image_pdf#upload_project_images_form'
  get 'upload_project_images_form', to:'image_pdf#upload_project_images_form'
  post 'get_project_images_aggrid_data', to:'image_pdf#get_project_images_aggrid_data'
  post 'delete_project_image_file', to:'image_pdf#delete_project_image_file'
  
  get 'upload_clients', to:'clients#upload_clients'
  post 'get_clients_logo_aggrid_data', to:'clients#get_clients_logo_aggrid_data'
  post 'upload_client_images_form', to:'clients#upload_client_images_form'
  post 'delete_client_logo_image_file', to:'clients#delete_client_logo_image_file'
  get 'download_client_logos', to:'clients#download_client_logos'
  get 'test_pdf', to:'sunshines#test_pdf'
  
  #bill details
  get 'bill_generation', to:'bill_details#index'
  get 'createBill', to:'bill_details#createBill'
  post 'save_bill', to:'bill_details#save_bill'
  post 'generate_pdf_bill', to:'bill_details#generate_pdf_bill'
  get 'generate_pdf_bill', to:'bill_details#generate_pdf_bill'
end
