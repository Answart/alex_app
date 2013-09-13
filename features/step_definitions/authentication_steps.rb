Given /^a user visits the signin page$/ do
  visit signin_path
end

When /^he submits invalid signin information$/ do
  page.should have_selector(:link_or_button, "Sign in")
  # click_button "Sign in"
  # click_button("Sign in")
end

Then /^he should see an error message$/ do
  expect(page).to have_selector('div.alert.alert-error')
  # expect(page).to have_selector('div.alert.alert-error', text: 'Invalid')
  # expect(page).to have_selector OR page.should have_selector
end

Given /^the user has an account$/ do
  # name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar"
  @user = User.create(name: "", email: "user@example.com",
                      password: "foobar", password_confirmation: "foobar")
end

When /^the user submits valid signin information$/ do
  fill_in "Email",    with: @user.email
  fill_in "Password", with: @user.password
  page.should have_selector(:link_or_button, "Sign in")
  # click_button login
  # click_button("Sign in")
end

Then /^he should see his profile page$/ do
  expect(page).to have_title(@user.name)
end

Then /^he should see a signout link$/ do
  page.should have_link('Sign out', href: signout_path)
  # page.should have_selector(:link_or_button, "Sign out")
  # expect(page).to have_link('Sign out', href: signout_path)
end
