# Backbone and Rails

A sample for Backbone.js with Ruby on Rails to learn client side scripting throw Backbone.js.

This is a simple TODO app without changing nor reloading page. This app presents following actions:

* Add a task.
* Check a task to done.
* Remove all checked tasks.
* Counts not-checked tasks.

You can see how backbone works in [app/assets/javascripts/tasks.js.coffee](app/assets/javascripts/tasks.js.coffee).


## Getting Started

```
git clone git@github.com:ginpei/backbone_and_rails.git
cd backbone_and_rails
bundle
rake db:migrate
rails s
```

And open front page (maybe http://localhost:3000) on your web broweser.

## Relations in client side

```
Model World           /      View World
                      \      +------------+
                    +--------|TaskFormView|
                    | \      +------------+
+--------------+<---+ /      +------------+
|TaskCollection|<------------|TaskListView|
|0:+----------+|      /      |  +--------+|
|  |Task      |<----------------|TaskView||
|  +----------+|      /      |  +--------+|
|1:+----------+|      \      |  +--------+|
|  |Task      |<----------------|TaskView||
|  +----------+|      \      |  +--------+|
+--------------+      /      +------------+

(B <-- A = A knows B)
```

### TaskFormView

knows TaskCollection and:

```
sends  add message  to TaskCollection  when submit
```

### TaskListView

knows TaskCollection and Task model that it contains, and:

```
sends     destroy message                 to each Task models  when clean
receives  add message                     from TaskCollection  to add item
receives  reset, add and change messages  from TaskCollection  to update counts
```

### TaskView

knows each Task models and:

```
sends     change message                    from Task  when checkbox is toggled
receives  change message                    from Task  to update own
receives  remove message                    from Task  to remove own
receives  request, sync and error messages  from Task  to show loading
```

## Commands

I built this rails app by following commands:

```bash
rails new backbone_and_rails
cd backbone_and_rails
rails g scaffold Task done:boolean title:string detail:text
```

