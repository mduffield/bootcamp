require 'rubygems'
require 'thin'
require 'sinatra'
require 'sinatra/flash'
require 'pony'
require 'digest/md5'
require 'uuid'
require 'time'

require_relative 'config'

use Rack::Session::Cookie 

configure do
	set :public_folder, Proc.new { File.join(root, "static") }
	enable :sessions
	#Needs to be the same every time for sessions to work properly
	set :session_secret, "OTg1NTY3MTA5ODU1NjcxMDk4NTU2NzEw"
end

helpers do
	def username
		session[:identity] ? session[:identity] : 'Not logged in'
	end

	def is_admin
		unless session[:access]=='admin'
			false
		else
			true
		end
	end
	
	def is_user
		unless session[:identity]
			false
		else
			true
		end
	end
end

before '/admin/*' do
	unless session[:identity] and session[:access]=='admin' then
		session[:previous_url] = request['REQUEST_PATH']
		@error = 'Sorry, you need to be logged in as an administrator to do that'
		halt erb(:login_form)
	end
end

before '/user/*' do
	unless session[:identity]  then
		session[:previous_url] = request['REQUEST_PATH']
		@error = 'Sorry, you need to be logged in to do that'
		halt erb(:login_form)
	end
end

def go_home
        redirect '/'
end

get '/' do
        erb :index
end

get '/login/form' do
  erb :login_form
end

post '/login/attempt' do
	user = SystemUser[:username=>params['username']]
	unless user.nil?	
		if Digest::MD5.hexdigest(params['password'])==user.password
			session[:identity] = params['username']
			session[:access] = user.access
			where_user_came_from = session[:previous_url] || '/'
			redirect to where_user_came_from
		else
			erb "<div class='alert alert-message'>Wrong username or password</div>"
		end
	else
		erb "<div class='alert alert-message'>Wrong username or password</div>"
	end
end

get '/user/change_password' do
	erb :change_password
end

post '/user/change_password' do
	new_password = params[:new_password]
	confirm_password = params[:confirm_password]
	unless new_password == confirm_password
		erb "<div class='alert alert-message'>Passwords do not match</div>"
	else
		user = SystemUser[:username=>username]
		user.password = Digest::MD5.hexdigest(new_password)
		user.save
		erb "<div class='alert alert-message'>Password has been changed</div>"
	
	end
end

get '/recover_password' do
	erb :password_form
end

post '/recover_password' do
	input = params[:username_or_email]
	user = nil
	unless input.index("@").nil?
		user = SystemUser[:email=>input]
	else
		user = SystemUser[:username=>input]
	end
	unless user.nil?
		unless user.email.empty?
			#generate new random password
			new_password = UUID.new.generate[0..5]
			user.password = Digest::MD5.hexdigest(new_password)
			user.save
			Pony.mail :to => user.email,
				:from => 'noreply@yourdomain.com',
				:subject => 'Your Password Recovery',
				:body => 'Your new temporary password is: '+new_password
			erb "<h2>An email has been sent containing your new password</h2>"
		else
			erb "<h2>An error has occurred.  Please contact technical support.</h2>"
		end
	else
		erb "<h2>Could not locate user with that information</h2>"
	end
end

get '/logout' do
	session.delete(:identity)
	session.delete(:access)
	erb "<div class='alert alert-message'>Logged out</div>"
end

