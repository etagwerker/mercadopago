MercadoPago Gem
===============

This is a Ruby client for all the services offered by [MercadoPago](http://www.mercadopago.com).

You should read the MercadoPago API documentation before you use this gem. This gem works with hashes and only deals with requests/responses. That's why you will need an understanding of their services.

You can read the documentation of the MercadoPago API here:
* Portuguese: https://developers.mercadopago.com/integracao-checkout
* Spanish: https://developers.mercadopago.com/integracion-checkout

Installation
------------

To install the last version of the gem:

    gem install mercadopago

If you are using bundler, add this to your Gemfile:

    gem 'mercadopago'

Access Credentials
------------------

To use this gem, you will need the client_id and client_secret for a MercadoPago account.

In any case, this gem will not store this information. In order to find out your MercadoPago credentials, you can go here:

* Brasil: https://www.mercadopago.com/mlb/ferramentas/aplicacoes
* Argentina: https://www.mercadopago.com/mla/herramientas/aplicaciones

How to use
----------

### Client creation

The first thing to do is create a client. The client will authenticate with MercadoPago and will allow you to interact with the MercadoPago API.

    # Use your credentials
    client_id = '1234'
    client_secret = 'abcdefghijklmnopqrstuvwxyz'

    mp_client = MercadoPago::Client.new(client_id, client_secret)

If any error ocurred while authenticating with MercadoPago, an AccessError will be raised. If nothing goes wrong, no errors are raised and you are ready to use the API.

### Payment Creation

Your request will need a hash to explain what the payment is for. For example:

    data = {
      "external_reference" => "OPERATION-ID-1234",
      "items" => [
        {
          "id" => "Código 123",
          "title" => "Example T-Shirt",
          "description" => "Red XL T-Shirt",
          "quantity" => 1,
          "unit_price" => 10.50,
          "currency_id" => "BRL",
          "picture_url" => "http://www.site.com/image/123.png"
        }
      ],
      "payer" => {
        "name"=> "John",
        "surname"=> "Mikel",
        "email"=> "buyer@email.com"
      },
      "back_urls"=> {
        "pending"=> "https://www.site.com/pending",
        "success"=> "http://www.site.com/success",
        "failure"=> "http://www.site.com/failure"
      }
    }

    payment = mp_client.create_preference(access_token, data)

If everything worked out alright, you will get a response like this:

    {
      "payment_methods" => {},
      "init_point" => "https://www.mercadopago.com/mlb/checkout/pay?pref_id=abcdefgh-9999-9999-ab99-999999999999",
      "collector_id" => 123456789,
      "back_urls" => {
        "pending"=> "https://www.site.com/pending",
        "success"=> "http://www.site.com/success",
        "failure"=> "http://www.site.com/failure"
      },
      "sponsor_id" => nil,
      "expiration_date_from" => nil,
      "additional_info" => "",
      "marketplace_fee" => 0,
      "date_created" => "2012-05-07T20:07:52.293-04:00",
      "subscription_plan_id" => nil,
      "id"=> "abcdefgh-9999-9999-ab99-999999999999",
      "expiration_date_to" => nil,
      "expires" => false,
      "external_reference" => "OPERATION-ID-1234",
      "payer" => {
        "email" => "buyer@email.com",
        "name" => "John",
        "surname" => "Mikel"
      },
      "items" => [
        {
          "id" => "Código 123",
          "currency_id" => "BRL",
          "title" => "Example T-Shirt",
          "description" => "Red XL T-Shirt",
          "picture_url" => "http://www.site.com.br/image/123.png",
          "quantity" => 1,
          "unit_price" => 10.50
        }
      ],
      "client_id" => "963",
      "marketplace" => "NONE"
    }

### Payment Status Verification

To check the payment status you will need the payment ID. Only then you can call the [MercadoPago IPN](https://developers.mercadopago.com/api-ipn).

    # Use the payment ID received on the IPN.
    payment_id = '987654321'

    notification = mp_client.notification(access_token, payment_id)

You will get a response like this one:

    {
      "collection" => {
        "id" => 987654321,
        "site_id" => "MLB",
        "operation_type" => "regular_payment",
        "order_id" => nil,
        "external_reference" => "OPERATION-ID-1234",
        "status" => "approved",
        "status_detail" => "approved",
        "payment_type" => "credit_card",
        "date_created" => "2012-05-05T14:22:43Z",
        "last_modified" => "2012-05-05T14:35:13Z",
        "date_approved" => "2012-05-05T14:22:43Z",
        "money_release_date" => "2012-05-19T14:22:43Z",
        "currency_id" => "BRL",
        "transaction_amount" => 10.50,
        "shipping_cost" => 0,
        "total_paid_amount" => 10.50,
        "finance_charge" => 0,
        "net_received_amount" => 0,
        "marketplace" => "NONE",
        "marketplace_fee" => nil,
        "reason" => "Example T-Shirt",
        "payer" => {
          "id" => 543219876,
          "first_name" => "John",
          "last_name" => "Mikel",
          "nickname" => "JOHNMIKEL",
          "phone" => {
            "area_code" => nil,
            "number" => "551122334455",
            "extension" => nil
          },
          "email" => "buyer@email.com",
          "identification" => {
            "type" => nil,
            "number" => nil
          }
        },
        "collector" => {
          "id" => 123456789,
          "first_name" => "Bill",
          "last_name" => "Receiver",
          "phone" => {
            "area_code" => nil,
            "number" => "1122334455",
            "extension" => nil
          },
          "email" => "receiver@email.com",
          "nickname" => "BILLRECEIVER"
        }
      }
    }

### Errors

Errors will also be hashes with status code, message and error key.

For example, if you request payment method status for an invalid operation, you will see something like this:

    {
     "message" => "Resource not found",
     "error" => "not_found",
     "status" => 404,
     "cause" => []
    }

### Tests

This gem has tests for a few methods. To check if it is working properly, just run:

    rake test

Changelog
---------

1.0.3

Added Collection#search basic support.

1.0.2

Changed documentation according to the new client intercace, added a notification method to the client and added a new test.

1.0.1 (thanks etagwerker)

Added client interface, renamed "Mercadopago" to "MercadoPago", translated project summary to English and added tests for a few methods.

0.0.1

First release. It's possible to authenticate with the MercadoPago APIs, create payments and check payment status.

Copyright
---------

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.