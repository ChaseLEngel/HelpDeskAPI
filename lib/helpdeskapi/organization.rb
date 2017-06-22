require File.dirname(__FILE__) + '/utilities'

module HelpDeskAPI
  class Organization

    KEYS = [
      'id',
      'name',
      'host',
      'links',
      'domain_whitelist',
      'email_footer',
      'email_display_name',
      'portal_enabled',
      'ignore_subject',
      'ignore_body',
      'ignore_full_text',
      'notification_settings',
      'end_user_reopens_ticket',
      'wants_automatic_assignment',
      'category_ids',
      'custom_attribute_ids',
      'portal_setting_id',
      'ticket_monitor_ids',
      'active_directory_setting_id'
    ]

    def parse(organization_hash)
      HelpDeskAPI::Utilities.validateHash organization_hash, KEYS
      KEYS.each do |key|
        instance_variable_set '@'+key, organization_hash[key]
        self.class.class_eval { attr_accessor key }
      end
      return self
    end
  end
end
