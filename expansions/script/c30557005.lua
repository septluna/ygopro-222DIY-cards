--永辉真理 负命题
function c30557005.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(30557005,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c30557005.drcost)
	e1:SetTarget(c30557005.drtg)
	e1:SetOperation(c30557005.drop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(30557005,2))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c30557005.condition)
	e2:SetTarget(c30557005.target)
	e2:SetOperation(c30557005.operation)
	c:RegisterEffect(e2)
end
function c30557005.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY) and Duel.GetFlagEffect(tp,30557005)==0
end
function c30557005.stfil(c)
	return c:IsSetCard(0x306) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and (Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=4 or c:IsLocation(LOCATION_GRAVE))
end
function c30557005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30557005.stfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c30557005.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,30557005,RESET_PHASE+PHASE_END,0,1)
	local g=Duel.SelectMatchingCard(tp,c30557005.stfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,tp,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.BreakEffect()
		local dg=Duel.GetDecktopGroup(tp,3)
		if dg:GetCount()==3 then
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end

function c30557005.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c30557005.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN)
end
function c30557005.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN) and Duel.IsExistingMatchingCard(c30557005.spfil,tp,LOCATION_HAND,0,1,e:GetHandler(),e,tp) and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND)
	if Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_MZONE,0,nil)>0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
	end
end
function c30557005.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 or Duel.IsPlayerAffectedByEffect(tp,59822133) or not c:IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,c30557005.spfil,tp,LOCATION_HAND,0,1,1,c,e,tp)
	if g:GetCount()>0 then
		g:AddCard(c)
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then
			Duel.ConfirmCards(1-tp,g)
			Duel.BreakEffect()
			local sg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,0,nil)
			Duel.ShuffleSetCard(sg)
			local bg=sg:FilterSelect(1-tp,aux.TRUE,1,1,nil)
			Duel.Destroy(bg,REASON_EFFECT)
		end
	end
end