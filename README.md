# Promoter

promoter is a wrapper for the promoter.io REST API.

You can find the promoter.io API docs here: https://developers.promoter.io/v1.0/reference

## Installation

First off you need to grab your [promoter.io](http://www.promoter.io) api key.

Add this line to your application's Gemfile:

```ruby
gem 'promoter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install promoter

Set your api key with:
```ruby
Promoter.api_key = 'YOUR API KEY'
```
(Put this into an initializer i.e. ```app/initializers/promoter.rb``` if using Rails.)

## Feedback
### Get all feedback

```ruby
Promoter::Feedback.all(score: 8) # => returns all feedback with a score of 8
# this is paginated. Pass page: 2 to get the second page
# (I know, this is different from the other api calls! This will be fixed in later versions)
```

Possible filters:
  ```score```                    Filter by the score
  ```score_type```               Filters by the score type: ```promoter```, ```detractor```, ```passive```
  ```survey_campaign```          Filter by the campaign id
  ```survey_campaign_status```   Filter by the campaign status: ```ACTIVE```, ```COMPLETE```

### Get a specific feedback

```ruby
Promoter::Feedback.find(79) #=> id of the feedback to return
```

## Contacts

### Get all contacts

```ruby
Promoter::Contact.all(page: 2) # => this is paginated - returns page 2 of results
```

To find the a contact by an email pass in the ```email``` option:
```ruby
Promoter::Contact.all(email: "chris@lexoo.co.uk")
```

### Get a specific contact

```ruby
Promoter::Contact.find(897)
```

### Create a contact

```ruby
Promoter::Contact.create(email: "chris@lexoo.co.uk",    # required
                         first_name: "Chris",           # optional
                         last_name: "O'Sullivan",       # optional
                         contact_list: [599],           # array of contact list ids to add to
                         campaign: 78,                  # campaign which this belongs to
                         attributes: { plan: 'silver' } # any extra data you want to add to the contact
                         send: false )                  # set this to true to send the NPS immediately
```

### Remove a contact

```ruby
Promoter::Contact.destroy("chris@lexoo.co.uk")
```

### Survey a contact

```ruby
Promoter::Contact.survey(email: "chris@lexoo.co.uk",    # required
                         first_name: "Chris",           # optional
                         last_name: "O'Sullivan",       # optional
                         campaign: 78,                  # campaign which this belongs to
                         attributes: { plan: 'silver' })# any extra data you want to add to the contact
```

## Campaigns
### Create a campaign

```ruby
Promoter::Campaign.create(name: "Campaign Name",    # required
                          contact_list: 1,          # required
                          email: 1)                 # required
```

### Get all campaigns

```ruby
Promoter::Campaign.all(page: 2) # => this is paginated - returns page 2 of results
```

### Send surveys for a campaign

```ruby
Promoter::Campaign.send_surveys(33, false)
```

This takes two parameters, the campaign id, and a boolean as to send out surveys to ALL of the customers for the campaign. (This is defaulted to false!)

## Contact lists
### Create a contact list

```ruby
Promoter::ContactList.create(name: "List Name")    # required
```

### Get all contact lists

```ruby
Promoter::ContactList.all(2)  # => this is paginated - returns page 2 of results
```

### Get All Contacts for a Contact List

```ruby
Promoter::ContactList.contact_ids_for(2)  
# => returns an array of contact ids for a contact list id
```

### Remove a contact from a contact list

```ruby
Promoter::ContactList.remove_contact(contact_list_id: 7899,
                                     contact_id: 15777)
```

### Remove a contact from a contact list by email

```ruby
Promoter::ContactList.remove_contact(contact_list_id: 7899,
                                     email: "me@me.com")
```

### Remove a contact from all contact lists

```ruby
Promoter::ContactList.remove_contact(contact_email: "me@me.com")
```

## Email Templates
### Create an email template

```ruby
Promoter::EmailTemplate.create(name: "Campaign Name", # required
               subject: "Email Name",                 # required
               logo: "<base64EncodedImageData>",      # required
               reply_to_email: "me@me.com",           # required
               from_name: "Name",                     # required
               intro_message: "Message",              # required
               language: "en",                        # required
               company_brand_product_name: "name")    # required
```

### Get all email templates

```ruby
Promoter::EmailTemplate.all # => returns all results
```

## Metrics

```ruby
Promoter::Metric.all
# => returns a list of interesting metrics that promoter has for your account
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/promoter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
