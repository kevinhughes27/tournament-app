class Admin.ScheduleEditor

  constructor: ->
    @initDraggable()
    @initDropzone()

  initDraggable: ->
    interact('.draggable').draggable({
      inertia: true,

      restrict:
        restriction: "parent",
        endOnly: true,
        elementRect: { top: 0, left: 0, bottom: 1, right: 1 }

      onmove: (event) ->
        target = event.target

        # keep the dragged position in the data-x/data-y attributes
        x = (parseFloat(target.getAttribute('data-x')) || 0) + event.dx
        y = (parseFloat(target.getAttribute('data-y')) || 0) + event.dy

        # translate the element
        target.style.webkitTransform =
        target.style.transform =
          'translate(' + x + 'px, ' + y + 'px)'

        # update the posiion attributes
        target.setAttribute('data-x', x)
        target.setAttribute('data-y', y)
    })

  initDropzone: ->
      interact('.dropzone').dropzone({
      accept: '#game',
      overlap: 0.2,

      ondropactivate: (event) ->
        event.target.classList.add('drop-active')

      ondragenter: (event) ->
        draggableElement = event.relatedTarget
        dropzoneElement = event.target

        dropzoneElement.classList.add('drop-target')
        draggableElement.classList.add('can-drop')
        draggableElement.textContent = 'Dragged in'

      ondragleave: (event) ->
        event.target.classList.remove('drop-target')
        event.relatedTarget.classList.remove('can-drop')
        event.relatedTarget.textContent = 'Dragged out'

      ondrop: (event) ->
        event.relatedTarget.textContent = 'Dropped'

      ondropdeactivate: (event) ->
        event.target.classList.remove('drop-active')
        event.target.classList.remove('drop-target')
    })

  saveSchedule: ->
