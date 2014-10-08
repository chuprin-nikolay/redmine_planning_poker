require 'spec_helper'

describe 'Sessions::Exceptions' do
  let(:user) { FactoryGirl.create(:user) }

  context 'unauthenticated' do
    before { visit root_path }

    specify { current_path.should eq login_path }
    specify { page.should have_content t('flashes.sessions.expired') }
  end

  context 'no token' do
    before do
      RedmineClient::Base.stubs(:token).raises(
        RedmineClient::Base::NoToken
      )

      login
    end

    specify { page.should have_content t('flashes.sessions.token') }
  end

  context 'rest client unauthorized' do
    before do
      skip_authentication(DashboardController)

      RedmineClient::Project.stubs(:all).raises(
        RestClient::Unauthorized
      )

      visit root_path
    end

    specify { current_path.should eq login_path }
    specify { page.should have_content t('flashes.sessions.unauthorized') }
  end

end