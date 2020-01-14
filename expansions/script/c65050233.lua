--升阶魔法-月之暗咒
function c65050233.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65050233,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c65050233.target)
	e1:SetOperation(c65050233.activate)
	c:RegisterEffect(e1)
	--RaiseEvent
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEVEL_UP)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c65050233.raop)
	c:RegisterEffect(e3)
end
function c65050233.raop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsLocation(LOCATION_MZONE) then
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+65050216,e,0,tp,0,0)
	end
end
function c65050233.filter1(c,e,tp)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsSetCard(0x5da9) and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c65050233.filter2,tp,LOCATION_MZONE,0,1,nil,e,tp,c,rk)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c65050233.filter2(c,e,tp,mc,rk)
	return c:IsType(TYPE_TUNER) and Duel.IsExistingMatchingCard(c65050233.filter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,mc,rk+c:GetLevel()) and c:IsAbleToGrave() and c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c65050233.filter3(c,e,tp,mc,rk)
	return c:IsRank(rk) and c:IsSetCard(0x5da9) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c65050233.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c65050233.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c65050233.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c65050233.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c65050233.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 or not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c65050233.filter2,tp,LOCATION_MZONE,0,1,1,nil,e,tp,tc,tc:GetRank())
	if g1:GetCount()>0 then
		local lv=g1:GetFirst():GetLevel()
		if Duel.SendtoGrave(g1,REASON_EFFECT)~=0 then
			local g2=Duel.SelectMatchingCard(tp,c65050233.filter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+lv)
			local sc=g2:GetFirst()
			if sc then
				local mg=tc:GetOverlayGroup()
				if mg:GetCount()~=0 then
					Duel.Overlay(sc,mg)
				end
				sc:SetMaterial(Group.FromCards(tc))
				Duel.Overlay(sc,Group.FromCards(tc))
				Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
				sc:CompleteProcedure()
			end
		end
	end
end