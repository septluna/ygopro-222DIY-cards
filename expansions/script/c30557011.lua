--永辉真理 矛盾式
function c30557011.initial_effect(c)
	 --draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(30557011,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c30557011.drcost)
	e1:SetTarget(c30557011.drtg)
	e1:SetOperation(c30557011.drop)
	c:RegisterEffect(e1)
	 --to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(30557011,2))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_POSITION+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c30557011.condition)
	e2:SetOperation(c30557011.operation)
	c:RegisterEffect(e2)
end
function c30557011.confil(c)
	return not c:IsPosition(POS_FACEUP_ATTACK)
end
function c30557011.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY) and Duel.GetFlagEffect(tp,30557011)==0 and Duel.IsExistingMatchingCard(c30557011.confil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c30557011.operation(e,tp,eg,ep,ev,re,r,rp)
	 Duel.RegisterFlagEffect(tp,30557011,RESET_PHASE+PHASE_END,0,1)
	local g=Duel.GetMatchingGroup(c30557011.confil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	if g:GetCount()>0 and Duel.ChangePosition(g,POS_FACEUP_ATTACK)~=0 then
		Duel.BreakEffect()
		local dg1=Group.CreateGroup()
		local dg2=Group.CreateGroup()
		local c=e:GetHandler()
		local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local tc=g2:GetFirst()
		while tc do
			local preatk=tc:GetAttack()
			local down=tc:GetBaseDefense()
			if down<=0 then down=0 end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-down)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			if preatk~=0 and tc:IsAttack(0) then dg1:AddCard(tc) end
			if tc:IsAttack(preatk) then dg2:AddCard(tc) end
			tc=g2:GetNext()
		end
		Duel.Destroy(dg1,REASON_EFFECT)
		Duel.SendtoGrave(dg2,REASON_RULE)
	end
end
function c30557011.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c30557011.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN)
end
function c30557011.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN) and Duel.IsExistingMatchingCard(c30557011.spfil,tp,LOCATION_HAND,0,1,e:GetHandler(),e,tp) and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND)
	if Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_MZONE,0,nil)>0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
	end
end
function c30557011.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 or Duel.IsPlayerAffectedByEffect(tp,59822133) or not c:IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,c30557011.spfil,tp,LOCATION_HAND,0,1,1,c,e,tp)
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