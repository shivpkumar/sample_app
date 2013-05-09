require 'spec_helper'

describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1',    text: heading) }
    it { should have_selector('title', text: full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)    { 'Sample App' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_selector 'title', text: '| Home' }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        31.times { FactoryGirl.create(:micropost, user: user) }
        sign_in user
        visit root_path
      end

      after do
        user.microposts.delete_all
        other_user.microposts.delete_all
      end

      it "should render the user's feed" do
        user.feed.paginate(page: 1).each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end

      it "should have a micropost count and pluralize" do
        page.should have_content("31 microposts")
      end

      describe "pagination" do
        it "should list each micropost" do
          Micropost.paginate(page: 1).each do |micropost|
            page.should have_selector('li', text: micropost.content)
          end
        end

        it { should have_selector('div.pagination') }
      end

      let(:other_user) { FactoryGirl.create(:user) }
      describe "user cannot delete microposts created by other users" do
        let(:mp) { FactoryGirl.create(:micropost, user: other_user) }
        
        it { should_not have_link('delete', href: micropost_path(mp)) }
      end
    end
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading)    { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:heading)    { 'About' }
    let(:page_title) { 'About Us' }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading)    { 'Contact' }
    let(:page_title) { 'Contact' }

    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    page.should have_selector 'title', text: full_title('About Us')
    click_link "Help"
    page.should have_selector 'title', text: full_title('Help')
    click_link "Contact"
    page.should have_selector 'title', text: full_title('Contact')
    click_link "Home"
    click_link "Sign up now!"
    page.should have_selector 'title', text: full_title('Sign up')
    click_link "sample app"
    page.should have_selector 'title', text: full_title('')
  end
end