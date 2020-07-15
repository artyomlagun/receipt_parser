require 'singleton'

class NalogUsersService
  include Singleton

  attr_accessor :users, :current

  def initialize
    @users = ReceiptParser.users_nalog_ru[:users]
    @current = 0
  end

  def next
    user = users[@current]
    @current += 1
    @current = 0 if @current == users.length
    user
  end
end
