--佐城雪美的眼神
function c81021001.initial_effect(c)
	aux.AddRitualProcGreater2(c,c81021001.ritual_filter)
	--lpcost replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81021001,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EFFECT_LPCOST_REPLACE)
	e3:SetCondition(c81021001.lrcon)
	e3:SetOperation(c81021001.lrop)
	c:RegisterEffect(e3)
end
function c81021001.ritual_filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM) and c:IsLevel(1)
end
function c81021001.lrcon(e,tp,eg,ep,ev,re,r,rp)
	if tp~=ep then return false end
	local lp=Duel.GetLP(ep)
	if lp<ev then return false end
	if not re or not re:IsHasType(0x7e0) or not e:GetHandler():IsAbleToRemove() then return false end
	local rc=re:GetHandler()
	return rc:IsSetCard(0x818) and (rc:IsLocation(LOCATION_MZONE) or rc:IsLocation(LOCATION_PZONE))
end
function c81021001.lrop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
