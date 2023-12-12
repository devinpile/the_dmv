require './lib/registrant'
require './lib/facility'

RSpec.describe Registrant do 
    before do 
        @registrant_1 = Registrant.new('Bruce', 18, true )
        @registrant_2 = Registrant.new('Penny', 16 )
        @registrant_3 = Registrant.new('Tucker', 15 )
        @facility_1 = Facility.new({name: 'DMV Tremont Branch', address: '2855 Tremont Place Suite 118 Denver CO 80205', phone: '(720) 865-4600'})
        @facility_2 = Facility.new({name: 'DMV Northeast Branch', address: '4685 Peoria Street Suite 101 Denver CO 80239', phone: '(720) 865-4600'})
    end 

    describe '#written_test' do
        it 'can return #license_data' do 
            expected_hash = {
                :written => false,
                :license => false,
                :renewed =>false
            }
            expect(@registrant_1.license_data).to eq expected_hash
        end

        it 'can see if registrant has a #permit?' do 
            expect(@registrant_1.permit?).to eq true 
        end

        it 'will not #administer_written_test is facility does not provied written test service' do
            expect(@facility_1.administer_written_test(@registrant_1)).to eq "This facility does not offer that service"
        end
        
        it 'will change written status to true if facility offers the service, registrant is of age and has permit' do 
            @facility_1.add_service('Written Test')
            @facility_1.administer_written_test(@registrant_1)
            expected = {
                :written => true,
                :license => false,
                :renewed => false
            }
            expect(@registrant_1.license_data).to eq expected
        end
    end
end