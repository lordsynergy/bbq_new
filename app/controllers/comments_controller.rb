class CommentsController < ApplicationController
  before_action :set_event, only: %i[index create destroy]
  before_action :set_comment, only: %i[destroy]

  def index
    redirect_to @event
  end

  def create
    @new_comment = @event.comments.build(comment_params)
    authorize @new_comment
    @new_comment.user = current_user

    if @new_comment.save
      notify_subscribers(@event, @new_comment)

      redirect_to @event, notice: I18n.t('controllers.comments.created')
    else
      render 'events/show', alert: I18n.t('controllers.comments.error')
    end
  end

  def destroy
    authorize @comment

    @comment.destroy!

    redirect_to @event, notice: I18n.t('controllers.comments.destroyed')
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_comment
    @comment = @event.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, :user_name)
  end

  def notify_subscribers(event, comment)
    all_emails = (event.subscriptions.map(&:user_email) + [event.user.email]).uniq
    all_emails.delete(comment.user&.email)

    all_emails.each do |mail|
      EventMailer.comment(comment, mail).deliver_now
    end
  end
end
