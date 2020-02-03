--三番大吉·高山纱代子
function c81017024.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,81017024)
	e1:SetCondition(c81017024.hspcon)
	e1:SetOperation(c81017024.hspop)
	c:RegisterEffect(e1)
	--lv change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,81017924)
	e3:SetTarget(c81017024.lvtg)
	e3:SetOperation(c81017024.lvop)
	c:RegisterEffect(e3)
end
function c81017024.rfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsFaceup() and c:IsReleasable()
end
function c81017024.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>0 and Duel.IsExistingMatchingCard(c81017024.rfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c81017024.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c81017024.rfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c81017024.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x819)
end
function c81017024.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81017024.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(81017024,1))
	local lv=Duel.AnnounceLevel(tp,4,7)
	e:SetLabel(lv)
end
function c81017024.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c81017024.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c81017024.splimit)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c81017024.splimit(e,c)
	return not c:IsRace(RACE_WARRIOR)
end
