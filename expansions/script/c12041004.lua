--圆奏龙 爱迷尔
local m=12041004
local cm=_G["c"..m]
function c12041004.initial_effect(c)
	--negate
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(cm.negcon)
	e1:SetOperation(cm.negop)
	c:RegisterEffect(e1)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c12041004.efilter)
	c:RegisterEffect(e1)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCountLimit(1,12041004+100)
	e3:SetOperation(c12041004.regop)
	c:RegisterEffect(e3)
end
function c12041004.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c12041004.thcon)
	e1:SetOperation(c12041004.thop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c12041004.thfilter(c)
	return c:IsRace(RACE_SEASERPENT) and c:IsAbleToDeck()
end
function c12041004.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c12041004.thfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c12041004.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,12041004)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c12041004.thfilter,tp,LOCATION_GRAVE,0,1,99,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local num=Duel.SendtoDeck(g,tp,2,REASON_EFFECT)
		if num>=5 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
		if num>=10 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
		if num>=30 then
			local tgg=Duel.GetFieldGroup(tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
			if tgg:GetCount()>0 then
				Duel.Draw(1-tp,2,REASON_EFFECT)
			end
		end
	end
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return  re:GetHandler():GetLocation()==LOCATION_GRAVE and ep==tp and Duel.IsChainNegatable(ev)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tt=c:GetOverlayCount()
	if Duel.GetFlagEffect(tp,m)==0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then 
	   Duel.NegateEffect(ev)
	   Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	   Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
end
function c12041004.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end