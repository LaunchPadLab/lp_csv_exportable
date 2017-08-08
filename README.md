LpCSVExportable
===

What is LpCSVExportable?
---

LpCSVExportable makes it really easy to export your data into a CSV. It is easy to implement, but also highly extendable.

Installation
---

```ruby
gem 'lp_csv_exportable'
```

```
bundle
```

Basic Usage
---

Create a class that includes the module `LpCSVExportable::CanExportAsCSV`

```
class ExportUsers
  include LpCSVExportable::CanExportAsCSV

  column 'First Name', model_method: :first_name
  column 'Last Name', model_method: :last_name
  column 'Email', model_method: :email
  column 'Role', model_methods: %i[membership name]
end
```

And then to export, simply instantiate your class and pass in your `collection`, then call `to_csv`. For example, in a Rails controller action, you would do:

```
  def index
    users = User.all

    respond_to do |format|
      format.csv do
        export = ExportUsers.new
        export.collection = users
        send_data export.to_csv
      end
    end
  end
```

If you would like to default a column to a specific value if the model method returns `nil`, use the `default_value` key when defining the column.

```
column 'Email', model_method: :email, default_value: 'N/A'
```

TODO
---

- Readme: More complex examples
- Readme: Ways to extend