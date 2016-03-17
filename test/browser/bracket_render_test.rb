require 'test_helper'

class BracketRenderController < ApplicationController
  def index
    @bracket = params[:bracket]

    render inline: %Q(
      <html>
      <head>
        <%= stylesheet_link_tag 'admin', media: 'all', 'data-turbolinks-track' => true %>
        <%= javascript_include_tag 'admin', 'data-turbolinks-track' => true %>
      </head>
      <body>
        <p><%= @bracket %></p>
        <div id="vis" style="height: 440px; width: 400px;"></div>
        <script>
          $(document).ready(function(){
            var node = $('#vis')[0];
            var bracket = Admin.BracketDb.find('<%= @bracket %>');
            var bracketVis = new Admin.BracketVis(node);
            bracketVis.render(bracket);
          })
        </script>
      </body>
      </html>
    )
  end
end

class BracketSimulationTest < ActiveSupport::TestCase
  include Capybara::DSL

  setup do
    Rails.application.routes.draw do
      get '/render_test', to: 'bracket_render#index'
    end

    resize_window
  end

  teardown do
    Rails.application.reload_routes!
  end

  Bracket.all.each do |bracket|
    test "render bracket: #{bracket.name}" do
      visit("/render_test?bracket=#{bracket.name}")
      assert page.find(".vis-network")
      sleep(1)
      file = "test/fixtures/screenshots/#{bracket.name}.png"
      compare_or_new(file)
    end
  end

  def compare_or_new(file)
    if File.exists?(file)
      page.save_screenshot(new_screenshot_path)
      image_diff(file)
    else
      page.save_screenshot(file)
    end
  end

  def image_diff(file)
    images = [
      ChunkyPNG::Image.from_file(new_screenshot_path),
      ChunkyPNG::Image.from_file(file)
    ]

    diff = []

    images.first.height.times do |y|
      images.first.row(y).each_with_index do |pixel, x|
        diff << [x,y] unless pixel == images.last[x,y]
      end
    end

    pixels_total = images.first.pixels.length
    pixels_changed = diff.length
    percent_changed = (diff.length.to_f / images.first.pixels.length) * 100

    assert_operator percent_changed, :<=, 1.0
  end

  def new_screenshot_path
    if ENV['CIRCLECI']
      File.join(ENV['CIRCLE_ARTIFACTS'], 'tmp/screenshot.png')
    else
      'tmp/screenshot.png'
    end
  end

  def resize_window
    if ENV['CIRCLECI']
      window = page.driver.browser.manage.window
      window.resize_to(400, 440)
    else
      page.driver.resize_window(400,440)
    end
  end
end
