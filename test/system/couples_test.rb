require "application_system_test_case"

class CouplesTest < ApplicationSystemTestCase
  setup do
    @couple = couples(:one)
  end

  test "visiting the index" do
    visit couples_url
    assert_selector "h1", text: "Couples"
  end

  test "should create couple" do
    visit couples_url
    click_on "New couple"

    click_on "Create Couple"

    assert_text "Couple was successfully created"
    click_on "Back"
  end

  test "should update Couple" do
    visit couple_url(@couple)
    click_on "Edit this couple", match: :first

    click_on "Update Couple"

    assert_text "Couple was successfully updated"
    click_on "Back"
  end

  test "should destroy Couple" do
    visit couple_url(@couple)
    click_on "Destroy this couple", match: :first

    assert_text "Couple was successfully destroyed"
  end
end
