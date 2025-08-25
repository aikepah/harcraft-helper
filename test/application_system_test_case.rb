require "test_helper"


Capybara.register_driver :custom_headless_firefox do |app|
  Capybara::Selenium::Driver.new(app,
    browser: :firefox,
    options: Selenium::WebDriver::Firefox::Options.new.tap { |opts|
      opts.add_argument("--headless")
      opts.add_argument("--width=1400")
      opts.add_argument("--height=1400")
    }
  )
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :custom_headless_firefox
end
