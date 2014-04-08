$ ->
	# --------------------------------
	# Model

	###
	# Task
	###
	Task = Backbone.Model.extend
		defaults:
			done: false

		urlRoot: '/tasks'

		url: () ->
			if @id
				"#{@urlRoot}/#{@id}.json"
			else
				"#{@urlRoot}.json"

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

		url: '/tasks.json'

		onlyDone: () ->
			return @filter((task, index) -> return task.isDone())

		notDone: () ->
			return @filter((task, index) -> return not task.isDone())

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
			@listenTo(@model, 'change', @render)
			@listenTo(@model, 'remove', @remove)
			@listenTo(@model, 'request', => @$el.addClass('is-loading'))
			@listenTo(@model, 'sync', => @$el.removeClass('is-loading'))
			@listenTo(@model, 'error', => @$el.removeClass('is-loading'))

		render: () ->
			task = @model
			$task = $(@templateHtml)
			$task.find('[name=done]')
				.prop('checked', task.get('done'))
			$task.find('.js-title')
				.text(task.get('title'))
			$task.toggleClass('is-done', task.isDone())

			@$el.replaceWith($task)
			@setElement($task)

			return @

		onchange: (event) ->
			$done = @$('[name=done]')
			done = $done.prop('checked')
			@model.save({ done })

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
				task.save()
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
			@listenTo(tasks, 'reset add change', @count)

			@$remains = @$('.js-tasks-index-remain')
			@$list = @$('.js-tasks-index-list')

			tasks.each (task, index) =>
				@addTask(task)

		addTask: (task, tasks) ->
			taskView = new TaskView({ model:task })
			taskView.render().$el.prependTo(@$list)

		clean: (event) ->
			tasks = @tasks
			tasks.onlyDone().forEach (task, index) ->
				task.destroy()

		count: () ->
			remains = @tasks.notDone().length
			@$remains.text(remains)

	#
	# main
	#
	do () ->
		# ----------------
		# models

		tasks = new TaskCollection()

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

		tasks.fetch({ reset:true })
