class AttachmentsController < ApplicationController
  before_action :authenticate_user!, only: :destroy

  respond_to :js, only: :destroy

  def destroy
    @attachment = Attachment.find(params[:id])
    respond_with(@attachment.destroy) if current_user.author_of?(@attachment.attachable)
  end
end
