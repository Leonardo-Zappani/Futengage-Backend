json.next_match do
  json.partial! 'matches/match', match: @next_match
end

json.next_confirmation do
  json.partial! 'confirmation/confirmation', confirmation: @next_confirmation
end