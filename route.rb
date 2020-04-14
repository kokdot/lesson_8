# frozen_string_literal: true

require_relative('instance_counter')
require_relative('validate')
# Класс Route (Маршрут):
# Имеет начальную и конечную станцию, а также список промежуточных станций.
# Начальная и конечная станции указываютсся при создании маршрута,
# а промежуточные могут добавляться между ними.
# Может добавлять промежуточную станцию в список
# Может удалять промежуточную станцию из списка
# Может выводить список всех станций по-порядку от начальной до конечной
class Route
  attr_reader :first, :last
  include Validate
  include InstanceCounter

  def initialize(first, last)
    @first = first
    @last = last
    validate!
    @intermediate_stations = []
    register_instance
  end

  def validate!
    if @first.class != Station && @last.class != Station
      raise 'Вы должны ввести первую и последнюю станцию нового маршрута'
    end
    raise 'Станции должны быть разными' if @first == @last
  end

  def add_station=(station)
    if @intermediate_stations.include?(station)
      puts "Станция #{station.name} уже была добавлена в этот маршрут ранее!"
    else
      @intermediate_stations << station
      puts "Станция #{station.name} добавлена"
    end
  end

  def remove_station=(station)
    if @intermediate_stations.include?(station)
      @intermediate_stations.delete(station)
      puts "Станция #{station.name} удалена"
    else
      puts "Станции #{station.name} нет на данном маршруте"
    end
  end

  def stations
    [@first, @intermediate_stations, @last].flatten
  end
end
