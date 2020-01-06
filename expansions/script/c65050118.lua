--升阶魔法-霓色的热恋
function c65050118.initial_effect(c)
	--negate attack
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,65050118+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65050118.con1)
	e1:SetTarget(c65050118.tg1)
	e1:SetOperation(c65050118.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetCondition(c65050118.con2)
	e2:SetTarget(c65050118.tg2)
	c:RegisterEffect(e2)
end
function c65050118.con1(e,tp,eg,ep,ev,re,r,rp)
	local b=Duel.GetAttackTarget()
	return c65050118.confil(b,e,tp)
end
function c65050118.confil(c,e,tp)
	local rk=c:GetRank()
	return c:IsSetCard(0x3da8) and c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsControler(tp) and Duel.IsExistingMatchingCard(c65050118.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) 
end
function c65050118.filter2(c,e,tp,mc,rk)
	return c:GetRank()>rk and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c:IsSetCard(0x3da8) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c65050118.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65050118.confil,1,nil,e,tp) and rp~=tp
end
function c65050118.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(Duel.GetAttackTarget())
end
function c65050118.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:FilterSelect(tp,c65050118.confil,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
end
function c65050118.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 or not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65050118.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank())
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		if Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 then
			sc:CompleteProcedure()
			local e6=Effect.CreateEffect(e:GetHandler())
			e6:SetType(EFFECT_TYPE_SINGLE)
			e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e6:SetRange(LOCATION_MZONE)
			e6:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e6:SetValue(1)
			sc:RegisterEffect(e6)
			local e7=e6:Clone()
			e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			sc:RegisterEffect(e7)
		end
	end
end