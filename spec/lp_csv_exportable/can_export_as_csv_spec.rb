require 'spec_helper'
require 'pry'

RSpec.describe LpCSVExportable::CanExportAsCSV do
  let(:collection) { [TestUser.new, TestUser.new] }
  let(:exporter) { TestExporter.new }

  before(:each) do
    exporter.collection = collection
  end

  describe 'to_csv' do
    subject { exporter.send(:to_csv) }

    it 'should return CSV formatted headers and data' do
      target = "First Name,last_name,shorthand,Joined Name\nRyan,Francis,shorthand,RyanFrancis\nRyan,Francis,shorthand,RyanFrancis\n"
      expect(subject).to eq(target)
    end
  end

  describe 'data_matrix' do
    subject { exporter.send(:data_matrix) }

    it 'returns the right data' do
      target = ["Ryan", "Francis", "shorthand", "RyanFrancis"]
      expect(subject).to eq([target, target])
    end
  end

  describe 'headers' do
    subject { exporter.send(:headers) }

    it 'returns the right headers' do
      target = ['First Name', 'last_name', 'shorthand', 'Joined Name']
      expect(subject).to eq(target)
    end
  end
end
