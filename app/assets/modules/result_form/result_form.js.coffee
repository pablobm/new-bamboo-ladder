run = ->
  $(document).on 'click', '.result-form-link a', toggle
  toggle()

rerun = ->
  toggle()

toggle = (evt) ->
  if evt
    evt.preventDefault()
  form = $('.result-form')
  form.toggleClass('is-hidden')

jQuery(document).on 'page:load', rerun
jQuery(run)
