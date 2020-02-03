--梦前菜菜·模特
local m=81013011
local cm=_G["c"..m]
function cm.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end
function cm.cfilter(c,tp,rp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousPosition(POS_FACEUP) and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp) and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_EXTRA,0)==0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,1-tp,LOCATION_EXTRA)
end
function cm.tgfilter(c)
	return c:IsFacedown()
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,0,LOCATION_EXTRA,nil)
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0
		and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.BreakEffect()
		local sg=g:RandomSelect(tp,1)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
