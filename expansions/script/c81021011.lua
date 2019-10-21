--佐城雪美的上学路
function c81021011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81021011+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c81021011.target)
	e1:SetOperation(c81021011.activate)
	c:RegisterEffect(e1)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_PAY_LPCOST)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c81021011.tgcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c81021011.tdtg)
	e2:SetOperation(c81021011.tdop)
	c:RegisterEffect(e2)
end
function c81021011.filter(c,e,tp,lp)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsSetCard(0x818) or not c:IsType(TYPE_PENDULUM)
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) then return false end
	local atk=c:GetBaseAttack()
	local def=c:GetBaseDefense()
	local yuk=atk+def
	return lp>yuk
end
function c81021011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local lp=Duel.GetLP(tp)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c81021011.filter,tp,LOCATION_HAND,0,1,nil,e,tp,lp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c81021011.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lp=Duel.GetLP(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c81021011.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,lp)
	local tc=tg:GetFirst()
	if tc then
		local atk=tc:GetBaseAttack()
		local def=tc:GetBaseDefense()
		local yuk=atk+def
		Duel.PayLPCost(tp,yuk)
		tc:SetMaterial(nil)
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c81021011.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and aux.exccon(e)
end
function c81021011.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
end
function c81021011.tdop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
