require 'rails_helper'

describe Event do
  describe 'validation' do
    specify { expect(build(:event)).to be_valid }
    specify { expect(build(:event, name: '')).not_to be_valid }
    specify { expect(build(:event, started_at: nil)).not_to be_valid }
    specify { expect(build(:event, ended_at: nil)).not_to be_valid }
    specify { expect(build(:event, started_at: '2015-01-07 17:00:00 +0900', ended_at: '2015-01-07 18:00:00 +0900')).to be_valid }
    specify { expect(build(:event, started_at: '2015-01-07 17:00:00 +0900', ended_at: '2015-01-07 17:00:00 +0900')).not_to be_valid }
    specify { expect(build(:event, started_at: '2015-01-07 18:00:00 +0900', ended_at: '2015-01-07 17:00:00 +0900')).not_to be_valid }

    describe 'term must not cover other one.' do
      before do
        @event = create(:event, name: 'Event name', started_at: '2015-01-16 17:00:00 +0900', ended_at: '2015-01-27 23:59:59 +0900')
      end
      specify { expect(@event).to be_valid }
      specify { expect(build(:event, started_at: '2015-01-07 17:00:00 +0900', ended_at: '2015-01-14 23:59:59 +0900')).to be_valid }
      specify { expect(build(:event, started_at: '2015-01-07 17:00:00 +0900', ended_at: '2015-02-08 23:59:59 +0900')).not_to be_valid }
      specify { expect(build(:event, started_at: '2015-01-07 17:00:00 +0900', ended_at: '2015-01-17 00:00:00 +0900')).not_to be_valid }
      specify { expect(build(:event, started_at: '2015-01-17 00:00:00 +0900', ended_at: '2015-01-25 00:00:00 +0900')).not_to be_valid }
      specify { expect(build(:event, started_at: '2015-01-25 18:00:00 +0900', ended_at: '2015-02-08 23:59:59 +0900')).not_to be_valid }
      specify { expect(build(:event, started_at: '2015-01-29 17:00:00 +0900', ended_at: '2015-02-08 23:59:59 +0900')).to be_valid }
    end
  end

  describe 'find by the time' do
    before do
      @event = create(:event, name: 'Event name', started_at: '2015-01-16 17:00:00 +0900', ended_at: '2015-01-27 23:59:59 +0900')
    end

    context 'not specify target time' do
      subject { Event.at }
      around(:example) { |ex| Timecop.freeze(now) { ex.run } }

      context 'when there is no event for now' do
        let(:now) { '2015-12-10 10:00:00 +0900' }
        it { should be_nil }
      end
      context 'when now is event term' do
        let(:now) { '2015-01-16 17:00:00 +0900' }
        it { should eq @event }
      end
    end
  end
end
