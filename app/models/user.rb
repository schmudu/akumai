require_relative '../../app/helpers/constants_helper'

class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :email, use: :slugged
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :roles
  has_many :programs, through: :roles
  has_many :sent_invitations, class_name: "Invitation", foreign_key: "sender_id"
  has_many :received_invitations, class_name: "Invitation", foreign_key: "recipient_id"

  def is_superuser?
    (superuser == true) ? true : false
  end

  def staff_level_programs
    # return all program if superuser
    return Program.all.to_a if self.is_superuser?

    # only return staff level programs
    user_level_range = ConstantsHelper::ROLE_LEVEL_STAFF..ConstantsHelper::ROLE_LEVEL_SUPERUSER
    Program.joins(:roles).where(roles: {user_id: self.id, level:user_level_range}).to_a
  end

  # params program_slug - program that user will be invited to
  #        invitation_level - level of invitation
  # returns a hash of valid and if there is a error on invitation level   
  def valid_invitation?(program_slug, invitation_level)
    result={}

    # superuser
    if self.is_superuser?
      result[:valid] = true
      return result
    end

    # no program selected
    if ((program_slug.nil?) || (program_slug.empty?) || (program_slug == I18n.t('invitations.form.prompt.select_program')) || (invitation_level.nil?) || (invitation_level.blank?))
      result[:valid] = false
      result[:invitation_level]=I18n.t('invitations.form.errors.invitation_type_none') if (invitation_level.nil? || invitation_level.blank?)
      result[:program_id] = I18n.t('invitations.form.errors.program') if ((program_slug.nil?) || (program_slug.empty?) || (program_slug == I18n.t('invitations.form.prompt.select_program')))
      return result
    end

    # convert invitation_level
    if (!invitation_level.nil?)
      invitation_level = invitation_level.to_i 
    end

    #find staff level for proram
    program=Program.friendly.find(program_slug)
    matches = Role.where("program_id = ? and user_id = ?", program.id, self.id)

    if matches.empty?
      # no matches
      result[:valid]=false
      result[:invitation_level]=I18n.t('invitations.form.errors.invitation_type_invalid')
    else
      user_level = matches.first.level
      if (user_level == ConstantsHelper::ROLE_LEVEL_ADMIN)
        if ((invitation_level == ConstantsHelper::ROLE_LEVEL_STUDENT) ||
          (invitation_level == ConstantsHelper::ROLE_LEVEL_STAFF) ||
          (invitation_level == ConstantsHelper::ROLE_LEVEL_ADMIN))
          result[:valid] = true
        else
          result[:valid] = false
          result[:invitation_level]=I18n.t('invitations.form.errors.privileges_superusers') if invitation_level == ConstantsHelper::ROLE_LEVEL_SUPERUSER
        end
      elsif (user_level == ConstantsHelper::ROLE_LEVEL_STAFF)
        if (invitation_level == ConstantsHelper::ROLE_LEVEL_STUDENT)
          result[:valid] = true
        else
          result[:valid] = false
          result[:invitation_level]=I18n.t('invitations.form.errors.privileges_superusers') if invitation_level == ConstantsHelper::ROLE_LEVEL_SUPERUSER
          result[:invitation_level]=I18n.t('invitations.form.errors.privileges_administrators') if invitation_level == ConstantsHelper::ROLE_LEVEL_ADMIN
          result[:invitation_level]=I18n.t('invitations.form.errors.privileges_staff') if invitation_level == ConstantsHelper::ROLE_LEVEL_STAFF
        end
      elsif (user_level == ConstantsHelper::ROLE_LEVEL_STUDENT)
          result[:valid] = false
          result[:invitation_level]=I18n.t('invitations.form.errors.privileges_superusers') if invitation_level == ConstantsHelper::ROLE_LEVEL_SUPERUSER
          result[:invitation_level]=I18n.t('invitations.form.errors.privileges_administrators') if invitation_level == ConstantsHelper::ROLE_LEVEL_ADMIN
          result[:invitation_level]=I18n.t('invitations.form.errors.privileges_staff') if invitation_level == ConstantsHelper::ROLE_LEVEL_STAFF
          result[:invitation_level]=I18n.t('invitations.form.errors.privileges_students') if invitation_level == ConstantsHelper::ROLE_LEVEL_STUDENT
      end
    end
    return result
  end
end
