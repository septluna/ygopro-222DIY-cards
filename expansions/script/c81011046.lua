--冬夜花火·木村有容
function c81011046.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP,1)
	e1:SetCountLimit(1,81011046)
	e1:SetCondition(c81011046.hspcon)
	e1:SetValue(c81011046.hspval)
	c:RegisterEffect(e1)
	--bottle
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81011946)
	e2:SetCondition(c81011046.con)
	e2:SetTarget(c81011046.tg)
	e2:SetOperation(c81011046.op)
	c:RegisterEffect(e2)
	--control
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c81011046.cocon)
	e3:SetTarget(c81011046.cotg)
	e3:SetOperation(c81011046.coop)
	c:RegisterEffect(e3)
end
function c81011046.cfilter(c)
	return c:GetColumnGroupCount()>0
end
function c81011046.hspzone(tp)
	local zone=0
	local lg=Duel.GetMatchingGroup(c81011046.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,1-tp))
	end
	return bit.bnot(zone)
end
function c81011046.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=c81011046.hspzone(tp)
	return Duel.GetLocationCount(1-tp,LOCATION_MZONE,1-tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c81011046.hspval(e,c)
	local tp=c:GetControler()
	local zone=c81011046.hspzone(tp)
	return 0,zone
end
function c81011046.confil(c,tp)
	return c:GetOwner()==1-tp and c:IsControler(tp)
end
function c81011046.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81011046.confil,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c81011046.hfilter(c)
	return c:IsAbleToRemove() and c:GetOwner()==c:GetControler()
end
function c81011046.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c81011046.hfilter,tp,LOCATION_ONFIELD,0,nil)
	if g:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,tp,LOCATION_ONFIELD)
	end
end
function c81011046.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=Duel.SelectMatchingCard(tp,c81011046.hfilter,tp,LOCATION_ONFIELD,0,1,63,nil)
	local ct=Duel.Remove(cg,POS_FACEUP,REASON_EFFECT)
	if ct>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*-200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,1)
		c:RegisterEffect(e1)
	end
end
function c81011046.cocon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c81011046.cotg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end
function c81011046.coop(e,tp,eg,ep,ev,re,r,rp)
	local sp=e:GetHandler():GetOwner()
	if Duel.GetLocationCount(sp,LOCATION_MZONE)>0 and not e:GetHandler():IsControler(sp) then
		Duel.GetControl(e:GetHandler(),sp)
	end
end
