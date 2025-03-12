if not BG then BG = {} end
BG.bingo_active=true
BG.UI = {}

function G.UIDEF.run_info()
  local page_obj = {tabs = {
      {
        label = localize('b_poker_hands'),
        chosen = true,
        tab_definition_function = create_UIBox_current_hands,
      },
      {
        label = localize('b_blinds'),
        tab_definition_function = G.UIDEF.current_blinds,
      },
      {
          label = localize('b_vouchers'),
          tab_definition_function = G.UIDEF.used_vouchers,
      },
    },
    tab_h = 8,
    snap_to_nav = true
  }
  if G.GAME.stake > 1 then
    table.insert(page_obj.tabs,{
      label = localize('b_stake'),
      tab_definition_function = G.UIDEF.current_stake,
    })
  end
  if BG.bingo_active then
    table.insert(page_obj.tabs,{
      label = "Bingo",
      tab_definition_function = BG.UI.BoardDisplay
    })
  end
  return create_UIBox_generic_options({contents ={create_tabs(
    page_obj
    )}})
end

function BG.UI.BoardDisplay()

end