if not BG then BG = {} end
BG.bingo_active=true
BG.challenges_generated=false
BG.Progress = {}
BG.Gameplay = {}
BG.UI = {}
BG.Challenges = {
  {
    name="4 Eights",
    text=function() return {
      "Play a hand",
      "of 4 eights."
    } end
  },
  {
    name="x4 Mult",
    text=function() return {
      "Gain x4 mult",
      "from a single",
      "joker trigger."
    } end
  },
  {
    name="Narrow Deck",
    text=function() return {
      "Have 35 or",
      "fewer cards",
      "in your deck."
    } end
  },
  {
    name="Big Deck",
    text=function() return{
      "Have 70 or more",
      "cards in your",
      "deck."
    } end
  },
  {
    name="Early Vouchers",
    text=function() return {
      "Buy 3 vouchers",
      "before ante 4.",
      "(" .. tostring(BG.Progress["Early Vouchers"].num_early_vouchers) .. " bought so far.)"
    } end,
    --If there's a countable thing within a round, set it up in setup
    setup=function ()
      BG.Progress["Early Vouchers"].num_early_vouchers=0
    end
  },
  {
    name="No Early Jokers",
    text=function() return {
      "Clear ante 2",
      "before obtaining",
      "any jokers."
    } end,
    setup=function ()
      BG.Progress["No Early Jokers"].early_jokers_bought=false
    end,
    --If a condition could make this impossible in the current run, check here.
    impossible=function()
      return BG.Progress["No Early Jokers"].early_jokers_bought
    end
  },
  {
    name="Win",
    text=function() return {
      "Clear ante 8."
    } end
  },
  {
    name="Disable Boss",
    text=function() return {
      "Disable a",
      "boss blind."
    } end
  },
  {
    name="Retriggers",
    text=function() return {
      "Retrigger 5",
      "cards in a",
      "single hand."
    } end,
    setup=function ()
      BG.Progress["Retriggers"].retriggers_current_hand=0
    end
  },
  {
    name="Debt",
    text=function() return {
      "Go into $15",
      "of debt."
    } end,
  },
  {
    name="Skip",
    text=function() return {
      "Skip all small",
      "and large blinds",
      "for 3 consecutive",
      "antes.",
      "(" .. tostring(BG.Progress["Skip"].consecutive_blinds_skipped) .. " skipped so far.)"
    } end,
    setup=function()
      BG.Progress["Skip"].consecutive_blinds_skipped=0
    end
  },
  {
    name="Rich",
    text=function() return {
      "Have $150."
    } end
  },
  {
    name="Big Sale",
    text=function() return {
      "Sell a joker",
      "for $10 or more."
    } end
  },
  {
    name="Royal Flush",
    text=function() return {
      "Play a Royal Flush."
    } end
  },
  {
    name="Five of a Kind",
    text=function() return {
      "Play a Five",
      "of a Kind."
    } end
  },
  {
    name="Stocks",
    text=function() return {
      "Gain $25 at",
      "the end of a",
      "round."
    } end
  },
  {
    name="Single Tap",
    text=function() return {
      "Beat a boss blind",
      "by playing a single",
      "high card."
    } end
  },
  {
    name="Pretty High Level",
    text=function() return {
      "Get a poker hand",
      "to level 15."
    } end
  },
  {
    name="Rising Power",
    text=function() return {
      "Upgrade the same",
      "poker hand 3 times",
      "in one round."
    } end,
    setup=function ()
      --TODO: Populate table with each type of hand
      BG.Progress["Rising Power"].poker_hands_upgraded_this_round = {}
    end
  },
  {
    name="High Score",
    text=function() return {
      "Score 2 million",
      "points from a single",
      "hand."
    } end
  },
  {
    name="Rarity",
    text=function() return {
      "Have 4 rare jokers."
    } end
  },
  {
    name="Steely",
    text=function() return {
      "Trigger 5 steel",
      "cards in one hand."
    } end,
    setup=function ()
      BG.Progress["Steely"].steel_cards_triggered_current_hand=0
    end
  },
  {
    name="Lucky",
    text=function() return {
      "Trigger 10",
      "lucky cards.",
      "(" .. tostring(BG.Progress["Lucky"].lucky_cards_triggered) .. " triggered so far.)"
    } end,
    setup=function ()
      BG.Progress["Lucky"].lucky_cards_triggered=0
    end
  },
  {
    name="Chippy",
    text=function() return {
      "Get 500 chips",
      "from one hand."
    } end
  },
  {
    name="Seals",
    text=function() return {
      "Play a hand",
      "containing every",
      "seal."
    } end
  }
}

BG.Gameplay.active_challenges = {}

function BG.Gameplay.get_challenges()
  -- TODO: Shuffle then return first 25.
  return {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25}
end

function BG.Gameplay.setup_challenges()
  local challenge_numbers = BG.Gameplay.get_challenges()
  BG.Gameplay.active_challenges = {}
  for index, value in ipairs(challenge_numbers) do
    local challenge = BG.Challenges[value]
    sendTraceMessage("Setting up progress for " .. challenge.name, "BalingoLog")
    BG.Progress[challenge.name]={
      completed=false,
      impossible=false
    }
    if challenge.setup ~= nil then challenge.setup() end
    BG.Gameplay.active_challenges[index]=challenge
  end
end

function BG.UI.get_challenge_box(index)
  local children = {}
  if not BG.challenges_generated then
    BG.Gameplay.setup_challenges()
    BG.challenges_generated=true
  end
  local challenge = BG.Challenges[index]
  local progress = BG.Progress[challenge.name]
  local colour = progress.completed and G.C.GREEN or (progress.impossible and G.C.RED or G.C.BLACK)
  for i,text in ipairs(challenge.text()) do
    table.insert(children,{
      n=G.UIT.R,
      config={},
      nodes={
        {
          n=G.UIT.T,
          config={align="tl",text=text,colour=colour,scale=0.35}
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
  local ch = BG.Gameplay.get_challenges()
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

function BG.Gameplay.set_impossible(challenge_name)
  BG.Progress[challenge_name].impossible=true
end

function BG.Gameplay.set_complete(challenge_name)
  sendTraceMessage("Completed Challenge " .. challenge_name, "BingoLog")
  BG.Progress[challenge_name].completed=true
end

local check_for_unlock_old = check_for_unlock
-- When adding new things, add new types to check_for_unlock so all the logic stays together
check_for_unlock = function(args)
  local ret = check_for_unlock_old(args)
  -- sendTraceMessage("Got to check_for_unlock","BingoLog")
  if args.type=="hand_contents" then
    -- sendTraceMessage("Got to hand_contents","BingoLog")
    if #args.cards == 4 then
      -- sendTraceMessage("Got to correct args.cards","BingoLog")
      local all_eights=true
      for j=1,#args.cards do
        if args.cards[j]:get_id() ~= 8 then
          all_eights=false
        end
      end
      if all_eights then
        ret=true
        BG.Gameplay.set_complete("4 Eights")
      end
    end
  end
  return ret
end