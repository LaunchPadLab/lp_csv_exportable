module LpCSVExportable
  module CanExportAsCSV
    def initialize(args = {})
      after_init(args)
    end

    def to_csv
      CSV.generate do |csv|
        csv << headers
        data_matrix.each do |row|
          csv << row
        end
      end
    end

    private

    # API METHODS

    def after_init(args = {})
      # hook
    end

    def columns
      raise "columns method is required by CanExportAsCSV for #{self.class.name}"
    end

    def collection
      raise "collection method is required by CanExportAsCSV for #{self.class.name}"
    end

    # DEFAULT BEHAVIOR

    def headers
      columns.map(&:header)
    end

    def data_matrix
      # array of arrays
      # i.e. rows 2+ of CSV
      collection.map do |obj|
        columns.map do |column|
          column.format(retrieve_value(obj, column))
        end
      end
    end

    def retrieve_value(obj, column)
      # only one method to retrieve value
      return call_model_method(column.model_method, obj) if column.model_method.present?
      # chain methods to retrieve value (jsonb store)
      # i.e. employee.market_data.min
      column.model_methods.inject(obj) do |memo, model_method|
        call_model_method(model_method, memo)
      end
    end

    def call_model_method(model_method, memo)
      if respond_to?(model_method)
        send(model_method, memo)
      else
        memo.try(:send, model_method)
      end
    end
  end
end