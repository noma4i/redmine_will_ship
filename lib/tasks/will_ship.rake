namespace :redmine do
  namespace :will_ship do
    desc 'Removes uploaded files left unattached after one day.'
    task :check_harbors => :environment do
      Project.all.each do |p|
        next unless p.harbors.any?
        p.issues.where('updated_on > ?', 1.week.ago).each do |i|
          i.check_harbors!
        end
      end
    end
  end
end