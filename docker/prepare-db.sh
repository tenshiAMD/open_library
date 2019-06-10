#! /bin/bash

# If database exists, migrate. Otherwise create and seed
bundle exec rake db:environment:set 2>/dev/null
bundle exec rake db:migrate || bundle exec rake db:setup db:seed
echo "Done!"