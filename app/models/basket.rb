class Basket < ApplicationRecord
  class AlreadyCompletedError < StandardError; end

  include ForkBreak::Breakpoints

  def complete!
    raise AlreadyCompletedError if state == 'completed'
    breakpoints << :after_read
    update!(state: 'completed')
  end
end
