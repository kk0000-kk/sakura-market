RSpec.configure do
  include Warden::Test::Helpers
  Warden.test_mode!
end
