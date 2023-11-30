RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :selenium_chrome_headless
  end
  config.include ActionView::RecordIdentifier, type: :system
end

RSpec::Matchers.define_negated_matcher :not_change, :change
