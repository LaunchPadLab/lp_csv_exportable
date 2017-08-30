module LpCSVExportable
  module CanExportAsCSV
    attr_accessor :collection, :column_class

    def self.included(base)
      base.extend ClassMethods
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

    def column_class
      @column_class ||= CSVColumn
    end

    def columns
      self.class.columns_hashes.map do |hash|
        column_class.new(hash)
      end
    end

    def headers
      columns.map { |c| c.header.try(:to_s) }
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
        memo.try(model_method)
      end
    end

    def collection
      raise 'collection has not been set on the class' unless @collection
      raise 'collection must respond to map method' unless @collection.respond_to?(:map)
      @collection
    end

    # Configuration...
    module ClassMethods
      def column(header, options = {})
        column_settings = { header: header }
        column_settings[:model_method] = header if header.is_a?(Symbol) && options[:model_methods].nil?
        columns_hashes << column_settings.merge(options)
      end

      def columns_hashes
        @columns_hashes ||= []
      end
    end
  end
end