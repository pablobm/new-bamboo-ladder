run = ->
  min = $('[data-min]').data('min')
  max = $('[data-max]').data('max')
  height = $('.rankings-entry').height()/2
  $('.sparkline').peity('line', {min, max, height, width: 200})

jQuery(run)
$(document).on('page:load', run)
