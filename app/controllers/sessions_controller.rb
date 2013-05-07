class SessionsController < ApplicationController

	def new
		#if signed_in?
      	#	redirect_to root_path, notice: "Already signed in."
    	#end
	end

	def create
		user = User.find_by_email(params[:email].downcase)
		if user && user.authenticate(params[:password])
			sign_in user
			redirect_back_or user
		else
			flash.now[:error] = 'Invalid email/password combinatin'
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_url
	end
end
