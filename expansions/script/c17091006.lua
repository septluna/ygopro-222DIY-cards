--Valvrave Ⅰ
local m=17091006
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
	--level up 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17091006,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(cm.lvop)
	c:RegisterEffect(e2)
	--halve LP
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17091006,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.hvcon)
	e3:SetOperation(cm.hvop)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_ONFIELD)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetTarget(cm.reptg)
	c:RegisterEffect(e4)
	--atklimit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_ATTACK)
	e5:SetCondition(cm.atkcon)
	c:RegisterEffect(e5)
end
function cm.atkval(e,c)
	return c:GetLevel()*100
end
function cm.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=c:GetLevel()*2
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(lv)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
function cm.sdcon(e)
	return e:GetHandler():GetLevel()==666
end
function cm.atkcon(e)
	return e:GetHandler():GetLevel()>100 and e:GetHandler():GetLevel()<666
end
function cm.spfilter(c,e,tp)
	return c:IsCode(17091005) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.hvcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.hvop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
end

function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT+REASON_REPLACE)
		Duel.BreakEffect()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
		return true
	else return false end
end
