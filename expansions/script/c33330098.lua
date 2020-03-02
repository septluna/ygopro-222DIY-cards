--异族魔术魔女 茜丝
function c33330098.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c33330098.matfilter,1,1)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,33330098)
	e1:SetCost(c33330098.cost)
	e1:SetTarget(c33330098.tg)
	e1:SetOperation(c33330098.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c33330098.matfilter(c)
	return c:IsLinkRace(RACE_SPELLCASTER) and not c:IsLinkCode(33330098)
end
function c33330098.costfil(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToDeckAsCost()
end
function c33330098.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33330098.costfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c33330098.costfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c33330098.tgfil(c,tid)
	return c:GetTurnID()==tid and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c33330098.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tid=Duel.GetTurnCount()
	if chk==0 then return Duel.IsExistingMatchingCard(c33330098.tgfil,tp,LOCATION_GRAVE,0,1,nil,tid) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c33330098.op(e,tp,eg,ep,ev,re,r,rp)
	local tid=Duel.GetTurnCount()
	local g=Duel.SelectMatchingCard(tp,c33330098.tgfil,tp,LOCATION_GRAVE,0,1,1,nil,tid)
	local tc=g:GetFirst()
	if tc and Duel.SendtoHand(tc,tp,REASON_EFFECT)~=0 then
		 local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetLabel(tc:GetCode())
			e1:SetValue(c33330098.aclimit)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
	end
end
function c33330098.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) 
end