Capybara.add_selector(:data_selector) do
  css { |type| "[data-test-id='#{type}']" }
end
