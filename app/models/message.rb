class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :message, presence: true

  def template
    ApplicationController.renderer.render partial: 'messages/message', locals: { message: self }
    # ApplicationController.render_with_signed_in_user(self.user, 'messages/message', locals: { message: self })
  end
end
