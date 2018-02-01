module RequestHelpers
  module JsonHelper
    def json_body
      JSON.parse(response.body)
    end
  end
end
