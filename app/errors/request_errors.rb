module RequestErrors
  class BadRequest < StandardError; end
  class UnprocessableEntity < BadRequest; end
end
