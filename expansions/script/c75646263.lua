--崩坏神格 因陀罗·Live
function c75646263.initial_effect(c)
	c:EnableCounterPermit(0x1b)
	--equip limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(c75646263.eqlimit)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c75646263.con)
	e2:SetTarget(c75646263.tg)
	e2:SetOperation(c75646263.op)
	c:RegisterEffect(e2)  
	--back
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCondition(c75646263.backon)
	e3:SetOperation(c75646263.backop)
	c:RegisterEffect(e3)
end
c75646263.card_code_list={75646000}
function c75646263.eqlimit(e,c)
	return c:IsSetCard(0x2c0)
end
function c75646263.con(e)
	return e:GetHandler():GetCounter(0x1b)>0
end
function c75646263.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ds=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,TYPE_MONSTER)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,2500-ds*200)
end
function c75646263.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	e:GetHandler():RemoveCounter(tp,0x1b,1,REASON_EFFECT)
	local ds=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,TYPE_MONSTER)
	Duel.Damage(1-tp,2500-ds*200,REASON_EFFECT)
	local dg=Group.CreateGroup()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
	local sc=g:GetFirst()
		while sc do
			--atkdown
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(-1500)
			sc:RegisterEffect(e1)
			--defdown
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			sc:RegisterEffect(e2)
			if (sc:IsAttack(0) or sc:IsDefense(0)) then dg:AddCard(sc)
			else
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_DISABLE)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				sc:RegisterEffect(e3)
				local e4=e3:Clone()
				e4:SetCode(EFFECT_DISABLE_EFFECT)
				e4:SetValue(RESET_TURN_SET)
				sc:RegisterEffect(e4)
				Duel.AdjustInstantly(sc)
				local e5=e3:Clone()
				e5:SetCode(EFFECT_CANNOT_ATTACK)
				sc:RegisterEffect(e5)
			end
			Duel.BreakEffect()
			Duel.Destroy(dg,REASON_EFFECT)
			sc=g:GetNext()
		end
	end
end
function c75646263.cfilter(c)
	return aux.IsCodeListed(c,75646000) and c:IsAbleToRemoveAsCost()
end
function c75646263.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c75646263.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c75646263.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c75646263.thfilter(c)
	return c:IsSetCard(0x2c0) and c:IsAbleToHand()
end
function c75646263.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646263.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c75646263.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c75646263.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c75646263.backon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c.dfc_front_side and c:GetOriginalCode()==c.dfc_back_side
end
function c75646263.backop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tcode=c.dfc_front_side
	c:SetEntityCode(tcode)
	Duel.ConfirmCards(tp,Group.FromCards(c))
	Duel.ConfirmCards(1-tp,Group.FromCards(c))
	c:ReplaceEffect(tcode,0,0)
end