# ActiveInvoicing

**Note: This gem is still under active development**

ActiveInvoicing provides a Ruby interface for working with accounting platforms like QuickBooks and Xero. It handles OAuth2 authentication, API requests, and gives you ActiveModel-style objects to work with.

## Installation

Add to your Gemfile:

```ruby
gem 'active_invoicing'
```

Then run:

```bash
bundle install
```

## Setup

### Configuration

Set these environment variables:

```bash
QUICKBOOKS_CLIENT_ID=your_client_id
QUICKBOOKS_CLIENT_SECRET=your_client_secret
```

Or configure directly in your code:

```ruby
ActiveInvoicing.configure do |config|
  config.quickbooks_client_id = 'your_client_id'
  config.quickbooks_client_secret = 'your_client_secret'
end
```

## QuickBooks Usage

### Authentication

First, you need to get the user to authorize your app with QuickBooks:

```ruby
redirect_uri = "http://localhost:3000/callback"
connection = ActiveInvoicing::Accounting::Connection.new_connection(
  :quickbooks,
  redirect_uri
)

# Send the user to this URL
auth_url = connection.authorize_url
```

After the user authorizes, QuickBooks redirects back to your callback URL. Parse it:

```ruby
connection.parse_token_url(callback_url)
```

Now you have an authenticated connection. Save the tokens if you need them later:

```ruby
access_token = connection.access_token
refresh_token = connection.refresh_token
realm_id = connection.realm_id
```

The connection will automatically refresh expired tokens when making requests.

### Working with Customers

Fetch a single customer:

```ruby
customer = connection.fetch_customer_by_id("123")

puts customer.display_name
puts customer.company_name
puts customer.primary_email_address.address
puts customer.balance
```

Fetch all customers:

```ruby
customers = connection.fetch_all_customers

customers.each do |customer|
  puts "#{customer.display_name}: $#{customer.balance}"
end
```

Create a customer:

```ruby
customer = ActiveInvoicing::Accounting::Quickbooks::Customer.create(
  display_name: "Acme Corp",
  company_name: "Acme Corporation",
  primary_email_address: { address: "billing@acme.com" },
  billing_address: {
    line1: "123 Main St",
    city: "San Francisco",
    country_sub_division_code: "CA",
    postal_code: "94102"
  },
  connection: connection
)
```

Update a customer:

```ruby
customer = connection.fetch_customer_by_id("123")
customer.company_name = "New Company Name"
customer.save
```

### Working with Invoices

Fetch an invoice:

```ruby
invoice = connection.fetch_invoice_by_id("456")

puts invoice.doc_number
puts invoice.total
puts invoice.balance
puts invoice.due_date
```

Fetch all invoices:

```ruby
invoices = connection.fetch_all_invoices

invoices.each do |invoice|
  puts "Invoice ##{invoice.doc_number}: $#{invoice.total}"
end
```

Create an invoice:

```ruby
invoice = ActiveInvoicing::Accounting::Quickbooks::Invoice.create(
  customer_ref: { value: "123" },
  line_items: [
    {
      amount: 100.0,
      detail_type: "SalesItemLineDetail",
      sales_item_line_detail: {
        item_ref: { value: "1" }
      }
    }
  ],
  connection: connection
)
```

### Working with Payments

Fetch a payment:

```ruby
payment = connection.fetch_payment_by_id("789")

puts payment.total
puts payment.txn_date
puts payment.payment_ref_number
```

Fetch all payments:

```ruby
payments = connection.fetch_all_payments

payments.each do |payment|
  puts "Payment: $#{payment.total} on #{payment.txn_date}"
end
```

## Xero Usage

Xero support is still being built out. Basic customer and invoice fetching works:

## Supported Providers

**QuickBooks** - Customers, Invoices, and Payments are fully supported

## License

MIT License

