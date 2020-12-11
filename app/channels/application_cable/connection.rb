module ApplicationCable
  class Connection < ActionCable::Connection::Base
    # このcurrent_userはActionCableのサーバー側でしか使えない
    # identified_by :current_user

    # def connect 
    #   reject_unauthorized_connection unless find_verified_user
    # end

    # private

    # def find_verified_user
    #   self.current_user = env['warden'].user
    # end
  end
end