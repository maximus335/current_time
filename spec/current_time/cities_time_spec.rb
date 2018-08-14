# frozen_string_literal: true

RSpec.describe CurrentTime::CitiesTime do
  describe 'class' do
    subject { described_class }

    it { is_expected.to respond_to(:new, :cities_time) }
  end

  describe '.new' do
    subject(:result) { described_class.new(cities) }

    let(:cities) { ['city'] }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(described_class) }
    end
  end

  describe '.cities_time' do
    before { stub_request(:get, /geocode/).to_return(body: geocode_body) }

    subject(:result) { described_class.cities_time(cities) }

    let(:cities) { ['moscow'] }
    let(:geocode_body) { create('responses/geocode', lat: 37.62, lng: 55.75) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_truthy }

      context 'when city time not found' do
        let!(:geocode_body) { create('responses/geocode', lat: 0, lng: 0) }

        it { expect(subject[cities.first]).to eq('Not found') }
      end
    end
  end
end
