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

    describe '#license_data' do
        it 'can return #license_data information' do 
            expected_hash = {
                :written => false,
                :license => false,
                :renewed =>false
            }
            expect(@registrant_1.license_data).to eq expected_hash
        end
    end

    describe 'permits' do 
        it 'can see if registrant has a #permit?' do 
            expect(@registrant_1.permit?).to eq true 
        end
        
        it 'can have a registrant #earn_permit' do 
            expect(@registrant_2.permit?).to eq false 
            
            @registrant_2.earn_permit 
            
            expect(@registrant_2.permit?).to eq true
        end
    end

    describe 'written test' do
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
        
        context 'sad paths' do 
            it 'will not #administer_written_test is facility does not provied written test service' do
                expect(@facility_1.administer_written_test(@registrant_1)).to eq "This facility does not offer that service"
            end
        
            it 'will not #administer_written_test if the registrant does not have a permit' do 
                @facility_1.add_service('Written Test')
                expect(@facility_1.administer_written_test(@registrant_2)).to eq "Registrant does not have a permit"
                
                @registrant_2.earn_permit
                @facility_1.administer_written_test(@registrant_2)
                expected = {
                    :written => true,
                    :license => false,
                    :renewed => false
                }
                expect(@registrant_2.license_data).to eq expected
            end
    
            it 'will not #administer_written_test if the registrant is not at least 16 years of age' do 
                @facility_1.add_service('Written Test')
                expect(@registrant_3.age).to eq 15
                expect(@registrant_3.permit?).to eq false 
                expect(@facility_1.administer_written_test(@registrant_3)).to eq "Registrant does not have a permit"
                @registrant_3.earn_permit
                
                expect(@facility_1.administer_written_test(@registrant_3)).to eq "Registrant is not old enough to take written test"
                expected = {
                    :written => false,
                    :license => false,
                    :renewed => false
                }
                expect(@registrant_3.license_data).to eq expected
            end
        end
    end

    describe 'road test' do
        
    end
end