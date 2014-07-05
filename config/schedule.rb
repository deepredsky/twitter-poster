# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :output, File.expand_path(File.join(File.dirname(__FILE__), '..', 'cron.log'))

every 1.hour do
  command %{#{File.expand_path(File.join(File.dirname(__FILE__), '..', 'bin', 'retweet'))} "#nepal #travel -rt"}
end

every 2.hours do
  command %{#{File.expand_path(File.join(File.dirname(__FILE__), '..', 'bin', 'retweet'))} "#quote #philosophy -rt"}
end

every 3.hour do
  command %{#{File.expand_path(File.join(File.dirname(__FILE__), '..', 'bin', 'retweet'))} "#vim -rt"}
end

every 4.hour do
  command %{#{File.expand_path(File.join(File.dirname(__FILE__), '..', 'bin', 'retweet'))} "#ruby #programming -rt"}
end

every 1.hour do
  command %{#{File.expand_path(File.join(File.dirname(__FILE__), '..', 'bin', 'retweet'))} "#funny #quote -rt"}
end
