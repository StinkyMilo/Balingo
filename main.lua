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
      "Clear ante 1",
      "before obtaining",
      "any jokers."
    } end
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
      "played cards in",
      "a single hand."
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
      "to level 12."
    } end
  },
  {
    name="Rising Power",
    text=function() return {
      "Upgrade the same",
      "poker hand twice",
      "during a round."
    } end,
    setup=function ()
      BG.Progress["Rising Power"].poker_hands_upgraded_this_round = BG.Gameplay.get_poker_hands_default()
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
      "type of seal."
    } end
  }
}

function BG.Gameplay.get_poker_hands_default()
  return {
    ["Flush Five"] = 0,
    ["Flush House"] = 0,
    ["Five of a Kind"] = 0,
    ["Straight Flush"] = 0,
    ["Four of a Kind"] = 0,
    ["Full House"] = 0,
    ["Flush"] = 0,
    ["Straight"] = 0,
    ["Three of a Kind"] = 0,
    ["Two Pair"] = 0,
    ["Pair"] = 0,
    ["High Card"] = 0
  }
end

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
  if not BG.Progress[challenge_name].completed then
    sendTraceMessage("Setting challenge " .. challenge_name .. " to impossible.","BingoLog")
    BG.Progress[challenge_name].impossible=true
  end
end

function BG.Gameplay.set_complete(challenge_name)
  if not BG.Progress[challenge_name].impossible then
    -- TODO: Little animation or somethin' (but only if the challenge is active)
    sendTraceMessage("Completed Challenge " .. challenge_name, "BingoLog")
    BG.Progress[challenge_name].completed=true
  end
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
  if args.type=="xmult_trigger" then
    sendTraceMessage("Xmult Mod found with amount " .. tostring(args.amount),"BingoLog")
    if args.amount>=4 then
      sendTraceMessage("Xmult mod >=4","BingoLog")
      BG.Gameplay.set_complete("x4 Mult")
    end
  end
  if args.type == 'modify_deck' then
    if G.deck and G.deck.config.card_limit <= 35 then
      BG.Gameplay.set_complete("Narrow Deck")
    end
    if G.deck and G.deck.config.card_limit >= 70 then
      BG.Gameplay.set_complete("Big Deck")
    end
  end
  if args.type == 'run_redeem' then
    local _v = 0
    _v = _v - (G.GAME.starting_voucher_count or 0)
    for k, v in pairs(G.GAME.used_vouchers) do
        _v = _v + 1
    end
    if G.GAME.round_resets.ante < 4 then
      BG.Progress["Early Vouchers"].num_early_vouchers = _v
      if _v >= 3 then
        BG.Gameplay.set_complete("Early Vouchers")
      end
    end
  end
  if args.type == 'ante_up' then
    if args.ante >= 4 then
      BG.Gameplay.set_impossible("Early Vouchers")
    end
    if args.ante == 2 then
      BG.Gameplay.set_complete("No Early Jokers")
    end
  end
  if args.type == 'joker_added' then
    if G.GAME.round_resets.ante <= 1 then
      BG.Gameplay.set_impossible("No Early Jokers")
    end
    local rares = 0
    for i = 1, #G.jokers.cards do
        if G.jokers.cards[i].config.center.rarity == 3 then
          rares = rares+1
        end
    end 
    if rares >= 4 then
      BG.Gameplay.set_complete("Rarity")
    end
  end
  if args.type == 'win' then
    BG.Gameplay.set_complete("Win")
  end
  if args.type == 'disable_blind' then
    BG.Gameplay.set_complete("Disable Boss")
  end
  if args.type == 'hand' then
    --Not sure if this is in the order I want but I think it'll work
    BG.Progress["Retriggers"].retriggers_current_hand=0
    -- A little weird but it'll work
    if G.GAME.blind and not G.GAME.blind:get_type() == 'Boss' then
      BG.Progress["Skip"].consecutive_blinds_skipped=0
    end
    if args.disp_text == "Royal Flush" then
      BG.Gameplay.set_complete("Royal Flush")
    end
    if args.handname == 'Five of a Kind' then
      BG.Gameplay.set_complete("Five of a Kind")
    end
  end
  if args.type == 'retrigger' then
    BG.Progress["Retriggers"].retriggers_current_hand = BG.Progress["Retriggers"].retriggers_current_hand + args.num_retriggers
    if BG.Progress["Retriggers"].retriggers_current_hand >= 5 then
      BG.Gameplay.set_complete("Retriggers")
    end
  end
  if args.type == 'money' then
    if G.GAME.dollars <= -15 then
      BG.Gameplay.set_complete("Debt")
    end
    if G.GAME.dollars >= 150 then
      BG.Gameplay.set_complete("Rich")
    end
  end
  if args.type == 'blind_skipped' then
    BG.Progress["Skip"].consecutive_blinds_skipped=BG.Progress["Skip"].consecutive_blinds_skipped+1
    if BG.Progress["Skip"].consecutive_blinds_skipped >= 6 then
      BG.Gameplay.set_complete("Skip")
    end
  end
  if args.type == "card_sold" then
    if args.sell_cost >= 10 then
      BG.Gameplay.set_complete("Big Sale")
    end
  end
  if args.type == "end_of_round_dollars" then
    if args.dollars >= 25 then
      BG.Gameplay.set_complete("Stocks")
    end
  end
  if args.type == 'round_win' then
    if G.GAME.current_round.hands_played == 1 and G.GAME.current_round.current_hand.handname == 'High Card' then
      BG.Gameplay.set_complete("Single Tap")
    end
    BG.Progress["Rising Power"].poker_hands_upgraded_this_round = BG.Gameplay.get_poker_hands_default()
  end
  if args.type == "upgrade_hand" then
    if args.level >= 12 then
      BG.Gameplay.set_complete("Pretty High Level")
    end
    if G.GAME.facing_blind then
      BG.Progress["Rising Power"].poker_hands_upgraded_this_round[args.hand]=BG.Progress["Rising Power"].poker_hands_upgraded_this_round[args.hand]+1
      if BG.Progress[args.hand] >= 2 then
        BG.Gameplay.set_complete("Rising Power")
      end
    end
  end
  if args.type == "chip_score" then
    if args.chips >= 2000000 then
      BG.Gameplay.set_complete("High Score")
    end
  end
  return ret
