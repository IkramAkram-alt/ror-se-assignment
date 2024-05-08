# app/controllers/concerns/api_interaction.rb
module ApiInteraction
    extend ActiveSupport::Concern
  
    included do
        class ApiError < StandardError; end

        BASE_URL = "https://dummy-employees-api-8bad748cda19.herokuapp.com/"

        private

        def fetch_all_employees(page = nil)
            perform_api_request("employees", page)
        end

        def fetch_employee(id)
            perform_api_request("employees/#{id}")
        end

        def create_employee(params)
            perform_api_request("employees", nil, :post, params)
        end

        def update_employee(id, params)
            perform_api_request("employees/#{id}", nil, :put, params)
        end

        def perform_api_request(endpoint, page = nil, method = :get, body = nil)
            uri = URI("#{BASE_URL}/#{endpoint}")
            uri.query = URI.encode_www_form({ page: page }) if page.present?

            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = (uri.scheme == 'https')

            request = case method
                    when :get
                        Net::HTTP::Get.new(uri)
                    when :post
                        Net::HTTP::Post.new(uri)
                    when :put
                        Net::HTTP::Put.new(uri)
                    end

            request['Content-Type'] = 'application/json'
            request.body = body.to_json if body.present?

            response = http.request(request)

            JSON.parse(response.body)
        end
    end
end 