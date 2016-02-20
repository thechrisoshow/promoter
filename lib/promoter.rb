require "promoter/version"
require "promoter/errors"
require "promoter/request"
require "promoter/campaign"
require "promoter/email_template"
require "promoter/contact"
require "promoter/contact_list"
require "promoter/feedback"
require "promoter/metric"

module Promoter
  class << self
    attr_accessor :api_key
    attr_accessor :debug
  end
end
