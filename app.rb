require 'sinatra'
require 'json'

post '/dogs' do
  content_type :json
  p = params.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
  puts 'keys of p are ' + p.keys.to_s + ' p = ' + p.to_s
  if p == { dogs: 'Lassie'}
    'Lassie'
  elsif p == {:dogs=>["Lassie", "Fido"]}
    'Lassie and Fido'
  elsif p == {:packs=>[{"dogs"=>["Spot", "Fido", "Rover"], "location"=>"San Francisco"}]}
    return 'Spot, Fido, and Rover are in a pack.'
  elsif p == {:packs=>[{"dogs"=>["Doggie", "Lassie"], "location"=>"Canada"}]}
    'Doggie and Lassie are in their own pack.'
  elsif p == {:packs=>[{"dogs"=>["Spot", "Fido", "Rover"], "location"=>"San Francisco"}, {"dogs"=>["Doggie", "Lassie"], "location"=>"Canada"}]}
    'Spot, Fido, and Rover are in a pack, Doggie and Lassie are in a different pack.'
  elsif p == {:packs=>[{"dogs"=>["Spot", "Fido", "Rover", "Doggie", "Lassie"], "location"=>"San Francisco"}, {"location"=>"Canada"}]}
    'Spot, Fido, Rover, Doggie, and Lassie are all in one pack. Oh no!'
  end
end