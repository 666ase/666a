class AdminController < ApplicationController
  layout "internal"

  def index
    @days = Day.reverse_chronological
  end

  def day
    @day = Day.find_by(date: params[:date])
  end

  def stats
  end

  def policies
    @policies = Policy.all
  end

  def new_policy
    @policy = Policy.new
    if request.post? then
      @policy = Policy.create(params[:policy].permit(:name, :slug, :icon, :body))
      if @policy.valid? then
        redirect_to "/admin/policies"
        flash[:notice] = "policy created"
      end
    end
  end

  def edit_policy
    @policy = Policy.find_by(slug: params[:slug])
    if request.patch? then
      if @policy.update(params[:policy].permit(:name, :slug, :icon, :body)) then
        flash[:notice] = "policy updated"
      end
    end
  end
end
