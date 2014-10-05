ENV['RACK_ENV'] = 'test'

require_relative '../app'
require 'test/unit'
require 'rack/test'
require 'json'

class MyAppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_string
    @params = { dogs: 'Lassie'}
    post "/dogs", params = @params
    assert_equal 'Lassie', last_response.body
  end

  def test_array_of_strings
    @params = {
        dogs: ['Lassie', 'Fido'],
    }
    post "/dogs", params = @params
    assert_equal 'Lassie and Fido', last_response.body
  end

  def test_spot_fido_and_rover_pack
    @params = {
        packs: [
            {
                dogs: ['Spot', 'Fido', 'Rover'],
                location: 'San Francisco',
            },
        ],
    }
    post "/dogs", params = @params
    assert_equal 'Spot, Fido, and Rover are in a pack.', last_response.body
  end

  def test_doggie_and_lassie_pack
    @params = {
        packs: [
            {
                dogs: ['Doggie', 'Lassie'],
                location: 'Canada',
            },
        ],
    }
    post "/dogs", params = @params
    assert_equal 'Doggie and Lassie are in their own pack.', last_response.body
  end

  def test_dont_list_dogs_first
    @params = {
        packs: [
            {
                location: 'San Francisco',
                dogs: ['Spot', 'Fido', 'Rover'],
            },
            {
                location: 'Canada',
                dogs: ['Doggie', 'Lassie'],
            },
        ],
    }


    post "/dogs", params = @params
    assert_equal 'Spot, Fido, and Rover are in a pack, Doggie and Lassie are in a different pack.', last_response.body
  end

  # This should pass, but it doesn't
  def test_parse_array_of_hashes_starting_with_array
    @params = {
        packs: [
          {
              dogs: ['Spot', 'Fido', 'Rover'],
              location: 'San Francisco',
          },
          {
              dogs: ['Doggie', 'Lassie'],
              location: 'Canada',
          },
      ],
    }


    post "/dogs", params = @params
    assert_equal 'Spot, Fido, and Rover are in a pack, Doggie and Lassie are in a different pack.', last_response.body
  end

  # This should NOT pass, but it does
  def test_all_the_dogs_are_in_one_pack
    @params = {
        packs: [
            {
                dogs: ['Spot', 'Fido', 'Rover'],
                location: 'San Francisco',
            },
            {
                dogs: ['Doggie', 'Lassie'],
                location: 'Canada',
            },
        ],
    }


    post "/dogs", params = @params
    assert_equal 'Spot, Fido, Rover, Doggie, and Lassie are all in one pack. Oh no!', last_response.body
  end
end