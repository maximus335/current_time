# frozen_string_literal: true

RSpec.describe CurrentTime::PrepareResponse do
  describe 'class' do
    subject { described_class }

    it { is_expected.to respond_to(:new, :response) }
  end

  describe '.new' do
    subject(:result) { described_class.new(params) }

    let(:params) { [] }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(described_class) }
    end
  end

  describe '.response' do
    before { stub_request(:get, /geocode/).to_return(body: geocode_body) }

    subject(:result) { described_class.response(params) }

    let(:params) { ['moscow'] }
    let(:geocode_body) { create('responses/geocode', lat: 37.62, lng: 55.75) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_truthy }
      it { expect(subject).to be_a(Array) }

      context 'when params is a blank' do
        let(:params) { [] }

        before do
          allow(Time).to receive(:now).and_return(Time.new(2018, 8, 1, 12, 0, 0))
        end

        it { expect(subject.first).to eq('UTC: 01-08-2018 12:00') }
      end
    end
  end
end
