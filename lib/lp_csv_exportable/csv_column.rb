module LpCSVExportable
  class CSVColumn
    attr_reader :header, :default_value, :model_method, :model_methods, :type

    def initialize(args = {})
      @header = args[:header]
      @model_method = args[:model_method]
      @model_methods = args[:model_methods]
      @type = args.fetch(:type, :string)
      @default_value = args.fetch(:default_value, '')
      after_init(args)
    end

    def format(result)
      return formatted_result(result) if respond_to?(type)
      return default_value if use_default?(result)
      result
    end

    private

    def after_init(args = {})
      # hook for subclasses
    end

    def use_default?(result)
      default_value.present? && result.nil?
    end

    def formatted_result(result)
      return default_value if use_default?(result)
      send(type, result)
    end
  end
end