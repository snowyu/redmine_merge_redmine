class SourceTimeEntry < ActiveRecord::Base
  include SecondDatabase
  set_table_name :time_entries

  belongs_to :user, :class_name => 'SourceUser', :foreign_key => 'user_id'
  belongs_to :project, :class_name => 'SourceProject', :foreign_key => 'project_id'
  belongs_to :issue, :class_name => 'SourceIssue', :foreign_key => 'issue_id'

  def self.migrate
    all.each do |source_time_entry|
      te = TimeEntry.new
      te.attributes = source_time_entry.attributes
      te.user = User.find_by_login(source_time_entry.user.login)
      te.project = Project.find_by_name(source_time_entry.project.name)

      # optional 
      te.issue = Issue.find_by_id(RedmineMerge::Mapper.get_new_issue_id(source_time_entry.issue.id)) if source_time_entry.issue_id
      te.save!
    end
  end
end