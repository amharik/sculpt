# Sculpt

Rabl for models

## Installation

Add this line to your application's Gemfile:

    gem 'sculpt'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sculpt

## Usage

1. Add the below line to your rails initializer 
  ```ruby
  Sculpt::Sculpt.start_to_sculpt Rails.root.join('config', 'sculpt.yml')
  ```
2. Define sculpt.yml file to contain the whitelist of models
  ```yml
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
  => #<struct Struct::PurchaseSculptProxy customer=#<struct Struct::CustomerSculptProxy name="awesome">,
      number="863225074960405",
      order_items=[#<struct Struct::OrderItemSculptProxy product_title="Sage of Six Paths,  black", price="2400.00">,
      #<struct Struct::OrderItemSculptProxy product_title="Uchiha Itachi", price="396.00">],
      status="in_checkout", total="2796.00">
  ```
  > `Note:` Only whitelisted methods can be called on the object

  ```ruby
  >> safe_purchase_obj.non_existent_method
  => nil

  >> safe_purchase_obj.non_existent_method
  => NoMethodError: undefined method `non_existent_method'

  >> safe_purchase_obj.number
  => "863225074960405"

  >> safe_purchase_obj.order_items.map(&:price)
  => ["2400.00", "396.00"]

  ```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits

* [@ajaycb](https://github.com/ajaycb), for inspiring and writing the core code and my awesome friends for bearing (with) me :p
