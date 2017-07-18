class TestExporter
  include LpCSVExportable::CanExportAsCSV

  column 'First Name', model_method: :first_name
  column :last_name
  column :shorthand
  column 'Joined Name', model_methods: %i[names join]

  def shorthand(obj)
    'shorthand'
  end

  def names(obj)
    [obj.first_name, obj.last_name]
  end
end
