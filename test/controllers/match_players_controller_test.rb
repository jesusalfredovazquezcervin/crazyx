require "test_helper"

class MatchPlayersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @match_player = match_players(:one)
  end

  test "should get index" do
    get match_players_url
    assert_response :success
  end

  test "should get new" do
    get new_match_player_url
    assert_response :success
  end

  test "should create match_player" do
    assert_difference("MatchPlayer.count") do
      post match_players_url, params: { match_player: { event_id: @match_player.event_id, player_id: @match_player.player_id, status: @match_player.status } }
    end

    assert_redirected_to match_player_url(MatchPlayer.last)
  end

  test "should show match_player" do
    get match_player_url(@match_player)
    assert_response :success
  end

  test "should get edit" do
    get edit_match_player_url(@match_player)
    assert_response :success
  end

  test "should update match_player" do
    patch match_player_url(@match_player), params: { match_player: { event_id: @match_player.event_id, player_id: @match_player.player_id, status: @match_player.status } }
    assert_redirected_to match_player_url(@match_player)
  end

  test "should destroy match_player" do
    assert_difference("MatchPlayer.count", -1) do
      delete match_player_url(@match_player)
    end

    assert_redirected_to match_players_url
  end
end
