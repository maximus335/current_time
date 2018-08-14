# frozen_string_literal: true

RSpec.describe CurrentTime::WebServer do
  describe 'class' do
    subject { described_class }

    it { is_expected.to respond_to(:new, :run!) }
  end

  describe '.new' do
    subject(:result) { described_class.new }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(described_class) }
    end
  end
end
