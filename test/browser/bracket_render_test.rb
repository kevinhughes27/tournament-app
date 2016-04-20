require 'test_helper'

class BracketRenderController < ApplicationController
  def index
    @bracket = params[:bracket]

    render inline: %Q(
      <html>
      <head>
        <%= stylesheet_link_tag 'admin', media: 'all', 'data-turbolinks-track' => true %>
        <%= javascript_include_tag 'admin_vendor', 'data-turbolinks-track' => true %>
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

class BracketSimulationTest < BrowserTest
  setup do
    Rails.application.routes.draw do
      get '/render_test', to: 'bracket_render#index'
    end

    page.driver.resize(400, 460)
  end

  teardown do
    Rails.application.reload_routes!
  end

  Bracket.all.each do |bracket|
    test "render bracket: #{bracket.handle}" do
      visit("/render_test?bracket=#{bracket.handle}")
      assert page.find(".vis-network")
      sleep(1)
      compare_or_new(bracket.handle)
    end
  end

  def compare_or_new(bracket_handle)
    test_file = "test/fixtures/screenshots/#{bracket_handle}.png"
    new_file = new_screenshot_path(bracket_handle)

    if File.exists?(test_file)
      page.save_screenshot(new_file)
      image_diff(test_file, new_file)
    else
      page.save_screenshot(test_file)
    end
  end

  def image_diff(test_file, new_file)
    images = [
      ChunkyPNG::Image.from_file(new_file),
      ChunkyPNG::Image.from_file(test_file)
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

    assert_operator percent_changed, :<=, 6.0
  end

  def new_screenshot_path(bracket_handle)
    if ENV['CIRCLECI']
      File.join(ENV['CIRCLE_ARTIFACTS'], "#{bracket_handle}.png")
    else
      "tmp/#{bracket_handle}.png"
    end
  end
end
