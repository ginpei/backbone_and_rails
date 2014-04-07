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

		isDone: () ->
			return !!@get('done')

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
			<li class="task">
				<label>
					<input type="checkbox" name="done" />
					<span class="js-title"></span>
				</label>
			</li>
			'''

		events:
			'change [name=done]': 'onchange'

		initialize: (options) ->
			@listenTo(@model, 'change', @update)
			@listenTo(@model, 'remove', @remove)

		render: () ->
			$task = $(@templateHtml)
			$task.find('[name=done]')
				.prop('checked', @model.get('done'))
			$task.find('.js-title')
				.text(@model.get('title'))

			@$el.replaceWith($task)
			@setElement($task)

			return @

		onchange: (event) ->
			$done = @$('[name=done]')
			done = $done.prop('checked')
			@model.set('done', done)

		update: (task) ->
			@render()
			@$el.toggleClass('is-done', task.isDone())

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
		events:
			'click .js-tasks-index-clear': 'clean'

		initialize: (options) ->
			tasks = @tasks = options.tasks
			@listenTo(tasks, 'add', @addTask)
			@listenTo(tasks, 'add', @count)
			@listenTo(tasks, 'change', @count)

			@$remains = @$('.js-tasks-index-remain')
			@$list = @$('.js-tasks-index-list')

			tasks.each (task, index) =>
				@addTask(task)

		addTask: (task, tasks) ->
			taskView = new TaskView({ model:task })
			taskView.render().$el.prependTo(@$list)

		clean: (event) ->
			tasks = @tasks
			@tasks.forEach (task, index) ->
				if task.isDone()
					tasks.remove(task)

		count: () ->
			remains = @tasks.filter((task, index) -> return not task.isDone()).length
			@$remains.text(remains)

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
		taskListView.count()
