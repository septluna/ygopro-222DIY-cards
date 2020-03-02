--希儿的遮断
function c75646955.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_NEGATED)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,75646955+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c75646955.condition1)
	e1:SetTarget(c75646955.target)
	e1:SetOperation(c75646955.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_NEGATED)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_CUSTOM+75646955)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetTarget(c75646955.reptg)
	e4:SetValue(c75646955.repval)
	e4:SetOperation(c75646955.repop)
	c:RegisterEffect(e4)
	if not c75646955.global_check then
		c75646955.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_NEGATED)
		ge1:SetOperation(c75646955.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_CHAIN_DISABLED)
		Duel.RegisterEffect(ge2,0)
	end
end
function c75646955.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	if re and re:GetHandler():IsSetCard(0xa2c2) and rp==1-tp then 
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+75646955,e,0,tp,0,0)
	end
end
function c75646955.condition1(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and eg:IsExists(Card.IsSetCard,1,nil,0xa2c2)
end
function c75646955.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_HAND+LOCATION_ONFIELD)
end
function c75646955.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	local sg=Group.CreateGroup()
	if g1:GetCount()>0 and g2:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(75646955,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.HintSelection(sg1)
		sg:Merge(sg1)
	end
	if g2:GetCount()>0 and sg:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(75646955,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.HintSelection(sg2)
		sg:Merge(sg2)
	end
	Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
end
function c75646955.repfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c75646955.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c75646955.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c75646955.repval(e,c)
	return c75646955.repfilter(c,e:GetHandlerPlayer())
end
function c75646955.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end