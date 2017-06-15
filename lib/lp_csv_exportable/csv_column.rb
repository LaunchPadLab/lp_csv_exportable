module LpCsvExportable
  class CSVColumn
    attr_reader :header, :model_method, :model_methods, :type

    def initialize(args = {})
      @header = args[:header]
      @model_method = args[:model_method]
      @model_methods = args[:model_methods]
      @type = args.fetch(:type, :string)
      after_init(args)
    end

    def format(result)
      return send(type, result) if respond_to?(type)
      result
    end

    private

    def after_init(args = {})
      # hook for subclasses
    end
  end
end