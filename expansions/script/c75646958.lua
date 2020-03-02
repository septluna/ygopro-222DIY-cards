--深海音乐节 希儿
function c75646958.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c75646958.spcon)	
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75646950,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,75646958)
	e2:SetCondition(c75646958.nscon)
	e2:SetTarget(c75646958.nstg)
	e2:SetOperation(c75646958.nsop)
	c:RegisterEffect(e2)
	if not c75646958.global_check then
		c75646958.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_NEGATED)
		ge1:SetOperation(c75646958.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_NEGATED)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_CHAIN_NEGATED)
		Duel.RegisterEffect(ge3,0)
	end
end
function c75646958.checkop(e,tp,eg,ep,ev,re,r,rp)
	local  tp=e:GetHandlerPlayer()
	if (eg and eg:IsExists(Card.IsSetCard,1,nil,0xa2c2)) or 
	(re and re:GetHandler():IsSetCard(0xa2c2))then
		Duel.RegisterFlagEffect(tp,75646958,RESET_PHASE+PHASE_END,0,1)
	end
end
function c75646958.spcon(e,c)
	if c==nil then return true end  
	local f=Duel.GetFlagEffect(e:GetHandlerPlayer(),75646958)
	return f and f>0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c75646958.nscon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and ep==tp
end
function c75646958.nstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToHand() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c75646958.filter(c,e,tp)
	return c:IsSetCard(0xa2c2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c75646958.nsop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		re:GetHandler():CancelToGrave()
		if Duel.SendtoHand(eg,nil,REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c75646958.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(75646958,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c75646958.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end