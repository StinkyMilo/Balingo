if not BG then BG = {} end
BG.bingo_active=true
BG.UI = {}
BG.Challenges = {
  {
    name="4 Eights",
    text={
      "Play a hand",
      "of 4 eights."
    }
  },
  {
    name="x4 Mult",
    text={
      "Gain x4 mult",
      "from a single",
      "joker trigger."
    }
  },
  {
    name="Narrow Deck",
    text={
      "Have 35 or",
      "fewer cards",
      "in your deck."
    }
  },
  {
    name="Big Deck",
    text={
      "Have 70 or more",
      "cards in your",
      "deck."
    }
  },
  {
    name="Early Vouchers",
    text={
      "Buy 3 vouchers",
      "before ante 4."
    }
  },
  {
    name="No Early Jokers",
    text={
      "Clear ante 2",
      "before obtaining",
      "any jokers."
    }
  },
  {
    name="Win",
    text={
      "Clear ante 8."
    }
  },
  {
    name="Disable Boss",
    text={
      "Disable a",
      "boss blind."
    }
  },
  {
    name="Retriggers",
    text={
      "Retrigger 5",
      "cards in a",
      "single hand."
    }
  },
  {
    name="Debt",
    text={
      "Go into $15",
      "of debt."
    }
  },
  {
    name="Skip",
    text={
      "Skip all small",
      "and large blinds",
      "for 3 consecutive",
      "antes."
    }
  },
  {
    name="Rich",
    text={
      "Have $150."
    }
  },
  {
    name="Big Sale",
    text={
      "Sell a joker",
      "for $10 or more."
    }
  },
  {
    name="Royal Flush",
    text={
      "Play a Royal Flush."
    }
  },
  {
    name="Five of a Kind",
    text={
      "Play a Five of a Kind."
    }
  },
  {
    name="Stocks",
    text={
      "Gain $25 at",
      "the end of a",
      "round."
    }
  },
  {
    name="Single Tap",
    text={
      "Beat a boss blind",
      "by playing a single",
      "high card."
    }
  },
  {
    name="Pretty High Level",
    text={
      "Get a poker hand",
      "to level 15."
    }
  },
  {
    name="Rising Power",
    text={
      "Upgrade the same",
      "poker hand 3 times",
      "in one round."
    }
  },
  {
    name="High Score",
    text={
      "Score 2 million",
      "points from a single",
      "hand."
    }
  },
  {
    name="Rarity",
    text={
      "Have 4 rare cards."
    }
  },
  {
    name="Steely",
    text={
      "Trigger 5 steel",
      "cards in one hand."
    }
  },
  {
    name="Lucky",
    text={
      "Trigger 10",
      "lucky cards."
    }
  },
  {
    name="Chippy",
    text={
      "Get 500 chips",
      "from one hand."
    }
  }
}

function BG.UI.get_challenge_box(index)
  local children = {}
  for i,text in pairs(BG.Challenges[index].text) do
    table.insert(children,{
      n=G.UIT.R,
      config={},
      nodes={
        {
          n=G.UIT.T,
          config={align="tl",text=text,colour=G.C.BLACK,scale=0.35}
        }
      }
    })
  end
  local root_node = {
    n=G.UIT.C,
    config={align="cm",minh=1.5,minw=2,padding=0.05,r=0.1,hover=true,colour=G.C.WHITE,shadow=true},
    nodes=children
  }
  return root_node
end

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
  return {
    n=G.UIT.ROOT, 
    config={align="tl", minw=3, padding = 0.1, r=0.1, color=G.C.CLEAR},
    nodes={
      {
        n=G.UIT.R,
        config={align="tl",padding=0.3},nodes=
          {
            BG.UI.get_challenge_box(1),
            BG.UI.get_challenge_box(2),
            {
              n=G.UIT.C,
              config={align="cm",minh=1.5,minw=1.5,padding=0.05,r=0.1,hover=true,colour=G.C.WHITE,shadow=true},
              nodes={
                {
                  n=G.UIT.T,
                  config={text="3",colour=G.C.BLACK, scale = 0.4}
                }
              }
            },
            {
              n=G.UIT.C,
              config={align="cm",minh=1.5,minw=1.5,padding=0.05,r=0.1,hover=true,colour=G.C.WHITE,shadow=true},
              nodes={
                {
                  n=G.UIT.T,
                  config={text="4",colour=G.C.BLACK, scale = 0.4}
                }
              }
            },
            {
              n=G.UIT.C,
              config={align="cm",minh=1.5,minw=1.5,padding=0.05,r=0.1,hover=true,colour=G.C.WHITE,shadow=true},
              nodes={
                {
                  n=G.UIT.T,
                  config={text="5",colour=G.C.BLACK, scale = 0.4}
                }
              }
            }
          }
      },
      {
        n=G.UIT.R,
        config={align="tl",padding=0.1},nodes=
          {
            {
              n=G.UIT.T,
              config={text="6",colour=G.C.WHITE, scale = 0.4}
            },
            {
              n=G.UIT.T,
              config={text="7",colour=G.C.WHITE, scale = 0.4}
            },
            {
              n=G.UIT.T,
              config={text="8",colour=G.C.WHITE, scale = 0.4}
            },
            {
              n=G.UIT.T,
              config={text="9",colour=G.C.WHITE, scale = 0.4}
            },
            {
              n=G.UIT.T,
              config={text="10",colour=G.C.WHITE, scale = 0.4}
            }
          }
      },
      {
        n=G.UIT.R,
        config={align="tl",padding=0.1},nodes=
          {
            {
              n=G.UIT.T,
              config={text="11",colour=G.C.WHITE, scale = 0.4}
            },
            {
              n=G.UIT.T,
              config={text="12",colour=G.C.WHITE, scale = 0.4}
            },
            {
              n=G.UIT.T,
              config={text="13",colour=G.C.WHITE, scale = 0.4}
            },
            {
              n=G.UIT.T,
              config={text="14",colour=G.C.WHITE, scale = 0.4}
            },
            {
              n=G.UIT.T,
              config={text="15",colour=G.C.WHITE, scale = 0.4}
            }
        }
      },
      {
        n=G.UIT.R,
        config={align="tl",padding=0.1},nodes=
          {
            {
              n=G.UIT.T,
              config={text="16",colour=G.C.WHITE, scale = 0.4}
            },
            {
              n=G.UIT.T,
              config={text="17",colour=G.C.WHITE, scale = 0.4}
            },
            {
              n=G.UIT.T,
              config={text="18",colour=G.C.WHITE, scale = 0.4}
            },
            {
              n=G.UIT.T,
              config={text="19",colour=G.C.WHITE, scale = 0.4}
            },
            {
              n=G.UIT.T,
              config={text="20",colour=G.C.WHITE, scale = 0.4}
            }
        }
      },
      {
        n=G.UIT.R,
        config={align="tl",padding=0.1},nodes=
          {
            {
              n=G.UIT.T,
              config={text="21",colour=G.C.WHITE, scale = 0.4}
            },
            {
              n=G.UIT.T,
              config={text="22",colour=G.C.WHITE, scale = 0.4}
            },
            {
              n=G.UIT.T,
              config={text="23",colour=G.C.WHITE, scale = 0.4}
            },
            {
              n=G.UIT.T,
              config={text="24",colour=G.C.WHITE, scale = 0.4}
            },
            {
              n=G.UIT.T,
              config={text="25",colour=G.C.WHITE, scale = 0.4}
            }
        }
      }
    }
  }
end