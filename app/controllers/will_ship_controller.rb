class WillShipController < ApplicationController
  unloadable
  before_filter :require_admin, except: [:force_update]
  before_filter :find_harbor, only: [:edit, :destroy]

  def new
    @harbor = Harbor.new
    @projects = Project.all
  end

  def edit
  end

  def create
    harbor = Harbor.new params[:harbor]
    if harbor.save!
      flash[:notice] = 'New Harbor just created!'
      redirect_to action: 'configure'
    else
      flash[:error] = 'Error!'
      redirect_to :back
    end
  end

  def destroy
    if @harbor.destroy
      flash[:notice] = 'Removed!'
    else
      flash[:error] = 'Error!'
    end

    redirect_to action: 'configure'
  end

  def configure
    @harbors = Harbor.all
  end

  def force_update
    issue = Issue.find params[:issue_id]
    return unless issue.present?
    result = issue.check_harbors!

    if result == true
      flash[:notice] = 'All Harbors checked! If we shipped we will see.'
      redirect_to :back
    else
      @harbors = result
      render 'empty_harbors'
    end
  end

  protected
  def find_harbor
    @harbor = Harbor.find params[:id]
  end
end
