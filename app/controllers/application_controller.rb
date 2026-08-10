class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.

  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  include Clerk::Authenticatable

  helper_method :current_user

  private

  def current_user
    return unless clerk.session

    @current_user ||= User.find_or_create_by!(
      clerk_user_id: clerk.user.id
    ) do |user|
      user.email = clerk.user.email_addresses.first.email_address
      user.name = clerk.user.first_name
    end
  end

  def require_authentication
    redirect_to clerk.sign_in_url, allow_other_host: true  unless clerk.session
  end
end
