#This controller runs the landing page
class PagesController < ApplicationController
  def home
  	if current_user
  		redirect_to activities_path #just go to timeline once you login or click upper left title
  	end
  end
end
