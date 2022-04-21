# frozen_string_literal: true

desc ''
task do_something: :environment do
  CronJobs.do_something!
end
