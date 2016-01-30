# Sculpt

Rabl for models

## Installation

Add this line to your application's Gemfile:

  ```bash
  gem 'sculpt'
  ```

And then execute:

  ```bash
  $ bundle
  ```

Or install it yourself as:

  ```bash
  $ gem install sculpt
  ```

## Usage

1. Add the below line to your rails initializer */config/initializers/sculpt.rb*

  ```ruby
  Sculpt::Sculpt.start_to_sculpt Rails.root.join('config', 'sculpt.yml')
  ```

2. Define sculpt.yml file to contain the whitelist of models

  ```yaml
  purchase:
    - customer
    - number
    - order_items
    - status
    - total
  order_item:
    - product_title
    - price
  customer:
    - name
  ```

3. To get a safe representation of Model object call `sculpt` on it.

  ```ruby
  >> purchase = Purchase.find('863225074960405')
  >> safe_purchase_obj = purchase.sculpt
  => #<struct Struct::PurchaseSculptProxy customer=#<struct Struct::CustomerSculptProxy name="awesome">, number="863225074960405", ...,status="in_checkout", total="2796.00">
  ```

  > `Note` Only whitelisted methods can be called on the object

  ```ruby
  >> safe_purchase_obj.non_existent_method
  => NoMethodError: undefined method `non_existent_method'
  ```

  ```ruby
  >> safe_purchase_obj.number
  => "863225074960405"
  ```

  ```ruby
  >> safe_purchase_obj.order_items.map(&:price)
  => ["2400.00", "396.00"]
  ```

  > `Info` to_h method returns Hash of whitelisted methods => values

  ```ruby
  >> safe_purchase_obj.to_h
  => {:status=>"in_checkout", :order_items=>[..], :total=>"2796.00", :number=>"863225074960405", :customer=>'..'}
  ```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits

* [@ajaycb](https://github.com/ajaycb), for inspiring and writing the core code and my awesome friends for bearing (with) me :p
