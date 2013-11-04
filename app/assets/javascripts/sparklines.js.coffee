run = ->
  min = $('[data-min]').data('min')
  max = $('[data-max]').data('max')
  height = $('.rankings-entry').height()/2
  $('.sparkline').peity('line', {min, max, height, width: 100})

jQuery(run)
