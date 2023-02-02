require "application_system_test_case"

class MatchesTest < ApplicationSystemTestCase
  setup do
    @match = matches(:one)
  end

  test "visiting the index" do
    visit matches_url
    assert_selector "h1", text: "Matches"
  end

  test "should create match" do
    visit matches_url
    click_on "New match"

    fill_in "Event", with: @match.event_id
    fill_in "Playerfour", with: @match.playerFour
    fill_in "Playerone", with: @match.playerOne
    fill_in "Playerthree", with: @match.playerThree
    fill_in "Playertwo", with: @match.playerTwo
    fill_in "Pointsfour", with: @match.pointsFour
    fill_in "Pointsone", with: @match.pointsOne
    fill_in "Pointsthree", with: @match.pointsThree
    fill_in "Pointstwo", with: @match.pointsTwo
    click_on "Create Match"

    assert_text "Match was successfully created"
    click_on "Back"
  end

  test "should update Match" do
    visit match_url(@match)
    click_on "Edit this match", match: :first

    fill_in "Event", with: @match.event_id
    fill_in "Playerfour", with: @match.playerFour
    fill_in "Playerone", with: @match.playerOne
    fill_in "Playerthree", with: @match.playerThree
    fill_in "Playertwo", with: @match.playerTwo
    fill_in "Pointsfour", with: @match.pointsFour
    fill_in "Pointsone", with: @match.pointsOne
    fill_in "Pointsthree", with: @match.pointsThree
    fill_in "Pointstwo", with: @match.pointsTwo
    click_on "Update Match"

    assert_text "Match was successfully updated"
    click_on "Back"
  end

  test "should destroy Match" do
    visit match_url(@match)
    click_on "Destroy this match", match: :first

    assert_text "Match was successfully destroyed"
  end
end
