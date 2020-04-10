require 'test_helper'

class BasketTest < ActiveSupport::TestCase
  self.use_transactional_tests = false

  test 'basket complete only once' do
    basket = Basket.create!(state: 'new')
    basket.complete!

    assert_raises(Basket::AlreadyCompletedError) do
      basket.complete!
    end
    assert_equal(basket.reload.state, 'completed')
  end

  def complete_synced_execution(basket)
    debug = true
    process_1, process_2 = 2.times.map do
      ForkBreak::Process.new(debug) do |breakpoints|
        breakpoints << :before_lock
        basket.with_lock do
          basket.complete!
        end
      end
    end

    timeout = 5
    process_1.run_until(:after_read).wait

    # process_2 can't wait for read since it will block
    process_2.run_until(:before_lock).wait
    process_2.run_until(:after_read) && sleep(0.1)

    process_1.finish.wait
    process_2.finish.wait(timeout: timeout)
  end

  test 'basket complete only once concurrency' do
    basket = Basket.create!(state: 'new')

    assert_raises(Basket::AlreadyCompletedError) do
      complete_synced_execution(basket)
    end
    assert_equal(basket.reload.state, 'completed')
  end
end
