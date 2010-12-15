class UsersController < ApplicationController
  # GET /users
  # GET /users.xml
  before_filter :authorize, :except=>[:login,:new,:create,:logout]
  ssl_exceptions
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

    respond_to do |format|
      if @user.save
        flash[:notice] = 'Your account was created.  Please log in!'
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
end
