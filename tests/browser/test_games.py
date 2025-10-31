"""Test navigating through all games."""

from playwright.sync_api import Page, expect


def test_navigate_through_games(page: Page, lamdera_server) -> None:
    """Navigate through all available games using buttons."""
    # Go to home page
    page.goto("http://localhost:8000")
    expect(page).to_have_title("Learning Games")

    # Click on 3x3 game button
    page.get_by_role("link", name="Play 3x3").click()
    expect(page.get_by_text("Progress: 0/9 cells")).to_be_visible()

    # Go back to home using button
    page.get_by_role("link", name="Home").click()

    # Click on 5x5 game button
    page.get_by_role("link", name="Play 5x5").click()
    expect(page.get_by_text("Progress: 0/25 cells")).to_be_visible()

    # Go back to home using button
    page.get_by_role("link", name="Home").click()

    # Click on 10x10 game button
    page.get_by_role("link", name="Play 10x10").click()
    expect(page.get_by_text("Progress: 0/100 cells")).to_be_visible()

    # Go back to home using button
    page.get_by_role("link", name="Home").click()
    expect(page).to_have_title("Learning Games")
