class VehicleFactory
    def initialize 
    end 

    def create_vehicles(state_registrations)
        created_vehicles = []
        state_registrations.map do |vehicle| 
            vehicle_hash = {
                :make => nil,
                :model => nil,
                :year => nil,
                :vin => nil,
                :engine => :ev
            }
            vehicle_hash[:make] = vehicle[:make]
            vehicle_hash[:model] = vehicle[:model]
            vehicle_hash[:year] = vehicle[:model_year]
            vehicle_hash[:vin] = vehicle[:vin_1_10]

            created_vehicles << vehicle_hash
        end
        created_vehicles
    end
end