$ ->
	# --------------------------------
	# Model

	###
	# Task
	###
	Task = Backbone.Model.extend
		defaults:
			done: false

		validate: (attributes) ->
			unless attributes.title
				return 'title is required'

		isChecked: () ->
			return !!@get('checked')

	# --------------------------------
	# Collection

	###
	# TaskCollection
	###
	TaskCollection = Backbone.Collection.extend
		model: Task

	# --------------------------------
	# View

	###
	# TaskView
	###
	TaskView = Backbone.View.extend
		templateHtml: '''
			<li>
				<label>
					<input type="checkbox" />
					<span class="js-title"></span>
				</label>
			</li>
			'''

		render: () ->
			$task = $(@templateHtml)
			$task.find('.js-title')
				.text(@model.get('title'))
			@setElement($task)
			return @

	###
	# TaskFormView
	###
	TaskFormView = Backbone.View.extend
		events:
			'submit': 'onsubmit'

		initialize: (options) ->
			@tasks = options.tasks

		onsubmit: (event) ->
			event.preventDefault()

			title = @$('[name=title]').val()
			task = new Task({ title })
			if task.isValid()
				@tasks.add(task)
				@$el[0].reset()

	###
	# TaskListView
	###
	TaskListView = Backbone.View.extend
		initialize: (options) ->
			tasks = @tasks = options.tasks
			@listenTo(tasks, 'add', @addTask)

			tasks.each (task, index) =>
				@addTask(task)

		addTask: (task, tasks) ->
			taskView = new TaskView({ model:task })
			taskView.render().$el.prependTo(@$el)

	#
	# main
	#
	do () ->
		# ----------------
		# models

		tasks = new TaskCollection([
			{ title:'Buy milk' }
			{ title:'But 8 eggs' }
		])

		# ----------------
		# views

		$form = $('.js-tasks-new')
		taskFormView = new TaskFormView({
			el: $form,
			tasks: tasks
		})

		$list = $('.js-tasks-index')
		taskListView = new TaskListView({
			el: $list,
			tasks: tasks
		})
