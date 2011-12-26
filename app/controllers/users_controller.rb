class UsersController < ApplicationController
  # GET /users
  # GET /users.xml
  before_filter :authorize, :except=>[:login,:new,:create,:logout,:forgot,:reset,:activate,:link_user_accounts]
  ssl_exceptions :link_user_accounts
  def index
    redirect_to root_path
  end
  def login
    @page_desc="Login"
    @page_title="Login"
    session[:user_id] = nil
    if request.post?
      user = User.authenticate(params[:email], params[:password])
      if user
        session[:user_id] = user.id
        uri = session[:original_uri]
        session[:original_uri] = nil
        redirect_to(uri || { :controller=>"home",:action => "index" })
      else
        flash.now[:notice] = "Invalid user/password combination"
      end
    end
  end

  def logout
    @page_desc="Logout"
    @page_title="Logout"    
    session[:user_id] = nil
    current_user = nil
    flash[:notice] = "Logged out"
    redirect_to(:controller=>"home",:action => "index" )
  end
  
  def logout_fb
    @page_desc="Logout"
    @page_title="Logout"    
    set_fb_cookie(nil,nil,nil,nil) # clear the fb cookies
    session[:user_id] = nil
    current_user = nil
    flash[:notice] = "Logged out"
    redirect_to(:controller=>"home",:action => "index" )
  end
  # GET /users/1
  # GET /users/1.xml
  def show
    redirect_to root_path
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    begin
      @user = User.find(params[:id],:conditions=>["id=?",current_user_id])
    rescue
      flash.now[:error] = "Unable to find User."
      redirect_to root_path
    end
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    @user.create_activation_code
    respond_to do |format|
      if @user.save

        flash[:notice] = 'Your account was created. Before you can login, you must
        activate your account.  Check your email for the activation email.'
        format.html { redirect_to login_path}
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { render :action=>:edit }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end 
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

  def forgot
    if request.post?
      user = User.find_by_email(params[:user][:email])
      if user
        user.create_reset_code
        flash[:notice] = "Reset code sent to #{user.email}"
      else
        flash[:notice] = "#{params[:user][:email]} does not exist in system"
      end
      redirect_back_or_default('/')
    end
  end

  def reset
    @user = User.find_by_reset_code(params[:reset_code]) unless params[:reset_code].nil?
    @user.reset_password=true
    if request.post?

      if @user.update_attributes(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
        self.current_user = @user
        @user.delete_reset_code
        flash[:notice] = "Password reset successfully for #{@user.email}"
        redirect_back_or_default('/')
      else
        render :action => :reset
      end
    end
  end

  def activate
    @user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].nil?
    
    self.current_user = @user
    if @user.delete_activation_code
      flash[:notice] = "Your account has been activated!"
      redirect_back_or_default('/')
    else
      render :action => :reset
    end

  end
  
  def link_user_accounts
    if current_user.nil?
      #register with fb
      User.create_from_fb_connect(current_facebook_user)
      user = User.find_by_fb_user(current_facebook_user)
      redirect_to my_page_path
    else
      current_user.link_fb_connect(current_facebook_user.id) unless current_user.facebook_id == current_facebook_user.id
      redirect_to root_path
    end
  end
  
end
