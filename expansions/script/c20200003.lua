--病毒感染疫区
function c20200003.initial_effect(c)
	 --Activate
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_ACTIVATE)
	e7:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e7)
	--tohand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(20200003,0))
	e0:SetCategory(CATEGORY_DRAW)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_FZONE)
	e0:SetCountLimit(1,20200003)
	e0:SetCost(c20200003.cost)
	e0:SetTarget(c20200003.target)
	e0:SetOperation(c20200003.operation)
	c:RegisterEffect(e0)
	--pos&atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_POSITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTarget(c20200003.ptg)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetValue(0)
	c:RegisterEffect(e2)
	--disable summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c20200003.sumlimit)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e5)
	--setcard
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e6:SetCode(EFFECT_ADD_SETCODE)
	e6:SetValue(0x2020)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsFaceup))
	c:RegisterEffect(e6)
end
function c20200003.refilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2020) and c:IsReleasable()
end
function c20200003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20200003.refilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c20200003.refilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c20200003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c20200003.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c20200003.ptg(e,c)
	return c:IsSetCard(0x2020) and c:IsFaceup()
end

function c20200003.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsSetCard(0x2020)
end