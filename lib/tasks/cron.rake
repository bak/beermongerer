task :cron do
  puts "Building data file at #{Time.now} ..."
  Beermongerer::DataFile.test
  puts "done."
end
