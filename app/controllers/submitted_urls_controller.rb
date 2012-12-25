class SubmittedUrlsController < ApplicationController
  require 'will_paginate/array'
  
  def index 
    @users = {}
    @submitted_urls = SubmittedUrl.all.paginate(page: params[:page], per_page: 10)
    @submitted_urls.each do |item| 
      user_id = item.user_id 
      @users[user_id] = User.find_by_id(user_id) unless user_id.nil?
    end
    respond_to do |format|
      format.html
      format.json {render :json => @submitted_urls.to_json}
    end
  end

  def create
    success = false
    user_id = current_user.id unless current_user.nil?
    new_submitted_url = SubmittedUrl.new  :user_id  => user_id, 
                                          :url      =>  params[:url],
                                          :message   => params[:message]
    captcha_result = params[:value_a].to_i + params[:value_b].to_i
    
    if current_user 
      success = new_submitted_url.save
    elsif (not params[:fb_math].nil? and (captcha_result == params[:fb_math].to_i) )
       success = new_submitted_url.save
    end
    if success
      flash[:notice] = "Url is saved successfully"
    else
      flash[:error] = "Cant save url - not valid content."
    end
    
    respond_to do |format|
      format.html {redirect_to :back} 
      format.json {render :json => {:success => success}}
    end
  end
end
