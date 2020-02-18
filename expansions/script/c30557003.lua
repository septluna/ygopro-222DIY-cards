--永辉真理 回溯推理
function c30557003.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(30557003,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c30557003.drcost)
	e1:SetTarget(c30557003.drtg)
	e1:SetOperation(c30557003.drop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(30557003,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c30557003.condition)
	e2:SetTarget(c30557003.target)
	e2:SetOperation(c30557003.operation)
	c:RegisterEffect(e2)
end
function c30557003.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,30557003)==0
end
function c30557003.stfil(c,tp)
	return c:IsSetCard(0x306) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or c:IsType(TYPE_FIELD))
end
function c30557003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.IsExistingMatchingCard(c30557003.stfil,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c30557003.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,30557003,RESET_PHASE+PHASE_END,0,1)
	local c=e:GetHandler()
	if Duel.GetMZoneCount(tp)>0 and c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 and Duel.IsExistingMatchingCard(c30557003.stfil,tp,LOCATION_DECK,0,1,nil,tp) then
		Duel.ConfirmCards(1-tp,c)
		local g=Duel.SelectMatchingCard(tp,c30557003.stfil,tp,LOCATION_DECK,0,1,1,nil,tp)
		--Duel.SSet(tp,g)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			Duel.SSet(tp,tc)
			Duel.ConfirmCards(1-tp,tc)
			if tc:IsType(TYPE_QUICKPLAY) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
			if tc:IsType(TYPE_TRAP) then
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
			end
		end
	end
end
function c30557003.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c30557003.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN)
end
function c30557003.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN) and Duel.IsExistingMatchingCard(c30557003.spfil,tp,LOCATION_HAND,0,1,e:GetHandler(),e,tp) and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND)
	if Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_MZONE,0,nil)>0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
	end
end
function c30557003.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 or Duel.IsPlayerAffectedByEffect(tp,59822133) or not c:IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,c30557003.spfil,tp,LOCATION_HAND,0,1,1,c,e,tp)
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