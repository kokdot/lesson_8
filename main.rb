# frozen_string_literal: true

require_relative('station')
require_relative('route')
# require_relative('train')
# require_relative('van')
require_relative('cargo_train')
require_relative('passenger_train')
require_relative('passenger_van')
require_relative('cargo_van')

# p stations
# Создать программу в файле main.rb, которая будет позволять пользователю через текстовый интерфейс делать следующее:
#      - Создавать станции
#      - Создавать поезда
#      - Создавать маршруты и управлять станциями в нем (добавлять, удалять)
#      - Назначать маршрут поезду
#      - Добавлять вагоны к поезду
#      - Отцеплять вагоны от поезда
#      - Перемещать поезд по маршруту вперед и назад
#      - Просматривать список станций и список поездов на станции
class Main
  def initialize(stations, trains, routes)
    @stations = stations
    @trains = trains
    @routes = routes
  end

  def report
    @stations.each do |name, st|
      puts "На станции #{name} находятся поезда: "
      st.handler do |train|
        puts train.number.to_s
      end
    end
    @trains.each do |_number, train|
      puts "Поезд #{train.number} тип #{train.class}:"
      i = 1
      train.handler do |van|
        puts "Это вагон номер #{i}"
        i += 1
        if train.class == CargoTrain
          puts "Занятый обЪем: #{van.populated_volume}, Свободный обЪем: #{van.free_volume}"
        else
          puts "Занято мест: #{van.populated_places}, Свободных мест: #{van.free_places}"
        end
      end
    end
  end

  def start
    puts 'Добро Пожаловать на нашу Железную дорогу! '
    loop do
      puts 'Выберите пункт меню для выполнения дальнейших действий: '
      puts '1     - Станции (создать, список станций, поезда на станции)'
      puts '2     - Маршрут (создать и управлять станциями в нем)'
      puts '3     - Управление поездом'
      puts '4     - Выйти из данного меню'
      menu = gets.chomp.to_i
      # p menu
      # next if menu < 1 || menu > 4
      case menu
      when 4 # "4     - Выйти из данного меню"
        break
      when 1 # "1     - Станции (создать, список станций, поезда на станции)"
        loop do
          puts 'Выберите пункт меню для выполнения дальнейших действий: '
          puts '1     - Создать станцию'
          puts '2     - Список станций'
          puts '3     - Поезда на станции'
          puts '4     - Выйти из данного меню'
          sub_menu = gets.chomp.to_i
          case sub_menu
          when 4 # "4     - Выйти из данного меню"
            break
          when 1 # "1     - Создать станцию"
            create_staion
          when 2 # "2     - Список станций"
            list_stations
          when 3 # "3     - Поезда на станции"
            list_trains_on_station
          else
            next
          end
        end
      when 2 # "2     - Создать маршрут и управлять станциями в нем (добавлять, удалять)"
        loop do
          puts 'Выберите пункт меню для выполнения дальнейших действий: '
          puts '1     - Создать маршрут'
          puts '4     - Показать маршруты'
          puts '2     - Выбрать маршрут для редактирования'
          puts '3     - Выйти из данного меню'
          sub_menu = gets.chomp.to_i
          case sub_menu
          when 3 # "3     - Выйти из данного меню"
            break
          when 4 # "1     - Показать маршруты"
            list_routes
          when 1 # "1     - Создать маршрут"
            create_route
          when 2 # "2     - Выбрать маршрут"
            action_route
          else
            next
          end
        end
      when 3 # "3     - Управление поездом"
        loop do
          puts 'Выберите пункт меню для выполнения дальнейших действий: '
          puts '1     - Создать новый пассажирский поезд: '
          puts '2     - Создать новый грузовой поезд: '
          puts '3     - Действия с  поездом: '
          puts '5     - Показать поезда: '
          puts '4     - Выйти из данного меню'
          sub_menu = gets.chomp.to_i
          case sub_menu
          when 4 # "3     - Выйти из данного меню"
            break
          when 5 # "5     - Показать поезда: "
            list_trains
          when 1 # "1     - Создать новый пассажирский поезд: "
            begin
              create_pass_train
            rescue RuntimeError => e
              puts e.message
              retry
            end
          when 2 # "1     - Создать новый грузовой поезд: "
            begin
              create_cargo_train
            rescue RuntimeError => e
              puts e.message
              retry
            end
          when 3 # "3     - Действия с  поездом: "
            action_train
          end
        end
      else
        next
      end
    end
  end

  private

  def create_staion
    puts 'Введите название станции: '
    name = gets.chomp
    p @stations
    @stations[name.to_sym] = Station.new(name)
  end

  def list_trains_on_station
    puts 'Введите название станции: '
    name = gets.chomp.to_sym
    if @stations[name].nil?
      puts 'Такой станции не существует!'
    else
      arr_trains = []
      station = @stations[name]
      # p station
      # p "station"
      @trains.each do |number, train|
        # p train.station
        # p "train.station"
        arr_trains << number if train.station == station
      end
      # p arr_trains
      # p "arr_trains"
      if arr_trains.empty?
        puts 'На данной станции нет поездов'
      else
        puts 'Поезда на станции: '
        puts arr_trains
      end
    end
  end

  def list_routes
    @routes.each do |name, route|
      puts name
      p route
    end
  end

  def list_stations
    @stations.each { |name, _st| puts name }
  end

  def create_route
    puts 'Введите первую станцию нового маршрута'
    first = gets.chomp
    if @stations[first.to_sym]
      first = @stations[first.to_sym]
      puts 'Такая станция существует'
    else
      puts 'Такой станции нет'
    end
    puts 'Введите последнюю станцию нового маршрута'
    last = gets.chomp
    if @stations[last.to_sym]
      last = @stations[last.to_sym]
      puts 'Такая станция существует'
    else
      puts 'Такой станции нет'
    end
    route = Route.new(first, last)
    # p route
    rote_name = route.first.name + '_' + route.last.name
    # p route_name
    @routes[rote_name.to_sym] = route
    # p route_name
    puts "Маршрут #{route.first.name}_#{route.last.name} создан"
  end

  def action_route
    puts 'Введите первую станцию маршрута'
    first = gets.chomp
    puts 'Введите последнюю станцию маршрута'
    last = gets.chomp
    route = @routes["#{first}_#{last}"]
    # p route
    p first + '_' + last
    if route
      loop do
        puts 'Выберите пункт меню для выполнения дальнейших действий: '
        puts '1     - Добавить станцию'
        puts '2     - Удалить станцию'
        puts '3     - Выйти из данного меню'
        puts '4     - Показать станции маршрута'
        sub_sub_menu = gets.chomp.to_i
        case sub_sub_menu
        when 3 # "3     - Выйти из данного меню"
          break
        when 4
          route.stations.each { |st| puts st.name }
        when 1 # "1     - Добавить станцию"
          add_station_to_root
        when 2 # "2     - Удалить станцию"
          remove_station_from_root
        else
          next
        end
      end
    else
      puts 'Такого маршрута не существует!'
    end
  end

  def list_trains
    @trains.each do |name, train|
      puts name
      p train
    end
  end

  def create_pass_train
    puts 'Введите номер поезда: '
    number = gets.chomp.to_i
    if @trains[number]
      puts 'Поезд с таким номером уже существует!'
    else
      @trains[number] = PassengerTrain.new(number)
    end
  end

  def create_cargo_train
    puts 'Введите номер поезда: '
    number = gets.chomp.to_i
    if @trains[number]
      puts 'Поезд с таким номером уже существует!'
    else
      @trains[number] = CargoTrain.new(number)
    end
  end

  def action_train
    puts 'Введите номер поезда'
    number = gets.chomp.to_i
    train = @trains[number]
    if train
      puts "Это #{train.class} поезд у него #{train.vans.size} вагонов"
      loop do
        puts 'Выберите пункт меню для выполнения дальнейших действий: '
        puts '1     - Добавить вагоны к поезду'
        puts '2     - Отцепить вагоны от поезда'
        puts '6     - Назначать маршрут поезду'
        puts '10    - Показать маршрут поезда'
        puts '7     - Показать текущую станцию'
        puts '8     - Показать следующую станцию'
        puts '9     - Показать предыдущую станцию'
        puts '3     - Переместить поезд по маршруту вперед'
        puts '4     - Переместить поезд по маршруту назад'
        puts '5     - Выйти из данного меню'
        sub_sub_menu = gets.chomp.to_i
        case sub_sub_menu
        when 5 # "3     - Выйти из данного меню"
          break
        when 10
          if train.route
            p train.route
          else
            puts 'У Вас нет маршрута'
          end
        when 7
          puts train.station.name if train.station
        when 8
          puts train.station_next.name if train.station_next
        when 9
          puts train.station_before.name if train.station_before
        when 6 # "6     - Назначать маршрут поезду"
          appoint_root_to_train
        when 1 # "1     - Добавить вагоны к поезду"
          add_van_to_train
        when 2 # "2     - Отцепить вагоны от поезда"
          uhhook_van_from_train
        when 3 # "3     - Переместить поезд по маршруту вперед"
          train.move_ahead
        when 4 # "4     - Переместить поезд по маршруту назад"
          train.move_back
        else
          next
        end
      end
    else
      puts 'Поезда с таким номером не существует'
      # next
    end
  end

  def appoint_root_to_train
    puts 'Введите первую станцию маршрута'
    first = gets.chomp
    puts 'Введите последнюю станцию маршрута'
    last = gets.chomp
    route = @routes["#{first}_#{last}"]
    # p route
    # p first + "_" + last
    if route
      train.route = route
    else
      puts 'Такого маршрута нет'
      # next
    end
  end

  def add_van_to_train
    puts "Это #{train.class} поезд у него #{train.vans.size} вагонов"
    puts 'Сколько вагонов вы хотите добавить этому поезду: '
    quan_vans = gets.chomp.to_i
    if quan_vans < 1
      puts 'Данные введены не корректно!'
      # next
    elsif train.class == PassengerTrain
      quan_vans.times do
        train.vans << PassengerVan.new
      end
    else
      quan_vans.times do
        train.vans << CargoVan.new
      end
    end
    puts "Это #{train.number} поезд у него #{train.vans.size} вагонов"
  end

  def uhhook_van_from_train
    puts "Это #{train.class} поезд"
    puts 'Сколько вагонов вы хотите отцепить от этого поезда: '
    quan_vans = gets.chomp.to_i
    quan_vans1 = train.vans.size
    if quan_vans < 1
      puts 'Данные введены не корректно!'
      # next
    elsif quan_vans1 < quan_vans
      puts "У этого поезда только #{quan_vans1} вагонов!"
    else
      train.vans = train.vans[0..- quan_vans]
      puts "Это #{train.number} поезд у него #{train.vans.size} вагонов"
    end
  end

  def add_station_to_root
    puts 'Введите название станции, которую Вы хотите добавить в маршрут: '
    name = gets.chomp
    station = @stations[name.to_sym]
    if station
      route.add_station = station
    else
      puts 'Такой станции не существует!'
    end
  end

  def remove_station_from_root
    puts 'Введите название станции, которую Вы хотите удалять из маршрута: '
    name = gets.chomp
    station = @stations[name.to_sym]
    if station
      route.remove_station = station
    else
      puts 'Такой станции не существует!'
    end
  end
end
