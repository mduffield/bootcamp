#SystemUser controller

get '/admin/system_users' do
        @system_users = SystemUser.all
        erb :system_users
end

get '/admin/system_user/new' do
        @system_users = SystemUser.all
        @system_user = SystemUser.new
        erb :system_user
end

get '/admin/system_user/:id' do
        @system_user = SystemUser[params[:id]]
        @system_users = SystemUser.all
        erb :system_user
end

post '/admin/system_user' do
        system_user = SystemUser[params[:id]] || SystemUser.new
        system_user.username = params[:username]
	#assume it's md5'd already if it's 32 length.  TODO: find a better way
	unless params[:password].length==32
        	system_user.password = Digest::MD5.hexdigest(params[:password])
	end
        system_user.email = params[:email]
        system_user.access = params[:access]
        if params[:action] == 'save'
                if system_user.valid?
                        system_user.save
                else
                        errors = ""
                        system_user.errors.full_messages.each do |message|
                                errors += message.to_s + "<br/>"
                        end
                        flash[:errors] = errors
                end
        end
        redirect '/admin/system_users'
end

delete '/admin/system_user/:id' do
        SystemUser[params[:id]].delete
        redirect '/admin/system_users'
end
