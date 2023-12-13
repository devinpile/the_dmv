class Facility
  attr_reader :name, :address, :phone, :services, :collected_fees, :registered_vehicles
  attr_accessor :plate_type

  def initialize(info)
    @name = info[:name]
    @address = info[:address]
    @phone = info[:phone]
    @services = []
    @registered_vehicles = []
    @collected_fees = 0 
  end

  def add_service(service)
    @services << service
  end

  def register_vehicle(vehicle)
    if !@services.include?('Vehicle Registration')
      "This facility does not offer that service"
    else
      set_registration_date(vehicle)
      set_plate_type(vehicle)
      collect_fees(vehicle)
      add_to_registered_vehicles(vehicle)
    end
  end
  
  def set_registration_date(vehicle)
    today = Date.today
    formatted_date = today.strftime("%Y-%d-%m")
    vehicle.registration_date = formatted_date
  end
  
  def set_plate_type(vehicle)
    if vehicle.antique?
      vehicle.plate_type = :antique
    elsif vehicle.electric_vehicle?
      vehicle.plate_type = :ev
    else
      vehicle.plate_type = :regular
    end
  end
  
  def collect_fees(vehicle)
    if vehicle.antique?
      @collected_fees += 25 
    elsif vehicle.electric_vehicle?
      @collected_fees += 200
    else
      @collected_fees += 100
    end
  end
  
  def add_to_registered_vehicles(vehicle)
    registered_vehicles << vehicle
  end
  
  
  
  def administer_written_test(registrant)
    if !@services.include?('Written Test')
      "This facility does not offer that service"
    elsif registrant.permit? == false 
      "Registrant does not have a permit"
    elsif registrant.age < 16 
      "Registrant is not old enough to take written test"
    else
      if registrant.permit? == true and registrant.age >= 16
        registrant.license_data[:written] = true
      end
    end
  end
  
  def administer_road_test(registrant)
    if !@services.include?('Road Test')
      "This facility does not offer that service"
    else
      if registrant.license_data[:written] == false 
        "Must pass written test first"
      else
        registrant.license_data[:license] = true
      end
    end
  end

  # def renew_license 
  #   #can only be renewed if registrant has passed road_test and earned a license
  # end
end
