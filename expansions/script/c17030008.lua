--科技玛纳
local m=17030008
local cm=_G["c"..m]
function cm.initial_effect(c)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,17030008+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetValue(17030001)
	c:RegisterEffect(e2)
	--disable attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17030008,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_ATTACK)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(cm.condition)
	e3:SetCost(aux.bfgcost)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.rccfilter(c)
	return c:IsFaceup() and c:IsCode(17030001)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(cm.rccfilter,tp,LOCATION_ONFIELD,0,c)
	local ct=Duel.Destroy(sg,REASON_EFFECT)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>ct then ft=ct end
	if ft<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,17029901,0,0x4011,2000,1500,5,RACE_MACHINE,ATTRIBUTE_LIGHT) then return end
	local ctn=true
	while ft>0 and ctn do
		local token=Duel.CreateToken(tp,17029901)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		ft=ft-1
		if ft<=0 or not Duel.SelectYesNo(tp,aux.Stringid(17030008,0)) then ctn=false end
	end
	Duel.SpecialSummonComplete()
end
function cm.backon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return e:GetHandler():GetFlagEffect(17030008)>0
end
function cm.backop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tcode=e:GetLabel()
	c:SetEntityCode(tcode)
	Duel.ConfirmCards(tp,Group.FromCards(c))
	Duel.ConfirmCards(1-tp,Group.FromCards(c))
	c:ReplaceEffect(tcode,0,0)
	e:GetHandler():ResetFlagEffect(17030008)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (Duel.IsAbleToEnterBP() or (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE))
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttacker() then Duel.NegateAttack()
	else
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_ATTACK_ANNOUNCE)
		e3:SetReset(RESET_PHASE+PHASE_END)
		e3:SetCountLimit(1)
		e3:SetOperation(cm.disop)
		Duel.RegisterEffect(e3,tp)
	end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,17030008)
	Duel.NegateAttack()
end
