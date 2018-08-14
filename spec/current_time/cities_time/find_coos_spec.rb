# frozen_string_literal: true

path = %i[
  CurrentTime
  CitiesTime
  FindCoos
]

the_class = path.reduce(Object) { |memo, part| memo.const_get(part) }
RSpec.describe the_class do
  describe 'the class' do
    subject { described_class }

    it { is_expected.to respond_to(:new, :find_coos) }
  end

  describe '.new' do
    subject(:result) { described_class.new(city) }

    let(:city) { '' }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(described_class) }
    end
  end

  describe '.find_coos' do
    before { stub_request(:get, /geocode/).to_return(body: geocode_body) }

    subject(:result) { described_class.find_coos(city) }

    let(:geocode_body) { create('responses/geocode') }
    let(:city) { 'city' }

    describe 'result' do
      subject { result }

      context 'when city is empty' do
        let(:city) { '' }

        it { is_expected.to be_a(NilClass) }
      end

      context 'when response status is invalid' do
        before { stub_request(:get, /geocode/).to_return(status: 422) }

        it { is_expected.to be_a(NilClass) }
      end

      context 'when response body is invalid' do
        let(:geocode_body) { 'invalid' }

        it { is_expected.to be_a(NilClass) }
      end

      context 'when an error happens during response body processing' do
        let(:geocode_body) { {}.to_json }

        it { is_expected.to be_a(NilClass) }
      end

      context 'when response and processing go a\'ight' do
        it { is_expected.to be_an(Array) }

        it 'should have size of 2' do
          expect(result.size).to be == 2
        end

        describe 'elements' do
          it { is_expected.to all(be_a(String)) }

          it 'should be string representations of float values' do
            expect { result.map(&method(:Float)) }.not_to raise_error
          end
        end
      end
    end
  end
end
