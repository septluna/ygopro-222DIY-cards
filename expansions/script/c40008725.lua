--镜争兽·火山巨蟹
function c40008725.initial_effect(c)
	--cost
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_PHASE+PHASE_END)
	e0:SetCountLimit(1)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(c40008725.mtcon)
	e0:SetOperation(c40008725.mtop)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40008725,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,40008725)
	e1:SetCondition(c40008725.spcon)
	e1:SetOperation(c40008725.spop)
	c:RegisterEffect(e1)	
end
function c40008725.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c40008725.cfilter1(c)
	return c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c40008725.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	local g1=Duel.GetMatchingGroup(c40008725.cfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	local dg=g1:GetMinGroup(Card.GetAttack)
	local select=1
	if dg:GetCount()>0 then
		select=Duel.SelectOption(tp,aux.Stringid(40008725,0),aux.Stringid(40008725,1))
	else
		select=Duel.SelectOption(tp,aux.Stringid(40008725,1))+1
	end
	if select==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=dg:Select(tp,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	else
		Duel.Destroy(c,REASON_COST)
		local lp=Duel.GetLP(tp)
		Duel.SetLP(tp,lp-1000)
	end
end
function c40008725.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xf15)
end
function c40008725.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c40008725.filter,c:GetControler(),LOCATION_MZONE,0,1,nil) 
	end
function c40008725.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end