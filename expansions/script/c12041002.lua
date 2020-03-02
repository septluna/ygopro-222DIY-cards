--幻奏龙 斯卡辛丝
function c12041002.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,2,nil,nil,99)
	c:EnableReviveLimit()
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12041002,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c12041002.cost)
	e1:SetOperation(c12041002.operation)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c12041002.imcon)
	e2:SetValue(c12041002.efilter)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12041002,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,12041002)
	e3:SetTarget(c12041002.thtg)
	e3:SetOperation(c12041002.thop)
	c:RegisterEffect(e3)
end
function c12041002.imcon(e)
	return e:GetHandler():GetFlagEffect(12041002)==0
end
function c12041002.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c12041002.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x46) and c:IsAbleToHand()
end
function c12041002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12041002.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12041002.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12041002.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c12041002.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()~=100 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12041002,1))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,0x11e0)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c12041002.tdcost)
	e1:SetTarget(c12041002.tdtg)
	e1:SetOperation(c12041002.tdop)
	c:RegisterEffect(e1)
end
function c12041002.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c12041002.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c12041002.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local sg=Group.CreateGroup()
	local rg=Group.CreateGroup()
	local gc=g:GetFirst()
	local num=0
	while gc do
		if gc:IsPosition(POS_DEFENSE) then 
			Duel.ChangePosition(gc,POS_FACEUP_ATTACK) 
			if gc:IsPosition(POS_DEFENSE) then num=1 end
		end
		if gc:IsPosition(POS_ATTACK) then 
			Duel.ChangePosition(gc,POS_FACEUP_DEFENSE) 
			if gc:IsPosition(POS_ATTACK) then num=1 end
		end
		if num==1 then
			rg:AddCard(gc)
		else
			sg:AddCard(gc)
		end
		num=0
		gc=g:GetNext()
	end
	Duel.Remove(rg,POS_FACEDOWN,REASON_RULE)
	if sg:GetCount()>0 then
		local sc=sg:GetFirst()
		while sc do
			 local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(c12041002.aefilter)
		e1:SetOwnerPlayer(tp)
		sc:RegisterEffect(e1)
			sc=sg:GetNext()
		end
	end
end
function c12041002.aefilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c12041002.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) 
end
function c12041002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,3) end
	Duel.DiscardDeck(tp,3,REASON_COST)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsRace,1,nil,RACE_SEASERPENT) then
	   e:SetLabel(100)
	end
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(12041002,0))
	c:RegisterFlagEffect(12041002,RESET_EVENT+RESETS_STANDARD,0,1)
end
