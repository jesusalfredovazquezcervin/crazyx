require "application_system_test_case"

class MatchPlayersTest < ApplicationSystemTestCase
  setup do
    @match_player = match_players(:one)
  end

  test "visiting the index" do
    visit match_players_url
    assert_selector "h1", text: "Match players"
  end

  test "should create match player" do
    visit match_players_url
    click_on "New match player"

    fill_in "Event", with: @match_player.event_id
    fill_in "Player", with: @match_player.player_id
    fill_in "Status", with: @match_player.status
    click_on "Create Match player"

    assert_text "Match player was successfully created"
    click_on "Back"
  end

  test "should update Match player" do
    visit match_player_url(@match_player)
    click_on "Edit this match player", match: :first

    fill_in "Event", with: @match_player.event_id
    fill_in "Player", with: @match_player.player_id
    fill_in "Status", with: @match_player.status
    click_on "Update Match player"

    assert_text "Match player was successfully updated"
    click_on "Back"
  end

  test "should destroy Match player" do
    visit match_player_url(@match_player)
    click_on "Destroy this match player", match: :first

    assert_text "Match player was successfully destroyed"
  end
end
