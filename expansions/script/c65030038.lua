--祸摆沉睡者 勒缇
function c65030038.initial_effect(c)
   --control
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c65030038.pdop)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e0)
   --extra material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65030038,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c65030038.sprcon)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_HAND)
	e3:SetTarget(c65030038.mattg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--pandolum
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DISABLE+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCountLimit(1,65030038)
	e4:SetRange(LOCATION_HAND)  
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c65030038.con)
	e4:SetTarget(c65030038.tg)
	e4:SetOperation(c65030038.op)
	c:RegisterEffect(e4)
end
function c65030038.confil(c)
	return c:IsSetCard(0x3da9) and c:IsPreviousLocation(LOCATION_MZONE) and (c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) or c:IsPreviousPosition(POS_FACEUP))
end
function c65030038.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65030038.confil,1,nil)
end
function c65030038.tgfil(c)
	return c:IsFaceup()
end
function c65030038.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65030038.tgfil,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c65030038.op(e,tp,eg,ep,ev,re,r,rp)
	local num=eg:FilterCount(c65030038.confil,nil)
	local g=Duel.SelectMatchingCard(tp,c65030038.tgfil,tp,0,LOCATION_ONFIELD,1,num,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		while tc do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
		end
		if Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and e:GetHandler():IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(65030038,1)) then
			Duel.BreakEffect()
			Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

function c65030038.pdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.GetControl(e:GetHandler(),1-tp)
	Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
end
function c65030038.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c65030038.mattg(e,c)
	return c:IsSetCard(0x3da9) 
end