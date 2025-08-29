--Heart of the Cards
local s,id,o=GetID()
function s.initial_effect(c)
	--Immune
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_IMMUNE_EFFECT)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_REMOVED)
	e0:SetValue(s.efilter)
	c:RegisterEffect(e0)
	--Act
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(s.con)
	e1:SetCost(s.rmcost)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
	--Place on deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(s.con)
    e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	--Replace hand
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetTarget(s.reptg)
	e3:SetOperation(s.repop)
	c:RegisterEffect(e3)
	--Negate on resolution
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCondition(s.negcon)
	e4:SetOperation(s.negop)
	c:RegisterEffect(e4)
	--Destroy prevention
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_REMOVED)
	e5:SetCondition(s.con)
	e5:SetTarget(s.reptg)
	e5:SetValue(s.repval)
	c:RegisterEffect(e5)
end
-- Heart of the cards filter
function s.hfilter(c,e)
	--Individual cards
	return c:IsCode(14558127) --Ash Blossom
	or c:IsCode(73642296) --Ghost Belle 
	or c:IsCode(27204311) --Nibiru, the Primal Being
	or c:IsCode(91800273) --Dimension Shifter
	or c:IsCode(23434538) --Maxx "C"
	or c:IsCode(6728559) --Archnemeses Protos
	or c:IsCode(55623480) --Fairy Tail - Snow
	or c:IsCode(48546368) --Herald of Ultimateness
	or c:IsCode(10158145) --Knightmare Corruptor Iblee
	or c:IsCode(10963799) --Barrier Statue of the Torrent
	or c:IsCode(19740112) --Barrier Statue of the Drought
	or c:IsCode(546145256) --Barrier Statue of the Heavens
	or c:IsCode(47961808) --Barrier Statue of the Inferno
	or c:IsCode(73356503) --Barrier Statue of the Stormwinds
	or c:IsCode(84478195) --Barrier Statue of the Abyss
	or c:IsCode(20292186) --Artifact Scythe
	or c:IsCode(69015963) --Cyber-Stein
	or c:IsCode(72634965) --Vanity's Ruler
	or c:IsCode(47084486) --Vanity's Fiend
	or c:IsCode(15397015) --Inspector Boarder
	or c:IsCode(90448279) --Divine Arsenal AA-ZEUS - Sky Thunder
	or c:IsCode(29301450) --S:P Little Knight
	or c:IsCode(53334471) --Gozen Match
	or c:IsCode(90846359) --Rivalry of Warlords 
	or c:IsCode(15693423) --Evenly Matched
	or c:IsCode(82732705) --Skill Drain
	or c:IsCode(05851097) --Vanity's Emptiness
	or c:IsCode(30241314) --Macro Cosmos
	or c:IsCode(23516703) --Summon Limit
	or c:IsCode(48130397) --Super Polymerization
	or c:IsCode(10045474) --Infinite Impermanence
	-- Archetypes
	or c:IsSetCard(0x189) --Kashtira
	or c:IsSetCard(0x108a) --Traptrix
	or c:IsSetCard(0x181) --Tearlaments
	or c:IsSetCard(0x154) --Drytron
	or c:IsSetCard(0x15d) --Branded
	or c:IsSetCard(0x115) --Sky Striker
	or c:IsSetCard(0x119) --Salamangreat
	or c:IsSetCard(0x180) --Spright
	or c:IsSetCard(0x19c) --Snake-Eye
	or c:IsSetCard(0x19e) --Sinful Spoils
	or c:IsSetCard(0x1a5) --Yubel
	or c:IsSetCard(0x1aa) --Tenpai Dragon
	or c:IsSetCard(0x1a9) --Sangen
	or c:IsSetCard(0x2b0) --Fiendsmith
	or c:IsSetCard(0x40) --Forbidden One
	or c:IsSetCard(0xd3) --Kaiju
	or c:IsSetCard(0x16d) --Floowandereeze
	or aux.AddCodeList(c,3285552) --Mentions "Adventurer Token"
	or aux.AddCodeList(c,68468459) --Mentions "Fallen of Albaz"
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.hfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
end
-- Immune filter
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function s.chainlm(e,ep,tp)
	return tp==ep
end
-- Act banish
function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetChainLimit(s.chainlm)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if e:GetHandler():IsPreviousLocation(LOCATION_HAND) then
		Duel.Draw(p,d,REASON_EFFECT)
	end
end
-- Place on top of Deck 
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.IsExistingMatchingCard(nil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetChainLimit(s.chainlm)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.HintSelection(g)
		Duel.MoveSequence(tc,SEQ_DECKTOP)
		if tc:IsLocation(LOCATION_DECK) then
			Duel.ConfirmDecktop(tp,1)
		end
	end
end
-- Replace hand
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0
		and Duel.IsExistingMatchingCard(nil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetChainLimit(s.chainlm)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DisableShuffleCheck()
	local sg=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,1,1,nil)
	local sg1=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
	if #sg>0 then
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		Duel.ShuffleHand(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tc1=sg1:Select(tp,1,1,nil):GetFirst()
		Duel.ConfirmCards(1-tp,tc1)
		if Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))==0 then
			Duel.BreakEffect()
			Duel.SendtoDeck(tc1,nil,SEQ_DECKTOP,REASON_EFFECT)
		else
			Duel.BreakEffect()
			Duel.SendtoDeck(tc1,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
		end
	end
end
-- Negate on resolution
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainDisablable(ev) and s.con(e,tp,eg,ep,ev,re,r,rp)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_CARD,0,id)
		Duel.NegateEffect(ev)
	end
end
-- Destroy prevenetion
function s.repfilter(c,tp)
	return c:IsControler(tp)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end