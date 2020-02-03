--機神ヤチマ
local m=17011111
local cm=_G["c"..m]
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17011111,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCost(cm.spcost)
	e1:SetCountLimit(1,17011111)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(cm.pentg)
	e2:SetOperation(cm.penop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function cm.cfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToRemoveAsCost()
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	e:SetLabelObject(g:GetFirst())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(tc:GetAttribute())
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetValue(tc:GetAttack())
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e3:SetValue(tc:GetDefense())
	c:RegisterEffect(e3)
end
function cm.tgfilter(c)
	return c:IsLevelBelow(4) and c:IsType(TYPE_PENDULUM) and c:IsAbleToGrave()
end
function cm.pcfilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function cm.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.pcfilter,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return Duel.GetFlagEffect(tp,17011111)==0 and 
	(b1 or (b2 and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)))) end
	Duel.RegisterFlagEffect(tp,17011111,RESET_PHASE+PHASE_END,0,1)
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.pcfilter,tp,LOCATION_GRAVE,0,1,nil)
	local op=0
	if b1 and (b2 and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))) 
		then op=Duel.SelectOption(tp,aux.Stringid(17011111,1),aux.Stringid(17011111,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(17011111,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(17011111,2))+1
	else return end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	else
		if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cm.pcfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
