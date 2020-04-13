# frozen_string_literal: true

require_relative('station')
require_relative('route')
# require_relative('train')
# require_relative('van')
require_relative('cargo_train')
require_relative('passenger_train')
require_relative('passenger_van')
require_relative('cargo_van')
require_relative('main')

class RailsRoad
  attr_accessor :stations, :trains, :routes
  attr_reader :main
  def initialize
    @stations = {}
    @trains = {}
    @routes = {}
    @main = Main.new(stations, trains, routes)
  end

  def seed
    st1 = Station.new('Station1')
    @stations[st1.name.to_sym] = st1
    st2 = Station.new('Station2')
    @stations[st2.name.to_sym] = st2
    st3 = Station.new('Station3')
    @stations[st3.name.to_sym] = st3
    st4 = Station.new('Station4')
    @stations[st4.name.to_sym] = st4

    st5 = Station.new('Station5')
    @stations[st5.name.to_sym] = st5
    st6 = Station.new('Station6')
    @stations[st6.name.to_sym] = st6
    st7 = Station.new('Station7')
    @stations[st7.name.to_sym] = st7
    st8 = Station.new('Station8')
    @stations[st8.name.to_sym] = st8

    rt1 = Route.new(st1, st4)
    rt1.add_station = st2
    rt1.add_station = st3
    @routes["#{rt1.first.name}_#{rt1.last.name}"] = rt1

    rt2 = Route.new(st5, st8)
    rt2.add_station = st7
    rt2.add_station = st6
    @routes["#{rt2.first.name}_#{rt2.last.name}"] = rt2

    train1 = PassengerTrain.new(10_586)
    @trains[train1.number] = train1
    train2 = CargoTrain.new(10_685)
    @trains[train2.number] = train2
    12.times do
      train1.van_add(PassengerVan.new(40))
    end
    train1.handler { |van| rand(40).times { van.take_place } }
    20.times do
      train2.van_add(CargoVan.new(60))
    end
    train2.handler { |van| van.take_volume(rand(60)) }
    train1.route = rt1
    train1.route.first.get_train(train1)
    train2.route = rt2
    train2.route.first.get_train(train2)
    rand(4).times { train1.move_ahead }
    rand(4).times { train2.move_ahead }
  end
end
