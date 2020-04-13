# frozen_string_literal: true

require_relative('van')

class PassengerVan < Van
  def initialize(capacity)
    @capacity = capacity
    @busy = 0
  end

  def free_places
    @capacity - @busy
  end

  def populated_places
    @busy
  end

  def take_place
    if @capacity > @busy
      @busy += 1
    else
      puts 'Мест нет'
    end
  end
end
