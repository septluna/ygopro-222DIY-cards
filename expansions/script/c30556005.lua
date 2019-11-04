--空中都市 研究者
function c30556005.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,30556005)
	e1:SetTarget(c30556005.target)
	e1:SetOperation(c30556005.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c30556005.cost)
	e2:SetTarget(c30556005.tg)
	e2:SetOperation(c30556005.op)
	c:RegisterEffect(e2)
end
function c30556005.thfil(c)
	return c:IsSetCard(0x305) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c30556005.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c30556005.tgfil,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c30556005.thfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c30556005.tgfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c30556005.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.SelectMatchingCard(tp,c30556005.thfil,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 and Duel.SendtoHand(g,tp,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
			if tc:IsRelateToEffect(e) then
				Duel.Destroy(tc,REASON_EFFECT)
			end
		end
end

function c30556005.spfil(c,e,tp)
	return c:IsSetCard(0x305) and c:IsLevelAbove(4) and c:IsLevelBelow(8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c30556005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c30556005.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30556005.spfil,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) and Duel.GetMZoneCount(tp)>0 and Duel.GetFlagEffect(tp,30556005)==0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c30556005.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,30556005,RESET_PHASE+PHASE_END,0,1)
	if Duel.GetMZoneCount(tp)>0 then
		local g=Duel.SelectMatchingCard(tp,c30556005.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then 
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end