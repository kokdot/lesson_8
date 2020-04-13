# frozen_string_literal: true

require_relative('van')

class CargoVan < Van
  def initialize(ability)
    @ability = ability.to_i
    @volume = 0
  end

  def free_volume
    @ability - @volume
  end

  def populated_volume
    @volume
  end

  def take_volume(volume)
    if @ability - @volume >= volume
      @volume += volume
    else
      puts 'Места в вагоне не достаточно.'
    end
  end
end
