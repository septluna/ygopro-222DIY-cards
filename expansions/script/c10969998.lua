-御魂术
function c10969998.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c10969998.target)
	e1:SetOperation(c10969998.activate)
	c:RegisterEffect(e1)
	if not c10969998.global_check then
		c10969998.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c10969998.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c10969998.checkop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and not re:GetHandler():IsCode(10969998) then
		Duel.RegisterFlagEffect(rp,20822521,RESET_PHASE+PHASE_END,0,1)
	end
end
function c10969998.filter(c)
	return c:IsFaceup() and c:GetSummonLocation()==LOCATION_EXTRA and (c:GetSequence()>=5 or c:IsRace(RACE_ZOMBIE))  
end
function c10969998.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10969998.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10969998.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c10969998.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c10969998.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)>0 then Duel.Draw(tp,2,REASON_EFFECT)
		end
	end
end