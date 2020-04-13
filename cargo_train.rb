# frozen_string_literal: true

require_relative('train')
require_relative('instance_counter')

class CargoTrain < Train
  include InstanceCounter

  def initialize(number)
    super(number)
    register_instance
  end

  # def van_add(van)
  #   if @speed != 0
  #     puts 'Операции с вагонами можно производить только во время остановки поезда!'
  #   else
  #     if van.class == CargoVan
  #       @vans << van
  #     else
  #       puts 'Это грузовой поезд и он принимат только грузовые вагоны!'
  #     end
  #   end
  # end

  def van_add(van)
    if @speed != 0
      puts 'Операции с вагонами можно производить только во время остановки поезда!'
    elsif van.class == CargoVan
      @vans << van
    else
      puts 'Это грузовой поезд и он принимат только грузовые вагоны!'
    end
  end

  def van_remove(_van)
    if @speed != 0
      puts 'Операции с вагонами можно производить только во время остановки поезда!'
    else
      @vans.pop
    end
  end
end
