--空中都市 幸存者
function c30556003.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,30556003)
	e1:SetTarget(c30556003.target)
	e1:SetOperation(c30556003.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c30556003.cost)
	e2:SetTarget(c30556003.tg)
	e2:SetOperation(c30556003.op)
	c:RegisterEffect(e2)
end
function c30556003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
   -- if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
--	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c30556003.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30556003.spfil,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) and Duel.GetMZoneCount(tp)>0 and Duel.GetFlagEffect(tp,30556003)==0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c30556003.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,30556003,RESET_PHASE+PHASE_END,0,1)
	if Duel.GetMZoneCount(tp)>0 then
		local g=Duel.SelectMatchingCard(tp,c30556003.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then 
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c30556003.spfil(c,e,tp)
	return c:IsSetCard(0x305) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c30556003.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c30556003.tgfil,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c30556003.spfil,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 end
	local g=Duel.SelectTarget(tp,c30556003.tgfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c30556003.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetMZoneCount(tp)>0 then
		local g=Duel.SelectMatchingCard(tp,c30556003.spfil,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsRelateToEffect(e) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end