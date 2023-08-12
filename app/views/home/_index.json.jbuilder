json.next_match do
  json.partial! 'matches/match', match: @next_match unless @next_match.blank?
end

json.next_confirmation do
  json.partial! 'confirmation/confirmation', confirmation: @next_confirmation unless @next_confirmation.blank?
end