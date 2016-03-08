# trello-kanban

This project is an attempt to create Kanban metrics based on a trello board.  The CFD is based on naive card counts however the goal is to perform actual tracking of state changes in and out to calculate Cycle Time and Lead Time averages.

# Installation

* Clone the repository off of github.  I recommend using the `/srv` directory
* Modify the config file (see config section below)
* Execute `bundle install` from the root directory of the newly cloned project.
* For a daemonized process execute `bundle exec ruby runner.rb start` or for a forground process run `bundle exec ruby lib\kanban.rb`
* Properly daemonize or use upstart to convert into a restartable service.

# Configuration

Configuration is the mechanism used to pull from the wild wooly world of trello.

The configuration is not order dependent but is in [YAML](http://yaml.org) format.  The structure/example used below explains what the system needs to know.

```
member: [TRELLO USER ID GOES HERE]
key: [TRELLO USER KEY GOES HERE SEE: http://www.rubydoc.info/gems/ruby-trello/Trello]
token: [TRELLO TOKEN GOES HERE SEE: http://www.rubydoc.info/gems/ruby-trello/Trello]
datadir: [LOCAL DIRECTORY YOU WANT DATA SAVED TO]
daily_cfd_schedule: 0 0 * * *
boards:
   -
      name: [TRELLO BOARD YOU WANT TRACKED]
      type: kanban
      exclude_columns: [LIST OF COLUMNS BY NAMES TO IGNORE]
      lead_time:
         start: 'created_date'
         end: [NAME OF COLUMN ON BOARD THAT MARKS 'DONE' STATE]
      cycle_time:
         start: [NAME OF COLUMN ON BOARD THAT MARKS THE START OF WORK ON A CARD]
         end: [NAME OF COLUMN ON BOARD THAT MARKS 'DONE' STATE]
      graphdef:
         element: 'uv-div'
         xkey: 'date_time'
         hideHover: 'auto'
         resize: true
         lineColors: ['green', 'yellow', 'red', 'grey', 'blue']
         parseTime: false

```

## User Configuration

The first 3 lines of the example contain the user information for logging into trello.  Per the example refer to the [ruby trello documentation](http://www.rubydoc.info/gems/ruby-trello/Trello) on how to get this information.

```
member: [TRELLO USER ID GOES HERE]
key: [TRELLO USER KEY GOES HERE SEE: http://www.rubydoc.info/gems/ruby-trello/Trello]
token: [TRELLO TOKEN GOES HERE SEE: http://www.rubydoc.info/gems/ruby-trello/Trello]
```

## System Configuration

### The Data Directory

It is expected that you supply a directory (which exists) for the files which back the board to be written to.

```
datadir: [LOCAL DIRECTORY YOU WANT DATA SAVED TO]
```

### Daily Schedule

Using standard cron per [Rufus Scheduler](https://github.com/jmettraux/rufus-scheduler#in-at-every-interval-cron) which uses the fairly standard [cron expressions](https://en.wikipedia.org/wiki/Cron#CRON_expression) common to most languages.  By default I have this scheduled to occur at midnight.  There are no limitations built into teh system to limit your scheduling on pulling and persisting from Trello but the system is optimized for daily pulls.

```
daily_cfd_schedule: 0 0 * * *
```

### Boards

Boards is a portion of the configuration that defines a list of boards you wish to track.  It is intended to eventually track both kanban and scrum style boards.  Right now only kanban is supported.

The boards form a list of objects that represent individual boards.

* Name: This is the actual name of the board you wish to use.  Realize that special characters in board names are NOT TESTED.  I do not guarantee they are supported.
* Type: [Allowed Values: kanban/scrum] Defines the board as being kanban or scrum.  Currently only kanban is really supported but soon we will support both.
* Excluded Columns: Columns that are to be excluded from tracking.  By default every column will be tracked as a viable Kanban work state.
* Lead Time: The definition of the start and end of how lead time is tracked.  By default the start is configured to be `created_date` and end is the column name you select (for example 'Done' or 'In Progress').
* Cycle Time: Similarly you define the start and end times.  Per kanban rules this should be when it starts being worked on and when it is done (and that should match the done of Lead Time).
* Graph Definition: This is graph definition per [Morris JS](http://morrisjs.github.io/morris.js/).  You can play with these settings as you desire.  The necessary bits are concatenated to this config at run time by the system (i.e. column labels).  The most interesting bit is probably the `lineColors` setting.  For each column being tracked you need to list a color.  By convention the right most column (the 'done' column) is listed first and the first column (i.e. 'backlog' for example) is listed last.

```
boards:
   -
      name: [TRELLO BOARD YOU WANT TRACKED]
      type: kanban
      exclude_columns: [LIST OF COLUMNS BY NAMES TO IGNORE]
      lead_time:
         start: 'created_date'
         end: [NAME OF COLUMN ON BOARD THAT MARKS 'DONE' STATE]
      cycle_time:
         start: [NAME OF COLUMN ON BOARD THAT MARKS THE START OF WORK ON A CARD]
         end: [NAME OF COLUMN ON BOARD THAT MARKS 'DONE' STATE]
      graphdef:
         element: 'uv-div'
         xkey: 'date_time'
         hideHover: 'auto'
         resize: true
         lineColors: ['green', 'yellow', 'red', 'grey', 'blue']
         parseTime: false

```
