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
      "Play a Five",
      "of a Kind."
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
  },
  {
    name="Seals",
    text={
      "Play a hand",
      "containing every",
      "seal."
    }
  }
}

function BG.UI.get_challenges()
  -- TODO: Shuffle then return first 25.
  return {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25}
end

function BG.UI.get_challenge_box(index)
  local children = {}
  sendTraceMessage("Got to " .. tostring(index), "BingoLog")
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
    config={align="cm",minh=1.5,maxh=1.5,minw=2.0,maxw=2.0,padding=0.05,r=0.1,hover=true,colour=G.C.WHITE,shadow=true},
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
  local ch = BG.UI.get_challenges()
  return {
    n=G.UIT.ROOT, 
    config={align="tl", minw=3, padding = 0.1, r=0.1, color=G.C.CLEAR},
    nodes={
      {
        n=G.UIT.R,
        config={align="tl",padding=0.2},nodes=
          {
            BG.UI.get_challenge_box(ch[1]),
            BG.UI.get_challenge_box(ch[2]),
            BG.UI.get_challenge_box(ch[3]),
            BG.UI.get_challenge_box(ch[4]),
            BG.UI.get_challenge_box(ch[5])
          }
      },
      {
        n=G.UIT.R,
        config={align="tl",padding=0.2},nodes=
          {
            BG.UI.get_challenge_box(ch[6]),
            BG.UI.get_challenge_box(ch[7]),
            BG.UI.get_challenge_box(ch[8]),
            BG.UI.get_challenge_box(ch[9]),
            BG.UI.get_challenge_box(ch[10])
          }
      },
      {
        n=G.UIT.R,
        config={align="tl",padding=0.2},nodes=
          {
            BG.UI.get_challenge_box(ch[11]),
            BG.UI.get_challenge_box(ch[12]),
            BG.UI.get_challenge_box(ch[13]),
            BG.UI.get_challenge_box(ch[14]),
            BG.UI.get_challenge_box(ch[15])
          }
      },
      {
        n=G.UIT.R,
        config={align="tl",padding=0.2},nodes=
          {
            BG.UI.get_challenge_box(ch[16]),
            BG.UI.get_challenge_box(ch[17]),
            BG.UI.get_challenge_box(ch[18]),
            BG.UI.get_challenge_box(ch[19]),
            BG.UI.get_challenge_box(ch[20])
          }
      },
      {
        n=G.UIT.R,
        config={align="tl",padding=0.2},nodes=
          {
            BG.UI.get_challenge_box(ch[21]),
            BG.UI.get_challenge_box(ch[22]),
            BG.UI.get_challenge_box(ch[23]),
            BG.UI.get_challenge_box(ch[24]),
            BG.UI.get_challenge_box(ch[25])
        }
      }
    }
  }
end