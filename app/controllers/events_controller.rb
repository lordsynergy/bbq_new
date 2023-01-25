class EventsController < ApplicationController
  before_action :authenticate_user!, except: %i[show index]
  before_action :password_guard!, only: [:show]

  def index
    authorize Event

    @events = Event.all
  end

  def show
    authorize event

    @new_comment = event.comments.build(params[:comment])
    @new_subscription = event.subscriptions.build(params[:subscription])
    @new_photo = event.photos.build(params[:photo])
  end

  def new
    @event = current_user.events.build

    authorize @event
  end

  def edit
    authorize event
  end

  def create
    @event = current_user.events.build(event_params)

    authorize @event

    if @event.save
      redirect_to @event, notice: I18n.t('controllers.events.created')
    else
      render :new
    end
  end

  def update
    authorize event

    respond_to do |format|
      if event.update(event_params)
        format.html { redirect_to event_url(event), notice: I18n.t('controllers.events.updated') }
        format.json { render :show, status: :ok, location: event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: event.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize event

    event.destroy

    respond_to do |format|
      format.html { redirect_to events_url, notice: I18n.t('controllers.events.destroyed') }
      format.json { head :no_content }
    end
  end

  private

  def event
    @event ||= Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :address, :datetime, :description, :pincode)
  end

  def password_guard!
    return true if event.pincode.blank?
    return true if signed_in? && current_user == event.user

    if params[:pincode].present? && event.pincode_valid?(params[:pincode])
      cookies.permanent["events_#{event.id}_pincode"] = params[:pincode]
    end

    pincode = cookies.permanent["events_#{event.id}_pincode"]

    unless @event.pincode_valid?(pincode)
      if params[:pincode].present?
        flash.now[:alert] = t('controllers.events.wrong_pincode')
      end
      render 'password_form'
    end
  end
end
