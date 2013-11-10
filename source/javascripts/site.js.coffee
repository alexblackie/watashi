#-----------------------------------------------------------------------------
# Menu toggle
#-----------------------------------------------------------------------------
menuToggle = document.getElementById('main-menu-toggle')

menuToggle.addEventListener 'click', (e) ->
  document.body.classList.toggle 'main-menu-open'
