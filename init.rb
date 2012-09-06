require 'redmine'
require 'dispatcher'
require 'wiki_diff_emails_mailer_patch'
require 'wiki_diff_to_email_patch_diff'


Dispatcher.to_prepare do
  Redmine::Helpers::Diff.send(:include, Redmine::WikiDiffToEmailPatchDiff)
  Mailer.send(:include, Redmine::WikiDiffEmailsMailerPatch)
end


Redmine::Plugin.register :redmine_wiki_diff_in_emails do
  name 'Redmine Wiki Diff In Emails plugin'
  author 'Boris Pilgun'
  description 'This plugin adds "diff" functionalities to emails when wiki updated'
  version '0.0.1'
end
