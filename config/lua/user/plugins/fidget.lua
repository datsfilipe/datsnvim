return {
  event = 'LspAttach',
  setup = function()
    require('fidget').setup { progress = { display = { done_icon = 'OK' } } }
  end,
}
