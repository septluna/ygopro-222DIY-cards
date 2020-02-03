--莉莉 -甜蜜工厂-
function c1192020.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1192020,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,1192020)
	e1:SetCondition(c1192020.con1)
	e1:SetCost(c1192020.cost1)
	e1:SetTarget(c1192020.tg1)
	e1:SetOperation(c1192020.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1192020,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c1192020.cost2)
	e2:SetTarget(c1192020.tg2)
	e2:SetOperation(c1192020.op2)
	c:RegisterEffect(e2)
--
	if c1192020.checklp==nil then
		c1192020.checklp=true
		c1192020.lplist={[0]=Duel.GetLP(tp),[1]=Duel.GetLP(tp),}
		c1192020.eList={[0]={},[1]={},}
	end
--
end
--
function c1192020.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_DECK)
		and not c:IsReason(REASON_DRAW)
end
--
function c1192020.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,100) end
	Duel.PayLPCost(tp,100)
end
--
function c1192020.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
--
function c1192020.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function c1192020.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
--
function c1192020.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLP(tp)<c1192020.lplist[tp] end
	local num=math.min(2020,(c1192020.lplist[tp]-Duel.GetLP(tp)))
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(num)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,num)
end
--
function c1192020.op2(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local num=math.min(2020,(c1192020.lplist[p]-Duel.GetLP(p)))
	Duel.Recover(p,num,REASON_EFFECT)
end
--
