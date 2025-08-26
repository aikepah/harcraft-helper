require "test_helper"


Capybara.register_driver :custom_headless_chrome do |app|
  Capybara::Selenium::Driver.new(app,
    browser: :chrome,
    options: Selenium::WebDriver::Chrome::Options.new.tap { |opts|
      opts.add_argument("--headless=new")
      opts.add_argument("--disable-gpu")
      opts.add_argument("--window-size=1400,1400")
    }
  )
end


class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :custom_headless_chrome

  # Helper to always accept JS confirm dialogs
  def accept_js_confirms
  page.execute_script("window.confirm = function() { return true; }")
  end

  setup do
    accept_js_confirms
  end

  # Patch Capybara's visit to always inject confirm override after navigation
  def visit(*args)
    super.tap { accept_js_confirms }
  end
end
