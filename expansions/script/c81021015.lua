--佐城雪美的午后甜点
function c81021015.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81021015,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81021015+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c81021015.indcon)
	e1:SetCost(c81021015.cost)
	e1:SetTarget(c81021015.target)
	e1:SetOperation(c81021015.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c81021015.reptg)
	e2:SetValue(c81021015.repval)
	e2:SetOperation(c81021015.repop)
	c:RegisterEffect(e2)
end
function c81021015.indcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_ONFIELD,0,1,nil,0x818)
end
function c81021015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c81021015.thfilter(c)
	return c:IsAbleToHand()
end
function c81021015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81021015.thfilter,tp,LOCATION_PZONE,LOCATION_PZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c81021015.thfilter,tp,LOCATION_PZONE,LOCATION_PZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c81021015.tsfilter(c)
	return c:GetType()==0x82 and c:IsAbleToHand()
end
function c81021015.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c81021015.thfilter,tp,LOCATION_PZONE,LOCATION_PZONE,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		local ng=Duel.GetMatchingGroup(c81021015.tsfilter,tp,LOCATION_DECK,0,nil)
		if ng:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81021015,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=ng:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c81021015.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c81021015.splimit(e,c)
	return not (c:IsSetCard(0x818) or (c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM)))
end
function c81021015.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x818)
		and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c81021015.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c81021015.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c81021015.repval(e,c)
	return c81021015.repfilter(c,e:GetHandlerPlayer())
end
function c81021015.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
