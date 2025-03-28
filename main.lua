if not BG then BG = {} end
BG.set_bingo_active=false
BG.bingo_active=false
BG.challenges_generated=false
BG.bingo_seed_str=nil
BG.bingo_seed_entry_str=''
BG.Progress = {}
BG.Gameplay = {}
BG.UI = {}
BG.Util = {}
BG.bingo_won=false
BG.maintain_bingo=false
local max_val = 100000
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
    } end
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
      "Skip 6 consecutive",
      "non-boss blinds.",
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
      "for $6 or more."
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
    } end
  },
  {
    name="Lucky",
    text=function() return {
      "Trigger 10",
      "lucky cards.",
      "(" .. tostring(BG.Progress["Lucky"].lucky_cards_triggered) .. " triggered ",
      "so far.)"
    } end,
    setup=function ()
      BG.Progress["Lucky"].lucky_cards_triggered=0
    end
  },
  {
    name="Chippy",
    text=function() return {
      "Get 500 chips",
      "from one hand.",
      "(not counting",
      "mult)."
    } end
  },
  {
    name="Seals",
    text=function() return {
      "Play a hand",
      "containing every",
      "type of seal."
    } end
  },
  {
    name="Big Purchase",
    text=function() return{
      "Spend $50 at",
      "a single shop.",
      "($" .. BG.Progress["Big Purchase"].money_spent_current_shop .. " spent in",
      "current shop)."
    } end,
    setup = function()
      BG.Progress["Big Purchase"].money_spent_current_shop=0
    end
  },
  {
    name="Faceless 5",
    text=function() return{
      "Beat 3 blinds in",
      "ante 5 without",
      "playing any face",
      "cards."
    } end,
    setup = function()
      BG.Progress["Faceless 5"].ante_5_blinds=0
    end
  },
  {
    name="Heartless 6",
    text=function() return{
      "Beat 3 blinds in",
      "ante 6 without",
      "playing any heart",
      "cards."
    } end,
    setup = function()
      BG.Progress["Heartless 6"].ante_6_blinds=0
    end
  },
  {
    name="Cavendish",
    text=function() return{
      "Obtain Cavendish."
    } end
  },
  {
    name="Commonality",
    text=function() return{
      "Take no non-common",
      "jokers before",
      "ante 5."
    } end
  },
  {
    name="Sequence",
    text=function() return{
      "Beat a blind by",
      "playing a high card,",
      "then a pair, then a",
      "three of a kind."
    } end,
    setup = function()
      BG.Progress["Sequence"].hand_progress=0
    end
  },
  -- {
  --   name="Precision",
  --   text=function() return{
  --     "Beat the boss blind",
  --     "of ante 4 on the",
  --     "15th hand of the run.",
  --     "(" .. tostring(G.GAME.hands_played) .. " hands played",
  --     "so far)."
  --   } end
  -- },
  -- {
  --   name="Clearance",
  --   text=function() return{
  --     "Sell 3 jokers",
  --     "during a blind,",
  --     "then beat it.",
  --     "(" .. tostring(BG.Progress["Clearance"].jokers_sold_this_blind) .. " jokers sold",
  --     "this blind.)"
  --   } end,
  --   setup=function()
  --     BG.Progress["Clearance"].jokers_sold_this_blind=0
  --   end
  -- },
  -- {
  --   name="Nevermind",
  --   text=function() return{
  --     "Skip 2 booster",
  --     "packs in a",
  --     "single shop."
  --   } end,
  --   setup=function()
  --     BG.Progress["Nevermind"].booster_packs_skipped_this_shop=0
  --   end
  -- },
  -- {
  --   name="Creation",
  --   text=function() return{
  --     "Create 6 jokers",
  --     "through means",
  --     "other than buying.",
  --     "(" .. tostring(BG.Progress["Creation"].jokers_created) .. " created",
  --     "so far.)"
  --   } end,
  --   setup=function()
  --     BG.Progress["Creation"].jokers_created=0
  --   end
  -- },
  -- {
  --   name="Wheel of Fortune",
  --   text=function() return{
  --     "Successfully add",
  --     "an edition to a",
  --     "joker using",
  --     "Wheel of Fortune."
  --   }end
  -- },
  -- {
  --   name="Joker",
  --   text=function() return{
  --     "Keep \"Joker\"",
  --     "through an entire",
  --     "ante."
  --   }end,
  --   setup=function()
  --     BG.Progress["Joker"].num_jokers=0
  --     BG.Progress["Joker"].had_at_start=false
  --   end
  -- },
  -- {
  --   name="Joker Slots",
  --   text=function() return {
  --     "Have 7",
  --     "joker slots."
  --   }end
  -- },
  -- {
  --   name="Big Hand",
  --   text=function() return{
  --     "Have 12 cards",
  --     "in your hand."
  --   }end
  -- }
}

