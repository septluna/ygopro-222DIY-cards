--德川茉莉的棉花糖挑战
function c26804020.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26804020+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c26804020.condition)
	e1:SetTarget(c26804020.target)
	e1:SetOperation(c26804020.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c26804020.reptg)
	e2:SetValue(c26804020.repval)
	e2:SetOperation(c26804020.repop)
	c:RegisterEffect(e2)
end
function c26804020.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x600)
end
function c26804020.cfilter2(c)
	return c:IsFaceup() and c:IsAttackAbove(2000)
end
function c26804020.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c26804020.cfilter1,tp,LOCATION_MZONE,0,1,nil)
		and not Duel.IsExistingMatchingCard(c26804020.cfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c26804020.filter(c)
	return c:IsFaceup() and c:IsAttackAbove(2000)
end
function c26804020.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c26804020.filter,tp,0,LOCATION_MZONE,nil)
	local ct=g:GetCount()
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c26804020.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c26804020.filter,tp,0,LOCATION_MZONE,nil)
	local ct=g:GetCount()
	Duel.Draw(p,ct,REASON_EFFECT)
end
function c26804020.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x600)
		and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c26804020.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c26804020.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c26804020.repval(e,c)
	return c26804020.repfilter(c,e:GetHandlerPlayer())
end
function c26804020.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
