require 'spec_helper'
require './lib/dmv'
require './lib/facility'

RSpec.describe Dmv do
  before(:each) do
    @dmv = Dmv.new
    @facility_1 = Facility.new({name: 'DMV Tremont Branch', address: '2855 Tremont Place Suite 118 Denver CO 80205', phone: '(720) 865-4600'})
    @facility_2 = Facility.new({name: 'DMV Northeast Branch', address: '4685 Peoria Street Suite 101 Denver CO 80239', phone: '(720) 865-4600'})
    @facility_3 = Facility.new({name: 'DMV Northwest Branch', address: '3698 W. 44th Avenue Denver CO 80211', phone: '(720) 865-4600'})
    @cruz = Vehicle.new({vin: '123456789abcdefgh', year: 2012, make: 'Chevrolet', model: 'Cruz', engine: :ice})
    @bolt = Vehicle.new({vin: '987654321abcdefgh', year: 2019, make: 'Chevrolet', model: 'Bolt', engine: :ev})
    @camaro = Vehicle.new({vin: '1a2b3c4d5e6f', year: 1969, make: 'Chevrolet', model: 'Camaro', engine: :ice})
  end

  describe '#initialize' do
    it 'can initialize' do
      expect(@dmv).to be_an_instance_of(Dmv)
      expect(@dmv.facilities).to eq([])
    end
  end

  describe '#add facilities' do
    it 'can add available facilities' do
      expect(@dmv.facilities).to eq([])
      @dmv.add_facility(@facility_1)
      expect(@dmv.facilities).to eq([@facility_1])
    end
  end

  describe '#facilities_offering_service' do
    it 'can return list of facilities offering a specified Service' do
      @facility_1.add_service('New Drivers License')
      @facility_1.add_service('Renew Drivers License')
      @facility_2.add_service('New Drivers License')
      @facility_2.add_service('Road Test')
      @facility_2.add_service('Written Test')
      @facility_3.add_service('New Drivers License')
      @facility_3.add_service('Road Test')

      @dmv.add_facility(@facility_1)
      @dmv.add_facility(@facility_2)
      @dmv.add_facility(@facility_3)

      expect(@dmv.facilities_offering_service('Road Test')).to eq([@facility_2, @facility_3])
    end
  end

  describe '#register_vehicle' do
    it 'will not register if facility does not offer Vehicle Registration service' do 
      expect(@facility_1.register_vehicle(@cruz)).to eq "This facility does not offer that service"
    end

    it 'can track registration date' do
      @facility_1.add_service('Vehicle Registration')
      expect(@cruz.registration_date).to eq nil 

      @facility_1.register_vehicle(@cruz)

      todays_date = Date.today.strftime("%Y-%d-%m")
      expect(@cruz.registration_date).to eq todays_date
    end

    it 'can collect fees' do 
      @facility_1.add_service('Vehicle Registration')
      expect(@facility_1.collected_fees).to eq 0 
      
      @facility_1.register_vehicle(@cruz)
      expect(@facility_1.collected_fees).to eq 100

      @facility_1.register_vehicle(@camaro)
      expect(@facility_1.collected_fees).to eq 125 

      @facility_1.register_vehicle(@bolt)
      expect(@facility_1.collected_fees).to eq 325
    end
    
    it 'can #set_plate_type upon registration' do
      @facility_1.add_service('Vehicle Registration')

      expect(@cruz.plate_type).to eq nil
      @facility_1.register_vehicle(@cruz)
      expect(@cruz.plate_type).to eq :regular
      
      expect(@camaro.plate_type).to eq nil
      @facility_1.register_vehicle(@camaro)
      expect(@camaro.plate_type).to eq :antique
      
      expect(@bolt.plate_type).to eq nil
      @facility_1.register_vehicle(@bolt)
      expect(@bolt.plate_type).to eq :ev
    end
    
    it 'can add vehicle to the list of facility registered cars' do 
      @facility_1.add_service('Vehicle Registration')
      expect(@facility_1.registered_vehicles).to eq []
      
      @facility_1.register_vehicle(@cruz)
      expect(@facility_1.registered_vehicles).to eq [@cruz]
      
      @facility_1.register_vehicle(@camaro)
      expect(@facility_1.registered_vehicles).to eq [@cruz, @camaro]
      
      @facility_1.register_vehicle(@bolt)
      expect(@facility_1.registered_vehicles).to eq [@cruz, @camaro, @bolt]
    end
  end
end
