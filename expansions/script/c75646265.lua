--崩坏神格 阿尔忒弥斯·Live
function c75646265.initial_effect(c)
	aux.AddCodeList(c,75646165)
	c:EnableCounterPermit(0x1b)
	--equip limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(c75646265.eqlimit)
	c:RegisterEffect(e1)
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(1000)
	e2:SetCondition(c75646265.con)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75646265,0))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c75646265.rmtg)
	e3:SetCondition(c75646265.rmcon)
	e3:SetOperation(c75646265.rmop)
	c:RegisterEffect(e3)
	--back
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e5:SetCondition(c75646265.backon)
	e5:SetOperation(c75646265.backop)
	c:RegisterEffect(e5)
end
function c75646265.eqlimit(e,c)
	return c:IsSetCard(0x2c0)
end
function c75646265.con(e)
	return e:GetHandler():GetCounter(0x1b)>0
end
function c75646265.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	return (Duel.GetAttacker()==tc or Duel.GetAttackTarget()==tc)
		and e:GetHandler():GetCounter(0x1b)>0
end
function c75646265.rmfilter(c)
	return c:IsAbleToRemove()
end
function c75646265.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646265.rmfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c75646265.rmfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c75646265.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	c:RemoveCounter(tp,0x1b,1,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,c75646265.rmfilter,tp,0,LOCATION_ONFIELD,1,3,nil)
	if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)~=0 then
		local og=Duel.GetOperatedGroup()
		local mg,matk=og:GetMaxGroup(Card.GetBaseAttack)
		if matk>0 then
			Duel.Damage(1-tp,matk,REASON_EFFECT)
		end
	end
end
function c75646265.backon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c.dfc_front_side and c:GetOriginalCode()==c.dfc_back_side
end
function c75646265.backop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tcode=c.dfc_front_side
	c:SetEntityCode(tcode)
	Duel.ConfirmCards(tp,Group.FromCards(c))
	Duel.ConfirmCards(1-tp,Group.FromCards(c))
	c:ReplaceEffect(tcode,0,0)
end