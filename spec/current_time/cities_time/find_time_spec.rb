# frozen_string_literal: true

path = %i[
  CurrentTime
  CitiesTime
  FindTime
]

the_class = path.reduce(Object) { |memo, part| memo.const_get(part) }
RSpec.describe the_class do
  describe 'the class' do
    subject { described_class }

    it { is_expected.to respond_to(:new, :find_time) }
  end

  describe '.new' do
    subject(:result) { described_class.new(coos) }

    let(:coos) { [] }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(described_class) }
    end
  end

  describe '.find_time' do
    subject(:result) { described_class.find_time(coos) }

    let(:coos) { ['37.622504', '55.753215'] }

    describe 'result' do
      subject { result }

      context 'when coos is a nil' do
        let(:coos) { nil }

        it { is_expected.to eq('Not found') }
      end

      context 'when coos is a Moscow' do
        let(:coos) { ['37.622504', '55.753215'] }

        before do
          allow(Time).to receive(:now).and_return(Time.new(2018, 8, 1, 12, 0, 0))
        end

        it { is_expected.to eq('01-08-2018 12:00') }
      end

      context 'when coos invalid' do
        let(:coos) { ['invalid', 'invalid'] }

        it { is_expected.to eq('Not found') }
      end
    end
  end
end
