Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'https://cdn.botpress.cloud'
    resource '/api/*',
      headers: :any,
      expose: ['Authorization'],
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
