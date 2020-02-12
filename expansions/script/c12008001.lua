--诀别六曜，波恋达斯
function c12008001.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12008001,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CUSTOM+12008001)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,12008001)
	e1:SetCondition(c12008001.spcon)
	e1:SetTarget(c12008001.sptg)
	e1:SetOperation(c12008001.spop)
	c:RegisterEffect(e1)
	--speical summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetDescription(aux.Stringid(12008001,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)	
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c12008001.sptg2)
	e3:SetOperation(c12008001.spop2)
	c:RegisterEffect(e3)
	if not c12008001.global_check then
		c12008001.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c12008001.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c12008001.tgfilter(c,race,atk,e,tp)
	return c:GetAttack()==atk and c:IsRace(race) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and Duel.IsExistingMatchingCard(c12008001.tgfilter2,tp,LOCATION_HAND+LOCATION_MZONE,LOCATION_MZONE,1,c,race,atk,e,tp) and Duel.GetLocationCountFromEx(tp,tp,c,TYPE_XYZ)>0 and c:IsAbleToGrave()
end
function c12008001.tgfilter2(c,race,atk,e,tp)
	return c:GetAttack()==atk and c:IsRace(race) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and Duel.IsExistingMatchingCard(c12008001.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) and c:IsAbleToGrave()
end
function c12008001.spfilter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:IsSetCard(0xfb0)
end
function c12008001.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c12008001.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetRace(),c:GetAttack(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
end
function c12008001.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c12008001.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,LOCATION_MZONE,1,1,nil,c:GetRace(),c:GetAttack(),e,tp)
	if g1:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c12008001.tgfilter2,tp,LOCATION_HAND+LOCATION_MZONE,LOCATION_MZONE,1,1,g1,c:GetRace(),c:GetAttack(),e,tp)   
	g1:Merge(g2)
	if Duel.SendtoGrave(g1,REASON_EFFECT)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g3=Duel.SelectMatchingCard(tp,c12008001.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g3:GetCount()>0 and Duel.SpecialSummon(g3,0,tp,tp,true,true,POS_FACEUP)>0 then
	   g3:GetFirst():CompleteProcedure()
	end
end
function c12008001.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(0,12008001,RESET_PHASE+PHASE_END,0,1)
	if Duel.GetFlagEffect(0,12008001)==1 then
	   Duel.RaiseEvent(eg,EVENT_CUSTOM+12008001,re,r,rp,ep,ev)
	end
end
function c12008001.spfilter(c)
	return c:IsFaceup() and c:GetLevel()>0 and not c:IsRace(RACE_BEASTWARRIOR) and c:GetAttack()~=1800
end
function c12008001.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12008001.spfilter,1,nil) and Duel.GetFlagEffect(0,12008001)==1
end
function c12008001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c12008001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)<=0 then return end
	local g=eg:Filter(c12008001.spfilter,nil):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()<=0 then return end
	Duel.BreakEffect()
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_OWNER_RELATE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(1800)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_LEVEL)
		e2:SetValue(1)
		tc:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_RACE)
		e3:SetValue(RACE_BEASTWARRIOR)
		tc:RegisterEffect(e3,true)   
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetReset(RESET_EVENT+0x47e0000)
		e4:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e4,true)
		local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EFFECT_UNRELEASABLE_SUM)
	e11:SetValue(1)
	tc:RegisterEffect(e11,true)
	local e12=e11:Clone()
	e12:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	tc:RegisterEffect(e12,true)
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e13:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e13:SetValue(1)
	tc:RegisterEffect(e13,true)
	local e14=e13:Clone()
	e14:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	tc:RegisterEffect(e14,true)
	local e15=e13:Clone()
	e15:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	tc:RegisterEffect(e15,true)
	local e15=e13:Clone()
	e15:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	tc:RegisterEffect(e15,true)
	end
end
