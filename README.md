# trello-kanban

This project is an attempt to create Kanban metrics based on a trello board.  The CFD is based on naive card counts however the goal is to perform actual tracking of state changes in and out to calculate Cycle Time and Lead Time averages.

# Installation

* Clone the repository off of github.  I recommend using the `/srv` directory
* Modify the config file (see config section below)
* Execute `bundle install` from the root directory of the newly cloned project.
* For a daemonized process execute `bundle exec ruby runner.rb start` or for a forground process run `bundle exec ruby lib\kanban.rb`
* Properly daemonize or use upstart to convert into a restartable service.

# Configuration

COMING SOON!