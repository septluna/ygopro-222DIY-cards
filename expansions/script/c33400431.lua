--升阶魔法 DAL-WIZARD换装
function c33400431.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c33400431.target)
	e1:SetOperation(c33400431.activate)
	c:RegisterEffect(e1)
end
function c33400431.filter1(c,e,tp)
	local rk=c:GetRank()
	local zg=c:GetEquipGroup() 
	return rk>0 and c:IsFaceup() and c:IsSetCard(0xc343) and zg:IsExists(Card.IsSetCard,1,nil,0x6343)
		and Duel.IsExistingMatchingCard(c33400431.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetRank()+2)
		and Duel.GetLocationCountFromEx(tp,tp,c)>0
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c33400431.filter2(c,e,tp,mc,rk)
	return c:IsRank(rk) and c:IsSetCard(0xc343) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c33400431.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c33400431.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c33400431.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c33400431.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c33400431.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 or not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33400431.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+2)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
		if Duel.IsExistingMatchingCard(c33400431.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,sc) then 
		   if  Duel.SelectYesNo(tp,aux.Stringid(33400431,0)) then 
			 local tc2=Duel.SelectMatchingCard(tp,c33400431.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,sc)
			 local tc1=tc2:GetFirst()
			 Duel.Equip(tp,tc1,sc)
		   end
		end
	end
end
function c33400431.filter(c,e,tp,ec)
	return c:IsSetCard(0x6343)  and c:CheckEquipTarget(ec)and c:CheckUniqueOnField(tp)
end