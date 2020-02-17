--永辉真理 三段论
function c30557002.initial_effect(c)
	 --draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(30557002,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c30557002.drcost)
	e1:SetTarget(c30557002.drtg)
	e1:SetOperation(c30557002.drop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(30557002,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c30557002.condition)
	e2:SetOperation(c30557002.operation)
	c:RegisterEffect(e2)
end
function c30557002.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY) and Duel.GetFlagEffect(tp,30557002)==0
end
function c30557002.opfil(c,ct)
	return (ct==0 and c:IsType(TYPE_MONSTER)) or (ct==1 and c:IsType(TYPE_SPELL)) or (ct==2 and c:IsType(TYPE_TRAP))
end
function c30557002.tggfil(c,ct)
	return c30557002.opfil(c,ct) and c:IsFaceup()
end
function c30557002.desfil(c)
	return c:IsSetCard(0x306) and c:IsType(TYPE_MONSTER) and not c:IsCode(30557002)
end
function c30557002.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local ct=Duel.AnnounceType(tp)
	Duel.ConfirmDecktop(1-tp,3)
	local g=Duel.GetDecktopGroup(1-tp,3)
	local num=g:FilterCount(c30557002.opfil,nil,ct)
	if num>=1 and Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsRelateToEffect(e) then
	   if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(30557002,0)) then
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
	   end
	end
	if num>=2 and Duel.IsExistingMatchingCard(c30557002.desfil,tp,LOCATION_DECK,0,1,nil) then
		local dg=Duel.SelectMatchingCard(tp,c30557002.desfil,tp,LOCATION_DECK,0,1,1,nil)
		Duel.Destroy(dg,REASON_EFFECT)
	end
	if num==3 and Duel.GetMatchingGroupCount(c30557002.tggfil,tp,0,LOCATION_ONFIELD,nil,ct)>0 then
		local tgg=Duel.GetMatchingGroup(c30557002.tggfil,tp,0,LOCATION_ONFIELD,nil,ct)
		Duel.SendtoGrave(tgg,REASON_RULE)
	end
	Duel.RegisterFlagEffect(tp,30557002,RESET_PHASE+PHASE_END,0,1)
end
function c30557002.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c30557002.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN)
end
function c30557002.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN) and Duel.IsExistingMatchingCard(c30557002.spfil,tp,LOCATION_HAND,0,1,e:GetHandler(),e,tp) and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND)
	if Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_MZONE,0,nil)>0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
	end
end
function c30557002.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 or Duel.IsPlayerAffectedByEffect(tp,59822133) or not c:IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,c30557002.spfil,tp,LOCATION_HAND,0,1,1,c,e,tp)
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