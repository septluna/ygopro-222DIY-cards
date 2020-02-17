--动物之友 伊瑟琳
function c75646628.initial_effect(c)
	aux.AddCodeList(c,75646600)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75646628,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CUSTOM+75646628)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c75646628.spcon)
	e1:SetTarget(c75646628.sptg)
	e1:SetOperation(c75646628.spop)
	c:RegisterEffect(e1)
	--change cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(75646628)
	e2:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e2)
	if not c75646628.global_check then
		c75646628.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetCondition(c75646628.regcon)
		ge1:SetOperation(c75646628.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c75646628.spcfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD)
	and aux.IsCodeListed(c,75646600)
end
function c75646628.regcon(e,tp,eg,ep,ev,re,r,rp)
	local v=0
	if eg:IsExists(c75646628.spcfilter,1,nil,0) then v=v+1 end
	if eg:IsExists(c75646628.spcfilter,1,nil,1) then v=v+2 end
	if v==0 then return false end
	e:SetLabel(({0,1,PLAYER_ALL})[v])
	return true
end
function c75646628.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+75646628,re,r,rp,ep,e:GetLabel())
end
function c75646628.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ev==tp or ev==PLAYER_ALL
end
function c75646628.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c75646628.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		c:RegisterEffect(e2)
	end
end