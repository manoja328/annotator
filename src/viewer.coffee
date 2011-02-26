
class Annotator.Viewer extends Delegator
  events:
    ".annotator-controls .annotator-edit click":   "controlEditClick"
    ".annotator-controls .annotator-delete click": "controlDeleteClick"

  html:
    element:"""
            <div class="annotator-outer annotator-viewer">
              <ul class="annotator-widget"></ul>
            </div>
            """
    item:   """
            <li class="annotator-annotation">
              <span class="annotator-controls">
                <button class="annotator-edit">Edit</button>
                <button class="annotator-delete">Delete</button>
              </span>
            </li>
            """

  constructor: (options) ->
    super $(@html.element)[0], options

    @item   = $(@html.item)[0]
    @fields = []
    @annotations = []

    # Setup the default view field.
    this.addField({
      type: 'textarea',
      load: (field, annotation) ->
        $(field).escape(annotation.text || '')
    })

  show: (event) =>
    event?.preventDefault()
    $(@element).removeClass('annotator-hide').trigger('show')

  hide: (event) =>
    event?.preventDefault()
    $(@element).addClass('annotator-hide').trigger('hide')

  load: (annotations) =>
    @annotations = annotations || []

    list = $(@element).find('ul:first').empty()
    for annotation in @annotations
      item = $(@item).clone().appendTo(list)
      for field in @fields
        element = $(field.element).clone().appendTo(item).data('annotation', annotation)[0]
        field.load(element, annotation)

    $(@element).trigger('load', [@annotations])

    this.show();

  addField: (options) ->
    field = $.extend({
      load: ->
    }, options)

    field.element = $('<div />')[0]
    @fields.push field.element
    field.element

  onEditClick: (event) =>
    this.onButtonClick(event, 'edit')

  onDeleteClick: (event) =>
    this.onButtonClick(event, 'delete')

  onButtonClick: (event, type) ->
    item = $(event.target).parents('.annotator-annotation')

    $(@element).trigger(type, [item.data('annotation')])
