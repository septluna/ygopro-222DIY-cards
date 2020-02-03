--崩坏神格 缪娜·Live
function c75646261.initial_effect(c)
	c:EnableCounterPermit(0x1b)
	--equip limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(c75646261.eqlimit)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE) 
	e2:SetCondition(c75646261.con)
	e2:SetTarget(c75646261.tg)
	e2:SetOperation(c75646261.op)
	c:RegisterEffect(e2)   
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(c75646261.discon)
	e3:SetOperation(c75646261.disop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetTarget(c75646261.distg)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e5)
	--atkup
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_EQUIP)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetCondition(c75646261.atkcon)
	e6:SetValue(2000)
	c:RegisterEffect(e6)
	--back
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_ADJUST)
	e7:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e7:SetCondition(c75646261.backon)
	e7:SetOperation(c75646261.backop)
	c:RegisterEffect(e7)
end
function c75646261.eqlimit(e,c)
	return c:IsSetCard(0x2c0)
end
function c75646261.con(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	return (Duel.GetAttacker()==tc or Duel.GetAttackTarget()==tc)
		and e:GetHandler():GetCounter(0x1b)>0
end
function c75646261.gfilter(c,g)
	return g:IsContains(c) 
end
function c75646261.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646261.gfilter,tp,0,LOCATION_ONFIELD,1,nil,e:GetHandler():GetColumnGroup()) end
end
function c75646261.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end  
	local g=c:GetColumnGroup()
	c:RemoveCounter(tp,0x1b,1,REASON_EFFECT)
	local tc=g:GetFirst()
	while tc do
		if tc:GetControler()~=tp then 
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
		tc=g:GetNext()
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e3:SetValue(c:GetColumnGroupCount()*600)
	c:GetEquipTarget():RegisterEffect(e3)
end
	function c75646261.discon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and (ec==Duel.GetAttacker() or ec==Duel.GetAttackTarget()) and ec:GetBattleTarget()
end
function c75646261.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget():GetBattleTarget()
	if tc:IsType(TYPE_EFFECT) then
	tc:RegisterFlagEffect(75646261,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1)
	end
end
function c75646261.distg(e,c)
	return c:GetFlagEffect(75646261)~=0
end
function c75646261.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	local ec=e:GetHandler():GetEquipTarget()
	return ec and (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and ec:IsRelateToBattle() and ec:IsType(TYPE_EFFECT)
end
function c75646261.backon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c.dfc_front_side and c:GetOriginalCode()==c.dfc_back_side
end
function c75646261.backop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tcode=c.dfc_front_side
	c:SetEntityCode(tcode)
	Duel.ConfirmCards(tp,Group.FromCards(c))
	Duel.ConfirmCards(1-tp,Group.FromCards(c))
	c:ReplaceEffect(tcode,0,0)
end