end

local calculate_joker_old = Card.calculate_joker
function Card:calculate_joker (context)
  local result = calculate_joker_old(self,context)
  sendTraceMessage("Calculating Joker","BingoLog")
  if result and result.Xmult_mod then
    sendTraceMessage("Xmult mod found","BingoLog")
    check_for_unlock({type="xmult_trigger",amount=result.Xmult_mod})
  end
  return result
end

local add_to_deck_old = Card.add_to_deck
function Card:add_to_deck (from_debuff)
  local result = add_to_deck_old(self,from_debuff)
  if not from_debuff and self.ability.set=='Joker' then
    check_for_unlock({type="joker_added",card=self})
  end
  return result
end

local disable_blind_old = Blind.disable
function Blind:disable()
  disable_blind_old(self)
  check_for_unlock({type="disable_blind"})
end

local eval_card_old = eval_card
function eval_card(card,context)
  local result = eval_card_old(card,context)
  local retriggers = 0
  if result and result.seals and result.seals.repetition then
    retriggers = retriggers + result.seals.repetition
  end
  if result and result.jokers and result.jokers.repetition then
    retriggers = retriggers + result.jokers.repetition
  end
  check_for_unlock({type="retrigger",num_retriggers=retriggers})
  return result
end

local sell_card_old = Card.sell_card
function Card:sell_card()
  local ret = sell_card_old(self)
  check_for_unlock({type="card_sold",cost=self.sell_cost})
  return ret
end

local skip_blind_old = G.FUNCS.skip_blind
G.FUNCS.skip_blind = function(e)
  local result = skip_blind_old(e)
  check_for_unlock({type="blind_skipped"})
  return result
end

local add_round_eval_row_old = add_round_eval_row
function add_round_eval_row(config)
  local ret = add_round_eval_row_old(config)
  if config.name == "bottom" and config.dollars then
    check_for_unlock({type="end_of_round_dollars",dollars=config.dollars})
  end
  return ret
end