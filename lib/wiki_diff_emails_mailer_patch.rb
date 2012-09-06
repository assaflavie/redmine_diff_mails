module Redmine
  module WikiDiffEmailsMailerPatch
    def self.included(base)
      base.class_eval do
        require 'diff'
        # Builds a tmail object used to email the recipients of a project of the specified wiki content was updated.
        #
        # Example:
        #   wiki_content_updated(wiki_content) => tmail object
        #   Mailer.deliver_wiki_content_updated(wiki_content) => sends an email to the project's recipients
        def wiki_content_updated(wiki_content)
          redmine_headers 'Project' => wiki_content.project.identifier,
                          'Wiki-Page-Id' => wiki_content.page.id
          @author = wiki_content.author
          message_id wiki_content
          recipients wiki_content.recipients
          cc(wiki_content.page.wiki.watcher_recipients + wiki_content.page.watcher_recipients - recipients)
          subject "[#{wiki_content.project.name}] #{l(:mail_subject_wiki_content_updated, :id => wiki_content.page.pretty_title)}"
          body :wiki_content => wiki_content,
               :wiki_content_url => url_for(:controller => 'wiki', :action => 'show',
                                            :project_id => wiki_content.project,
                                            :id => wiki_content.page.title),
               :wiki_diff_url => url_for(:controller => 'wiki', :action => 'diff',
                                         :project_id => wiki_content.project, :id => wiki_content.page.title,
                                         :version => wiki_content.version),
               :diff => wiki_content.page.diff(wiki_content.version.to_i)
          render_multipart('wiki_content_updated', body)
        end

      end
    end
  end
end