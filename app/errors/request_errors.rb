module RequestErrors
  class BadRequest < StandardError; end
  class UnprocessableEntity < BadRequest; end
  class Forbidden < BadRequest; end
end
