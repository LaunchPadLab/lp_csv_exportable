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

```ruby
class ExportUsers
  include LpCSVExportable::CanExportAsCSV

  column :first_name
  column :last_name
  column :email
  column :role, model_methods: %i[membership name]
end
```

And then to export, simply instantiate your class and pass in your `collection`, then call `to_csv`. For example, in a Rails controller action, you would do:

```ruby
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

The Column Method
---

Every column in a CSV contains (1) a header, and (2) data for each row. The first argument to our `column` method is the header name. The second argument is an `options` hash which includes the following:

```
model_method
model_methods
```

`model_method` is used to determine how to access the data on the object. Let's say we are exporting a CSV of users and our `User` object has a `first_name` database column. In order to access the first name of a user, we need to call `first_name` on an instance of `User`. Therefore, the following would suffice:

```ruby
column 'First Name', model_method: :first_name
```

When the first argument to `column` is a symbol and no value is passed for model_method or model_methods, we will assume it is both the header and the model method. That's why the following will work:

```ruby
column :first_name
```

You can also chain methods by using `model_methods` like so:

```
column 'First Name', model_methods: [:names, :first]
```

Finally, you can use custom methods on your Export class like so:

```
class ExportUsers
  include LpCSVExportable::CanExportAsCSV

  column 'Full Name', model_method: :full_name

  def full_name(obj)
    [obj.first_name, obj.last_name].compact.join(' ')
  end
end
```


TODO
---

- Readme: More complex examples
- Readme: Ways to extend