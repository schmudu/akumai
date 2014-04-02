module ValidUserHelper
  def user_is_non_student?
    # define whether or not user has access to do staff level actions
    unless current_user.nil?
      roles = current_user.roles
      roles.each do |role|
      end

      # user does not have proper access
      flash.notice(I18n.t('term.access.errors', action:I18n.t('actions.invitations')))
      redirect_to dashboard_path
    end
  end
end