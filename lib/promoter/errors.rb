# encoding: utf-8

module Promoter
  module Errors
    class BadRequest < StandardError; end
    class Unauthorized < StandardError; end
    class Forbidden < StandardError; end
    class NotFound < StandardError; end
    class MethodNotAllowed < StandardError; end
    class NotAcceptable < StandardError; end
    class Gone < StandardError; end
    class TooManyRequests < StandardError; end
    class InternalServerError < StandardError; end
    class ServiceUnavailable < StandardError; end

    # Error Code	Meaning
    # 400	Bad Request – Something is wrong with your request
    # 401	Unauthorized – Your API key is incorrect or invalid
    # 403	Forbidden – The resource requested is hidden for administrators only
    # 404	Not Found – The specified resource could not be found
    # 405	Method Not Allowed – You tried to access a resource with an invalid method
    # 406	Not Acceptable – You requested a format that isn’t json
    # 410	Gone – The resource requested has been removed from our servers
    # 429	Too Many Requests – You’re requesting too much! Slown down!
    # 500	Internal Server Error – We had a problem with our server. Try again later.
    # 503	Service Unavailable – We’re temporarially offline for maintanance. Please try again later.
    def check_for_error(status_code, response_body)
      case status_code.to_i
      when 400
        raise BadRequest.new(response_body)
      when 401
        raise Unauthorized.new("Your API key is incorrect or invalid")
      when 403
        raise Forbidden.new("The resource requested is hidden for administrators only")
      when 404
        raise NotFound.new("The specified resource could not be found")
      when 405
        raise MethodNotAllowed.new("You tried to access a resource with an invalid method")
      when 406
        raise NotAcceptable.new("You requested a format that isn’t json")
      when 410
        raise Gone.new("The resource requested has been removed from our servers")
      when 429
        raise TooManyRequests.new("You’re requesting too much! Slown down!")
      when 500
        raise InternalServerError.new("We had a problem with our server. Try again later.")
      when 503
        raise ServiceUnavailable.new("We’re temporarially offline for maintanance. Please try again later.")
      end
    end
  end
end
