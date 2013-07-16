ResultForm =

  run: ->
    @toggle()
    @rerun()

  rerun: ->
    @link = $('.result-form-link')
    @link.on 'click', @toggle

  toggle: (evt) ->
    if evt
      evt.preventDefault()
    @form = $('.result-form')
    @form.toggleClass('is-hidden')

jQuery(document).on 'page:load', ->
  ResultForm.rerun()
jQuery ->
  ResultForm.run()