-- Shuffles in-place
-- ONLY TO BE USED FOR CHALLENGES
BG.Util.shuffle = function(array,seed1,seed2)
  math.randomseed(seed1,seed2)
  for i=#array,2,-1 do
    local j = math.random(i)
    array[i], array[j] = array[j], array[i]
  end
end

BG.Util.slice = function(array,startInd,endInd)
  local output = {}
  for i=startInd,endInd do
      output[#output+1]=array[i]
      -- sendTraceMessage("Current value: " .. tostring(output[#output]),"BingoLog")
  end
  return output
end

BG.Util.range = function(startNum,endNum)
  local output = {}
  for i=startNum,endNum do
    output[#output+1]=i
  end
  return output
end

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

local seed_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
function BG.Util.random_seed()
  local seed_str = ""
  for i=1,8 do
    local index = math.random(string.len(seed_chars))
    seed_str = seed_str .. string.sub(seed_chars,index,index)
  end
  return seed_str
end

function BG.Util.numbers_from_seed(seed_str)
  while string.len(seed_str) < 8 do
    seed_str = "0"..seed_str
  end
  local first_half = pseudohash(string.sub(seed_str,1,4))
  local second_half = pseudohash(string.sub(seed_str,5,8))
  return first_half, second_half
end

function BG.Gameplay.get_challenges()
  local seed_str = BG.bingo_seed_str
  if seed_str == nil or seed_str == '' then
    seed_str = BG.Util.random_seed()
    BG.bingo_seed_str=seed_str
  else
    for i=1,8 do
      math.random()
    end
  end
  local seed1, seed2 = BG.Util.numbers_from_seed(seed_str)
  local list = BG.Util.range(1,#BG.Challenges)
  BG.Util.shuffle(list,seed1,seed2)
  return BG.Util.slice(list,1,25)
end

function BG.Gameplay.setup_challenges(continuing_run)
  local challenge_numbers = BG.Gameplay.get_challenges()
  BG.Gameplay.active_challenges = {}
  for index, value in ipairs(challenge_numbers) do
    local challenge = BG.Challenges[value]
    sendTraceMessage("Setting up progress for " .. challenge.name, "BingoLog")
    if not continuing_run then
      if BG.maintain_bingo then
        BG.Progress[challenge.name].impossible=false
      else
        BG.Progress[challenge.name]={
          completed=false,
          impossible=false
        }
      end
    end
    if challenge.setup ~= nil and not continuing_run then 
      challenge.setup()
    end
    BG.Gameplay.active_challenges[index]=value
  end
end

function BG.UI.get_challenge_box(index)
  local children = {}
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
  local ch = BG.Gameplay.active_challenges
  return {
    n=G.UIT.ROOT, 
    config={align="tl", minw=3, padding = 0.1, r=0.1, color=G.C.CLEAR},
    nodes={
      {n=G.UIT.C,config={align="tl",padding=0.1},nodes={
        {
          n=G.UIT.R,
          config={align="tm",padding=0},nodes={
            {
              n=G.UIT.T,
              config={align="tm",text="Seed: " .. BG.bingo_seed_str,colour=G.C.WHITE,scale=0.35},
              nodes={}
            }
          }
        },
        {n=G.UIT.R,config={align="tl",padding=0.1},nodes={
          {
            n=G.UIT.R,
            config={align="tl",padding=0.1},nodes=
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
            config={align="tl",padding=0.1},nodes=
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
            config={align="tl",padding=0.1},nodes=
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
            config={align="tl",padding=0.1},nodes=
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
            config={align="tl",padding=0.1},nodes=
              {
                BG.UI.get_challenge_box(ch[21]),
                BG.UI.get_challenge_box(ch[22]),
                BG.UI.get_challenge_box(ch[23]),
                BG.UI.get_challenge_box(ch[24]),
                BG.UI.get_challenge_box(ch[25])
            }
          }
        }}}
      }
    }
  }
end

function BG.Gameplay.set_impossible(challenge_name)
  if BG.bingo_won then return end
  if BG.Progress[challenge_name] == nil then return end
  if not BG.Progress[challenge_name].completed then
    sendTraceMessage("Setting challenge " .. challenge_name .. " to impossible.","BingoLog")
    BG.Progress[challenge_name].impossible=true
  end
end

function BG.Gameplay.check_for_win()
  -- Check horizontal
  for i=1,5 do
    local all_complete = true
    for j=1,5 do
      local ind = (i-1)*5+j
      local name = BG.Challenges[BG.Gameplay.active_challenges[ind]].name
      sendTraceMessage("Checking location " .. tostring(ind) .. ", Name = " .. tostring(name) .. " for horizontal win.","BingoLog")
      if not BG.Progress[name] or not BG.Progress[name].completed then
        sendTraceMessage("Location " .. tostring(ind) .. " failed for horizontal win.","BingoLog")
        all_complete=false
        break
      end
    end
    if all_complete then
      return true
    end
  end

  -- Check vertical
  for i=1,5 do
    local all_complete = true
    for j=1,5 do
      local ind = (j-1)*5+i
      local name = BG.Challenges[BG.Gameplay.active_challenges[ind]].name
      sendTraceMessage("Checking location " .. tostring(ind) .. ", Name = " .. tostring(name) .. " for vertical win.","BingoLog")
      if not BG.Progress[name] or not BG.Progress[name].completed then
        sendTraceMessage("Location " .. tostring(ind) .. " failed for vertical win.","BingoLog")
        all_complete=false
        break
      end
    end
    if all_complete then
      return true
    end
  end

  -- Check diagonal 1
  local all_complete=true
  for i=1,5 do
    local ind = (i-1)*5+i
    local name = BG.Challenges[BG.Gameplay.active_challenges[ind]].name
    sendTraceMessage("Checking location " .. tostring(ind) .. ", Name = " .. tostring(name) .. " for diagonal win 1.","BingoLog")
    if not BG.Progress[name] or not BG.Progress[name].completed then
      sendTraceMessage("Location " .. tostring(ind) .. " failed for diagonal win 1.","BingoLog")
      all_complete=false
      break
    end
  end
  if all_complete then
    return true
  end

  all_complete=true
  for i=1,5 do
    local ind = (i-1)*5+(6-i)
    local name = BG.Challenges[BG.Gameplay.active_challenges[ind]].name
    sendTraceMessage("Checking location " .. tostring(ind) .. ", Name = " .. tostring(name) .. " for diagonal win 2.","BingoLog")
    if not BG.Progress[name] or not BG.Progress[name].completed then
      sendTraceMessage("Location " .. tostring(ind) .. " failed for diagonal win 2.","BingoLog")
      all_complete=false
      break
    end
  end
  return all_complete
end

function BG.Gameplay.set_complete(challenge_name)
  if BG.bingo_won then return end
  if BG.Progress[challenge_name]==nil then return end
  if not BG.Progress[challenge_name].impossible and not BG.Progress[challenge_name].completed then
    -- TODO: Little animation or somethin' (but only if the challenge is active)
    sendTraceMessage("Completed Challenge " .. challenge_name, "BingoLog")
    BG.Progress[challenge_name].completed=true
    if BG.Gameplay.check_for_win() then
      sendTraceMessage("Win found","BingoLog")
      BG.Gameplay.show_win()
    end
    BG.UI.notify_bingo_alert(BG.Util.get_challenge_index(challenge_name))
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
    if G.GAME.round_resets.ante < 4 and BG.Progress["Early Vouchers"] ~= nil then
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
    if args.ante == 9 then
      BG.Gameplay.set_complete("Win")
    end
    if args.ante == 5 then
      BG.Gameplay.set_complete("Commonality")
    end
  end
  if args.type == 'joker_added' then
    if G.GAME.round_resets.ante <= 1 then
      BG.Gameplay.set_impossible("No Early Jokers")
    end
    if args.card.ability.name == 'Cavendish' then
      BG.Gameplay.set_complete("Cavendish")
    end
    if args.card.config.center.rarity > 1 and G.GAME.round_resets.ante < 5 then
      BG.Gameplay.set_impossible("Commonality")
    end
    local rares = 0
    for i = 1, #G.jokers.cards do
        if G.jokers.cards[i].config.center.rarity == 3 then
          rares = rares+1
        end
    end 
    if rares >= 3 and args.card.config.center.rarity == 3 then
      BG.Gameplay.set_complete("Rarity")
    end
  end
  if args.type == 'disable_blind' then
    BG.Gameplay.set_complete("Disable Boss")
  end
  if args.type == 'hand' then
    -- sendTraceMessage("Hand played","BingoLog")

    local total_retriggers = 0
    for i=1,#args.scoring_hand do
      total_retriggers=total_retriggers+BG.Gameplay.get_repetition_count(args.scoring_hand[i],G.play)
    end
    local seal_types = {}
    local num_unique_seals = 0
    for i=1,#args.full_hand do
      local card = args.full_hand[i]
      if card.seal and seal_types[card.seal] == nil then
        seal_types[card.seal]=1
        num_unique_seals = num_unique_seals + 1
      end
    end
    if num_unique_seals >= 4 then
      BG.Gameplay.set_complete("Seals")
    end
    if total_retriggers>=5 then
      BG.Gameplay.set_complete("Retriggers")
    end

    local steel_triggers = 0
    for i=1,#G.hand.cards do
      local card = G.hand.cards[i]
      local retriggers = BG.Gameplay.get_repetition_count(card,G.hand)
      if card.config.center == G.P_CENTERS.m_steel then
        steel_triggers = steel_triggers + 1 + retriggers
      end
    end
    if steel_triggers >= 5 then
      BG.Gameplay.set_complete("Steely")
    end

    -- A little weird but it'll work
    if G.GAME.blind and G.GAME.blind:get_type() ~= 'Boss' and BG.Progress["Skip"] ~= nil then
      sendTraceMessage("Hand played on non-boss blind","BingoLog")
      BG.Progress["Skip"].consecutive_blinds_skipped=0
    end
    if args.disp_text == "Royal Flush" then
      BG.Gameplay.set_complete("Royal Flush")
    end
    if args.handname == 'Five of a Kind' then
      BG.Gameplay.set_complete("Five of a Kind")
    end

    for i=1,#args.scoring_hand do
      local card = args.scoring_hand[i]
      if G.GAME.round_resets.ante == 5 and card:is_face() then
        BG.Gameplay.set_impossible("Faceless 5")
      end
      if G.GAME.round_resets.ante == 6 and card:is_suit("Hearts") then
        BG.Gameplay.set_impossible("Heartless 6")
      end
    end

    sendTraceMessage("Hand name: " .. args.handname .. ", Hands Scored: " .. G.GAME.current_round.hands_played,"BingoLog")
    if BG.Progress["Sequence"] ~= nil then
      if (args.handname == 'High Card' and G.GAME.current_round.hands_played == 0) or (args.handname == 'Pair' and G.GAME.current_round.hands_played == 1) or (args.handname == 'Three of a Kind' and G.GAME.current_round.hands_played == 2) then
        sendTraceMessage("Incrementing progress...","BingoLog")
        BG.Progress["Sequence"].hand_progress=BG.Progress["Sequence"].hand_progress+1
      else
        sendTraceMessage("Resetting progress...","BingoLog")
        BG.Progress["Sequence"].hand_progress=0
      end
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
  if args.type == 'blind_skipped' and BG.Progress["Skip"] ~= nil then
    BG.Progress["Skip"].consecutive_blinds_skipped=BG.Progress["Skip"].consecutive_blinds_skipped+1
    if BG.Progress["Skip"].consecutive_blinds_skipped >= 6 then
      BG.Gameplay.set_complete("Skip")
    end
  end
  if args.type == "card_sold" then
    if args.cost >= 6 then
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
    if BG.Progress["Rising Power"] ~= nil then
      BG.Progress["Rising Power"].poker_hands_upgraded_this_round = BG.Gameplay.get_poker_hands_default()
    end
    if BG.Progress["Faceless 5"] ~= nil and G.GAME.round_resets.ante == 5 then
      BG.Progress["Faceless 5"].ante_5_blinds = BG.Progress["Faceless 5"].ante_5_blinds + 1
      if BG.Progress["Faceless 5"].ante_5_blinds >= 3 then
        BG.Gameplay.set_complete("Faceless 5")
      end
    end
    if BG.Progress["Heartless 6"] ~= nil and G.GAME.round_resets.ante == 6 then
      BG.Progress["Heartless 6"].ante_6_blinds = BG.Progress["Heartless 6"].ante_6_blinds + 1
      if BG.Progress["Heartless 6"].ante_6_blinds >= 3 then
        BG.Gameplay.set_complete("Heartless 6")
      end
    end
    if BG.Progress["Sequence"] ~= nil then
      if BG.Progress["Sequence"].hand_progress >= 3 then
        BG.Gameplay.set_complete("Sequence")
      end
      BG.Progress["Sequence"].hand_progress=0
    end
    
  end
  if args.type == "upgrade_hand" then
    if args.level >= 12 then
      BG.Gameplay.set_complete("Pretty High Level")
    end
    if G.GAME.facing_blind and BG.Progress["Rising Power"] ~= nil then
      BG.Progress["Rising Power"].poker_hands_upgraded_this_round[args.hand]=BG.Progress["Rising Power"].poker_hands_upgraded_this_round[args.hand]+1
      if BG.Progress["Rising Power"].poker_hands_upgraded_this_round[args.hand] >= 2 then
        BG.Gameplay.set_complete("Rising Power")
      end
    end
  end
  if args.type == "chip_score" then
    if args.chips >= 2000000 then
      BG.Gameplay.set_complete("High Score")
    end
  end
  if args.type == 'lucky_trigger' and BG.Progress["Lucky"] ~= nil then
    BG.Progress["Lucky"].lucky_cards_triggered = BG.Progress["Lucky"].lucky_cards_triggered+1
    if BG.Progress["Lucky"].lucky_cards_triggered >= 10 then
      BG.Gameplay.set_complete("Lucky")
    end
  end
  if args.type == "chip_count" then
    if args.chips >= 500 then
      BG.Gameplay.set_complete("Chippy")
    end
  end
  if args.type == "money_mod" then
    if BG.Progress["Big Purchase"] ~= nil and args.mod < 0 and G.shop then
      BG.Progress["Big Purchase"].money_spent_current_shop=BG.Progress["Big Purchase"].money_spent_current_shop-args.mod
      if BG.Progress["Big Purchase"].money_spent_current_shop >= 50 then
        BG.Gameplay.set_complete("Big Purchase")
      end
    end
  end
  if args.type == "shop_entered" then
    if BG.Progress["Big Purchase"] ~= nil then
      BG.Progress["Big Purchase"].money_spent_current_shop=0
    end
  end
  return ret
end

local update_shop_old = Game.update_shop
function Game:update_shop(dt)
  if not G.STATE_COMPLETE and not G.shop then
    check_for_unlock({type="shop_entered"})
  end
  local ret = update_shop_old(self,dt)
  return ret
end

local calculate_joker_old = Card.calculate_joker
function Card:calculate_joker (context)
  local result = calculate_joker_old(self,context)
  -- sendTraceMessage("Calculating Joker","BingoLog")
  if result and type(result) == "table" and result.Xmult_mod then
    sendTraceMessage("Xmult mod found","BingoLog")
    check_for_unlock({type="xmult_trigger",amount=result.Xmult_mod})
  end
  return result
end

local ease_dollars_old = ease_dollars
function ease_dollars(mod,instant)
  local ret = ease_dollars_old(mod,instant)
  check_for_unlock({type="money_mod",mod=mod})
  return ret
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
  local result, result2 = eval_card_old(card,context)
  if not context.repetition_only and context.cardarea == G.play and card.lucky_trigger then
    check_for_unlock({type="lucky_trigger",card=card})
  end
  return result, result2
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

function BG.Gameplay.get_repetition_count(card,cardarea)
  local text,disp_text,poker_hands,scoring_hand,non_loc_disp_text = G.FUNCS.get_poker_hand_info(G.play.cards)
  local reps = {1}  
  --From Red seal
  local eval = eval_card(card, {repetition_only = true,cardarea = cardarea, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, repetition = true})
  if next(eval) then 
      for h = 1, eval.seals.repetitions do
          reps[#reps+1] = eval
      end
  end
  --From jokers
  for j=1, #G.jokers.cards do
      --calculate the joker effects
      local eval = eval_card(G.jokers.cards[j], {cardarea = cardarea, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, other_card = card, repetition = true})
      if next(eval) and eval.jokers then 
          for h = 1, eval.jokers.repetitions do
              reps[#reps+1] = eval
          end
      end
  end
  return #reps - 1
end

local mod_chips_old = mod_chips
function mod_chips(chips)
  local res = mod_chips_old(chips)
  check_for_unlock({type="chip_count",chips=res})
  return res
end

local start_run_old = Game.start_run
function Game:start_run(args)
  local ret = start_run_old(self,args)
  local savetable = args.savetext or nil
  if savetable == nil then
    BG.bingo_active=BG.set_bingo_active or BG.maintain_bingo
  else
    BG.bingo_active=savetable.BINGO_SEED ~= nil or BG.maintain_bingo
    BG.Progress=savetable.BINGO_PROGRESS
    sendTraceMessage("Bingo Progress = " .. tostring(BG.Progress))
  end
  if BG.bingo_active then
    if not BG.maintain_bingo then
      if savetable and savetable.BINGO_SEED ~= nil and savetable.BINGO_SEED ~= '' then
        sendTraceMessage("Bingo Seed Found " .. savetable.BINGO_SEED,"BingoLog")
        BG.bingo_seed_str = savetable.BINGO_SEED
      elseif BG.bingo_seed_entry_str ~= '' and BG.bingo_seed_entry_str~=nil then
        sendTraceMessage("Bingo Seed Entry Found " .. BG.bingo_seed_entry_str,"BingoLog")
        BG.bingo_seed_str = BG.bingo_seed_entry_str
      else
        BG.bingo_seed_str=BG.Util.random_seed()
        sendTraceMessage("Bingo Seed Not Found. Setting to " .. BG.bingo_seed_str,"BingoLog")
      end
    end
    if savetable == nil then
      BG.bingo_won=false
    end
    BG.Gameplay.setup_challenges(savetable ~= nil)
    BG.challenges_generated=true
  end
  return ret
end

local save_run_old = save_run
function save_run()
  local ret = save_run_old()
  G.ARGS.save_run["BINGO_SEED"]=BG.bingo_seed_str
  G.ARGS.save_run["BINGO_PROGRESS"]=BG.Progress
  return ret
end

local run_setup_option_old = G.UIDEF.run_setup_option
function G.UIDEF.run_setup_option(type)
  local old = run_setup_option_old(type)
  BG.set_bingo_active=false
  local new_node = {n=G.UIT.C, config={align = "cm", minw = 2.4, id = 'toggle_bingo_active'}, nodes={}}
  if type == 'New Run' then
    table.insert(new_node.nodes,create_toggle{col = true, label = "Bingo", label_scale = 0.25, w = 0, scale = 0.7, ref_table = BG, ref_value = 'set_bingo_active'})
    if BG.bingo_active then
      table.insert(new_node.nodes,create_toggle{col=true,label='Continue Bingo',label_scale=0.25,w=0,scale=0.7,ref_table=BG,ref_value='maintain_bingo'})
    end
  end
  table.insert(old.nodes[4].nodes[3].nodes,new_node)
  if type == 'New Run' then
    local new_entry_value = {n=G.UIT.O, config={align = "cm", func = 'modify_bingo_run', object = Moveable()}, nodes={}}
    table.insert(old.nodes,3,
      {n=G.UIT.R, config={align = "cm", padding = 0.05, minh = 0.9}, nodes={
        new_entry_value
      }}
    )
  end
  return old
end

function BG.UI.get_text_entry(parent)
  BG.bingo_seed_entry_str = BG.Util.random_seed()
  local input = create_text_input({max_length = 8, all_caps = true, ref_table = BG, ref_value = 'bingo_seed_entry_str', prompt_text = "Bingo Seed",id='text_bingo_input'})
  return UIBox{
    definition = {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes={
      {n=G.UIT.C, config={align = "cm", minw = 0.1}, nodes={
        input,
        {n=G.UIT.C, config={align = "cm", minw = 0.1}, nodes={}},
        UIBox_button({label = localize('ml_paste_seed'),minw = 1, minh = 0.6, button = 'paste_bingo_seed', colour = G.C.BLUE, scale = 0.3, col = true})
      }},

      {n=G.UIT.C, config={align = "cm", minw = 2.5}, nodes={
      }},
    }},
    config = {offset = {x=0,y=0}, parent = parent, type = 'cm'}
  }
end

function G.FUNCS.modify_bingo_run(e)
  if e.config.object and not BG.set_bingo_active then
    e.config.object:remove()
    e.config.object = nil
  elseif not e.config.object and BG.set_bingo_active then
    e.config.object = BG.UI.get_text_entry(e)
    e.config.object:recalculate()
  end
end

G.FUNCS.paste_bingo_seed = function(e)
  G.CONTROLLER.text_input_id = 'text_bingo_input'
  G.CONTROLLER.text_input_hook = e.UIBox:get_UIE_by_ID('text_bingo_input').children[1].children[1]
  sendTraceMessage('Text input hook is ' .. tostring(G.CONTROLLER.text_input_hook),'BingoLog')
  G.CONTROLLER.text_input_id = 'text_bingo_input'
  for i = 1, 8 do
    G.FUNCS.text_input_key({key = 'right'})
  end
  for i = 1, 8 do
      G.FUNCS.text_input_key({key = 'backspace'})
  end
  local clipboard = (G.F_LOCAL_CLIPBOARD and G.CLIPBOARD or love.system.getClipboardText()) or ''
  for i = 1, #clipboard do
    local c = clipboard:sub(i,i)
    G.FUNCS.text_input_key({key = c})
  end
  G.FUNCS.text_input_key({key = 'return'})
end

function BG.Gameplay.show_win()
  G.E_MANAGER:add_event(Event({
    trigger = 'immediate',
    blocking = false,
    blockable = false,
    func = (function()
          G.E_MANAGER:add_event(Event({
              trigger = 'immediate',
              func = (function()
                  for k, v in pairs(G.I.CARD) do
                      v.sticker_run = nil
                  end
                  
                  play_sound('win')
                  G.SETTINGS.paused = true

                  G.FUNCS.overlay_menu{
                      definition = create_UIBox_win('BINGO!'),
                      config = {no_esc = true}
                  }
                  
                  return true
              end)
          }))
        G.GAME.won = true
        BG.bingo_won=true
        return true
      end)
  }))
end



local create_UIBox_win_old = create_UIBox_win
function create_UIBox_win(win_str)
  local ret = create_UIBox_win_old()
  if win_str ~= nil then
    local config = ret.nodes[1].nodes[2].nodes[1].nodes[1].nodes[1].nodes[1].nodes[1].config
    config.object:remove()
    config.object = DynaText({string = {win_str}, colours = {G.C.EDITION},shadow = true, float = true, spacing = 10, rotate = true, scale = 1.5, pop_in = 0.4, maxw = 6.5})
  end
  return ret
end


function BG.UI.notify_bingo_alert(bingo_challenge)
  G.E_MANAGER:add_event(Event({
    no_delete = true,
    pause_force = true,
    timer = 'UPTIME',
    func = function()
      if G.achievement_notification then
          G.achievement_notification:remove()
          G.achievement_notification = nil
      end
      G.achievement_notification = G.achievement_notification or UIBox{
          definition = BG.UI.create_UIBox_bingo_alert(bingo_challenge),
          config = {align='cr', offset = {x=20,y=0},major = G.ROOM_ATTACH, bond = 'Weak'}
      }
      return true
    end
  }), 'achievement')
  G.E_MANAGER:add_event(Event({
      no_delete = true,
      trigger = 'after',
      pause_force = true,
      timer = 'UPTIME',
      delay = 0.1,
      func = function()
          G.achievement_notification.alignment.offset.x = G.ROOM.T.x - G.achievement_notification.UIRoot.children[1].children[1].T.w - 0.8
        return true
      end
  }), 'achievement')
  G.E_MANAGER:add_event(Event({
      no_delete = true,
      pause_force = true,
      trigger = 'after',
      timer = 'UPTIME',
      delay = 0.1,
      func = function()
          play_sound('highlight1', nil, 0.5)
          play_sound('foil2', 0.5, 0.4)
        return true
      end
  }), 'achievement')
  G.E_MANAGER:add_event(Event({
    no_delete = true,
    pause_force = true,
    trigger = 'after',
    delay = 3,
    timer = 'UPTIME',
    func = function()
      G.achievement_notification.alignment.offset.x = 20
      return true
    end
  }), 'achievement')
  G.E_MANAGER:add_event(Event({
      no_delete = true,
      pause_force = true,
      trigger = 'after',
      delay = 0.5,
      timer = 'UPTIME',
      func = function()
          if G.achievement_notification then
              G.achievement_notification:remove()
              G.achievement_notification = nil
          end
        return true
      end
  }), 'achievement')
end

function BG.Util.get_challenge_index(challenge_name)
  for k,v in ipairs(BG.Challenges) do
    if v.name==challenge_name then
      return k
    end
  end
end

function BG.UI.create_UIBox_bingo_alert(challenge_id)
  local _c, _atlas = G.P_CENTERS["j_joker"], G.ASSET_ATLAS["Joker"]

  local t_s = Sprite(0,0,1.5*(_atlas.px/_atlas.py),1.5,_atlas, _c and _c.pos or {x=3, y=0})
  t_s.states.drag.can = false
  t_s.states.hover.can = false
  t_s.states.collide.can = false
  local challenge_name = BG.Challenges[challenge_id].name
  sendTraceMessage("Challenge name is " .. tostring(challenge_name),"BingoLog")
  local subtext_full = BG.Challenges[challenge_id].text() 
  local subtext = ""
  for k,v in ipairs(subtext_full) do
    subtext = subtext .. v .. " "
  end

  local name = challenge_name

    local t = {n=G.UIT.ROOT, config = {align = 'cl', r = 0.1, padding = 0.06, colour = G.C.UI.TRANSPARENT_DARK}, nodes={
    {n=G.UIT.R, config={align = "cl", padding = 0.2, minw = 20, r = 0.1, colour = G.C.BLACK, outline = 1.5, outline_colour = G.C.GREY}, nodes={
      {n=G.UIT.R, config={align = "cm", r = 0.1}, nodes={
        {n=G.UIT.R, config={align = "cm", r = 0.1}, nodes={
          {n=G.UIT.O, config={object = t_s}},
        }},
        false and {n=G.UIT.R, config={align = "cm", padding = 0.04}, nodes={
          {n=G.UIT.R, config={align = "cm", maxw = 3.4}, nodes={
            {n=G.UIT.T, config={text = subtext, scale = 0.5, colour = G.C.FILTER, shadow = true}},
          }},
          {n=G.UIT.R, config={align = "cm", maxw = 3.4}, nodes={
            {n=G.UIT.T, config={text = localize('k_unlocked_ex'), scale = 0.35, colour = G.C.FILTER, shadow = true}},
          }}
        }}
        or {n=G.UIT.R, config={align = "cm", padding = 0.04}, nodes={
          {n=G.UIT.R, config={align = "cm", maxw = 3.4, padding = 0.1}, nodes={
            {n=G.UIT.T, config={text = name, scale = 0.4, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
          }},
          {n=G.UIT.R, config={align = "cm", maxw = 3.4}, nodes={
            {n=G.UIT.T, config={text = subtext, scale = 0.3, colour = G.C.FILTER, shadow = true}},
          }},
          {n=G.UIT.R, config={align = "cm", maxw = 3.4}, nodes={
            {n=G.UIT.T, config={text = localize('k_unlocked_ex'), scale = 0.35, colour = G.C.FILTER, shadow = true}},
          }}
        }}
      }}
    }}
  }}
  return t
end