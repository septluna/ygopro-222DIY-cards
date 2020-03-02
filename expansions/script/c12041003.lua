--永奏龙 提亚马特
function c12041003.initial_effect(c)
	 --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_SEASERPENT),3)
	c:EnableReviveLimit()
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12041003,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c12041003.cost)
	e1:SetOperation(c12041003.operation)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c12041003.imcon)
	e2:SetValue(c12041003.efilter)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12041003,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,12041003)
	e3:SetTarget(c12041003.thtg)
	e3:SetOperation(c12041003.thop)
	c:RegisterEffect(e3)
end
function c12041003.imcon(e)
	return e:GetHandler():GetFlagEffect(12041003)==0
end
function c12041003.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c12041003.filter(c)
	return c:IsRace(RACE_SEASERPENT) and c:IsLevelBelow(3) and c:IsAbleToHand()
end
function c12041003.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12041003.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12041003.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12041003.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c12041003.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()~=100 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12041003,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,0x11e0)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c12041003.tdtg)
	e1:SetOperation(c12041003.tdop)
	c:RegisterEffect(e1)
end
function c12041003.spfilter(c,e,tp)
	return c:IsSetCard(0x3faa) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c12041003.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c12041003.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,tp,1)
end
function c12041003.tdop(e,tp,eg,ep,ev,re,r,rp)
	local num=3
	if Duel.GetMZoneCount(tp)<=0 then return end
	if Duel.GetMZoneCount(tp)<3 then num=Duel.GetMZoneCount(tp) end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then num=1 end
	local g=Duel.SelectMatchingCard(tp,c12041003.spfilter,tp,LOCATION_GRAVE,0,1,num,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		local sg=Duel.GetOperatedGroup()
		local sc=sg:GetFirst()
		local rec=0
		while sc do
			rec=rec+sc:GetAttack()
			sc=sg:GetNext()
		end
		Duel.Recover(tp,rec,REASON_EFFECT)
	end
end
function c12041003.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) 
end
function c12041003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,3) end
	Duel.DiscardDeck(tp,3,REASON_COST)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsRace,1,nil,RACE_SEASERPENT) then
	   e:SetLabel(100)
	end
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(12041003,0))
	c:RegisterFlagEffect(12041003,RESET_EVENT+RESETS_STANDARD,0,1)
end
