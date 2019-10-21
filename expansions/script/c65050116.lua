--霓色独珠的约定
function c65050116.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c65050116.target)
	e1:SetOperation(c65050116.activate)
	c:RegisterEffect(e1)
end
function c65050116.filter(c,e,tp,m1,m2,ft)
	if not c:IsSetCard(0x3da8) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) or not c:IsLevel(8) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	mg:Merge(m2)
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	if ft>1 then
		return mg:CheckWithSumGreater(Card.GetRitualLevel,8,c)
	else
		return ft>0 and mg:IsExists(c65050116.mfilterf,1,nil,tp,mg,c)
	end
end
function c65050116.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumGreater(Card.GetRitualLevel,8,rc)
	else return false end
end
function c65050116.spfilter(c,e,tp)
	return c:IsSetCard(0x3da8) and bit.band(c:GetType(),0x81)==0x81
	   and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) and c:IsLevel(8) 
end
function c65050116.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		local mg2=Group.CreateGroup()
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return Duel.IsExistingMatchingCard(c65050116.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg1,mg2,ft) and Duel.IsExistingMatchingCard(c65050116.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)
end
function c65050116.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Group.CreateGroup()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c65050116.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg1,mg2,ft)
	local tc=tg:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(mg2)
		if tc:IsCode(21105106) then
			tc:ritual_custom_operation(mg)
			local mat=tc:GetMaterial()
			Duel.ReleaseRitualMaterial(mat)
		else
			if tc.mat_filter then
				mg=mg:Filter(tc.mat_filter,nil)
			end
			local mat=nil
			if ft>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				mat=mg:FilterSelect(tp,c65050116.mfilterf,1,1,nil,tp,mg,tc)
				Duel.SetSelectedCard(mat)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
				mat:Merge(mat2)
			end
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
		end
		Duel.BreakEffect()
		if Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP) then
			 local e1=Effect.CreateEffect(e:GetHandler())
			 e1:SetType(EFFECT_TYPE_SINGLE)
			 e1:SetCode(EFFECT_DISABLE)
			 e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			 tc:RegisterEffect(e1)
			 local e2=Effect.CreateEffect(e:GetHandler())
			 e2:SetType(EFFECT_TYPE_SINGLE)
			 e2:SetCode(EFFECT_DISABLE_EFFECT)
			 e2:SetValue(RESET_TURN_SET)
			 e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			 tc:RegisterEffect(e2)
			 Duel.SpecialSummonComplete()
			 tc:CompleteProcedure()
			 if Duel.GetMZoneCount(tp)>0 then
				local ssg=Duel.SelectMatchingCard(tp,c65050116.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
				if ssg then
					local ssc=ssg:GetFirst()
					Duel.SpecialSummonStep(ssc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
					local e1=Effect.CreateEffect(e:GetHandler())
			 e1:SetType(EFFECT_TYPE_SINGLE)
			 e1:SetCode(EFFECT_DISABLE)
			 e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			 ssc:RegisterEffect(e1)
			 local e2=Effect.CreateEffect(e:GetHandler())
			 e2:SetType(EFFECT_TYPE_SINGLE)
			 e2:SetCode(EFFECT_DISABLE_EFFECT)
			 e2:SetValue(RESET_TURN_SET)
			 e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			 ssc:RegisterEffect(e2)
					Duel.SpecialSummonComplete()
			 ssc:CompleteProcedure()
				end
			 end
		end
	end
end