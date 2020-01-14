--星月转夜 巫异之月
function c65050227.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x5da9),6,2)
	c:EnableReviveLimit()
	 --change effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c65050227.condition)
	e1:SetCost(c65050227.cost)
	e1:SetOperation(c65050227.activate)
	c:RegisterEffect(e1)
	--change effect
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,65050227)
	e2:SetCondition(c65050227.condition2)
	e2:SetCost(c65050227.cost)
	e2:SetOperation(c65050227.activate2)
	c:RegisterEffect(e2)
end
function c65050227.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c65050227.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		e:GetHandler():CancelToGrave(false)
	end
	local g=Duel.SelectMatchingCard(tp,c65050227.repfil,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,tp,REASON_EFFECT)
	end
end

function c65050227.repfil(c)
	return c:IsSetCard(0x5da9) and c:IsType(TYPE_SPELL) and c:IsAbleToHand() 
end

function c65050227.condition(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return ep==tp 
		and Duel.IsExistingMatchingCard(c65050227.repfil,tp,LOCATION_GRAVE,0,1,nil) 
end
function c65050227.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c65050227.repop)
end

function c65050227.hadfil(c)
	return c:IsSetCard(0x5da9) and c:IsFaceup()
end
function c65050227.repop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		e:GetHandler():CancelToGrave(false)
	end
	if Duel.Draw(tp,2,REASON_EFFECT) and Duel.Draw(1-tp,2,REASON_EFFECT) then
		if Duel.GetMatchingGroupCount(c65050227.hadfil,tp,LOCATION_MZONE,0,nil)==0 then
			Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD,nil)
		end
		if Duel.GetMatchingGroupCount(c65050227.hadfil,tp,0,LOCATION_MZONE,nil)==0 then
			Duel.DiscardHand(1-tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD,nil)
		end
	end
end
function c65050227.condition2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return ep~=tp 
		and Duel.IsPlayerCanDraw(tp,2) and Duel.IsPlayerCanDraw(1-tp,2)
end
function c65050227.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c65050227.repop2)
end