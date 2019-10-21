--蓝玫瑰·独立
function c26803107.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.NOT(aux.FilterBoolFunction(Card.IsLinkType,TYPE_TOKEN)),3,99,c26803107.lcheck)
	c:EnableReviveLimit()
	--atkup
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_UPDATE_ATTACK)
	e0:SetValue(c26803107.value)
	c:RegisterEffect(e0)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,26803107)
	e1:SetOperation(c26803107.regop)
	c:RegisterEffect(e1)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,26803197)
	e3:SetCondition(c26803107.thcon2)
	e3:SetTarget(c26803107.thtg2)
	e3:SetOperation(c26803107.thop2)
	c:RegisterEffect(e3)
end
function c26803107.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkCode)==g:GetCount()
end
function c26803107.atkfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c26803107.value(e,c)
	local tp=c:GetControler()
	if Duel.GetTurnPlayer()~=tp then return 0 end
	return Duel.GetMatchingGroupCount(c26803107.atkfilter,tp,LOCATION_GRAVE,0,nil)*100
end
function c26803107.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c26803107.xyztg)
	e1:SetValue(c26803107.xyzlv)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c26803107.xyztg(e,c)
	return c:IsLevel(12) and c:IsAttack(2200) and c:IsDefense(600)
end
function c26803107.xyzlv(e,c,rc)
	return 0x20060000+c:GetLevel()
end
function c26803107.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT))	and c:IsPreviousPosition(POS_FACEUP)
end
function c26803107.thfilter2(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAttack(2200) and c:IsDefense(600) and c:IsAbleToHand()
end
function c26803107.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26803107.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26803107.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26803107.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
