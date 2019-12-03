--微妙世界
function c81006036.initial_effect(c)
	--Activate
	local e1=aux.AddRitualProcGreater2(c,c81006036.ritual_filter,LOCATION_HAND+LOCATION_DECK,nil,c81006036.mfilter)
	e1:SetCountLimit(1,81006036+EFFECT_COUNT_CODE_OATH)
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetTarget(c81006036.reptg)
	e1:SetValue(c81006036.repval)
	e1:SetOperation(c81006036.repop)
	c:RegisterEffect(e1)
end
function c81006036.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x81c)
		and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c81006036.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c81006036.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c81006036.repval(e,c)
	return c81006036.repfilter(c,e:GetHandlerPlayer())
end
function c81006036.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function c81006036.ritual_filter(c)
	return c:IsSetCard(0x81c) and c:IsRace(RACE_CYBERSE)
end
function c81006036.mfilter(c)
	return c:IsType(TYPE_RITUAL)
end
