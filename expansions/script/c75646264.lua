--崩坏神格 海姆达尔·Live
function c75646264.initial_effect(c)
	c:EnableCounterPermit(0x1b)
	aux.AddCodeList(c,75646000,75646150,75646260,75646208)
	--equip limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(c75646264.eqlimit)
	c:RegisterEffect(e1)
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(1000)
	e2:SetCondition(c75646264.atkcon)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c75646264.cost)
	e3:SetCondition(c75646264.con)
	e3:SetTarget(c75646264.tg)
	e3:SetOperation(c75646264.op)
	c:RegisterEffect(e3) 
	--attack monster twice
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_EXTRA_ATTACK)
	e4:SetCondition(c75646264.eacon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--back
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e5:SetCondition(c75646264.backon)
	e5:SetOperation(c75646264.backop)
	c:RegisterEffect(e5)
end
c75646264.card_code_list={75646000,75646150,75646260,75646208}
function c75646264.eqlimit(e,c)
	return c:IsSetCard(0x2c0)
end
function c75646264.atkcon(e)
	return e:GetHandler():GetCounter(0x1b)>0
end
function c75646264.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1b,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1b,1,REASON_COST)
end
function c75646264.con(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	return (Duel.GetAttacker()==tc or Duel.GetAttackTarget()==tc)
		and e:GetHandler():GetCounter(0x1b)>0
end
function c75646264.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,200)
end
function c75646264.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	for i=e:GetHandler():GetFlagEffect(75646264),9 do
		Duel.Damage(1-tp,200,REASON_EFFECT)  
		e:GetHandler():RegisterFlagEffect(75646264,RESET_EVENT+RESET_CHAIN,0,0)
	end
end
function c75646264.eafilter(c)
	return aux.IsCodeListed(c,75646150) and c:IsType(TYPE_EQUIP)
end
function c75646264.eacon(e)
	return not Duel.IsExistingMatchingCard(c75646264.eafilter,e:GetHandlerPlayer(),0,LOCATION_SZONE,1,75646264)
end
function c75646264.backon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c.dfc_front_side and c:GetOriginalCode()==c.dfc_back_side
end
function c75646264.backop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tcode=c.dfc_front_side
	c:SetEntityCode(tcode)
	Duel.ConfirmCards(tp,Group.FromCards(c))
	Duel.ConfirmCards(1-tp,Group.FromCards(c))
	c:ReplaceEffect(tcode,0,0)
end