require './lib/vehicle'
require './lib/vehicle_factory'
require './lib/dmv_data_service'

RSpec.describe VehicleFactory do 
    before do 
        @factory = VehicleFactory.new 
        @wa_ev_registrations = DmvDataService.new.wa_ev_registrations
    end

    it 'exists' do 
        expect(@factory).to be_an_instance_of VehicleFactory 
    end 

    it 'can access the api data for electrical vehicles in washington' do 
        expect(@wa_ev_registrations).to be_an Array 
        expect(@wa_ev_registrations.first).to be_a Hash 
        expect(@wa_ev_registrations.count).to eq 1000
        expect(@wa_ev_registrations.first.keys.count).to eq 33
    end 

    it 'reformats wa_ev_registrations JSON' do 
        expect(@factory.create_vehicles(@wa_ev_registrations)).to be_an Array 
        expect(@factory.create_vehicles(@wa_ev_registrations).first).to be_a Hash
        expect(@factory.create_vehicles(@wa_ev_registrations).count).to eq 1000
        expect(@factory.create_vehicles(@wa_ev_registrations).first.count).to eq 5

        expect(@factory.create_vehicles(@wa_ev_registrations).first.keys.include?(:make)).to be true
        expect(@factory.create_vehicles(@wa_ev_registrations).first.keys.include?(:model)).to be true
        expect(@factory.create_vehicles(@wa_ev_registrations).first.keys.include?(:year)).to be true
        expect(@factory.create_vehicles(@wa_ev_registrations).first.keys.include?(:vin)).to be true
        expect(@factory.create_vehicles(@wa_ev_registrations).first.keys.include?(:engine)).to be true
        
        expect(@factory.create_vehicles(@wa_ev_registrations).first[:make]).to eq "TESLA"
        expect(@factory.create_vehicles(@wa_ev_registrations).first[:model]).to eq "Model 3"
        expect(@factory.create_vehicles(@wa_ev_registrations).first[:year]).to eq "2020"
        expect(@factory.create_vehicles(@wa_ev_registrations).first[:vin]).to eq "5YJ3E1EC6L"
        expect(@factory.create_vehicles(@wa_ev_registrations).first[:engine]).to eq :ev
    end
end 