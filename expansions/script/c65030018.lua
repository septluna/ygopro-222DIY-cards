--现实与幻想的丛林
function c65030018.initial_effect(c)
	aux.AddCodeList(c,65030020)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCost(c65030018.accost)
	c:RegisterEffect(e0)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c65030018.discon)
	e1:SetOperation(c65030018.disop)
	c:RegisterEffect(e1)
	--endphase
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c65030018.edcon)
	e2:SetTarget(c65030018.edtg)
	e2:SetOperation(c65030018.edop)
	c:RegisterEffect(e2)
end
function c65030018.costfil(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsReleasable() and aux.IsCodeListed(c,65030020)
end
function c65030018.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65030018.costfil,tp,LOCATION_SZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c65030018.costfil,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c65030018.disconfil(c)
	return not c:IsType(TYPE_SPELL)
end
function c65030018.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c65030018.disconfil,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)==0 and Duel.GetMatchingGroupCount(Card.IsAttackPos,tp,0,LOCATION_MZONE,nil)==0
	and re:IsActiveType(TYPE_MONSTER) and not (re:IsHasCategory(CATEGORY_SUMMON) or re:IsHasCategory(CATEGORY_SPECIAL_SUMMON))
end
function c65030018.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c65030018.ntfil(c)
	return not c:IsType(TYPE_SPELL)
end
function c65030018.edcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetMatchingGroupCount(c65030018.ntfil,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)==0 
end
function c65030018.edfil(c)
	return c:GetAttackAnnouncedCount()==0
end
function c65030018.edtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65030018.edfil,tp,0,LOCATION_MZONE,1,nil) and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
end
function c65030018.edop(e,tp,eg,ep,ev,re,r,rp)
	local num=Duel.GetMatchingGroupCount(c65030018.edfil,tp,0,LOCATION_MZONE,nil)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local check=0
	local i=0
	if num<=0 or g:GetCount()==0 then return false end
	while check==0 do
		local gc=g:RandomSelect(tp,1):GetFirst()
		g:RemoveCard(gc)
		Duel.Remove(gc,POS_FACEDOWN,REASON_EFFECT)
		i=i+1
		if i==num or not Duel.SelectYesNo(tp,aux.Stringid(65030018,0))  or g:GetCount()==0 then check=1 end
	end
end

