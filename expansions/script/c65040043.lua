--千声交响齿车
function c65040043.initial_effect(c)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetCondition(c65040043.indcon)
	e1:SetValue(c65040043.efilter)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetCondition(c65040043.indcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_DRAW)
	e2:SetCondition(c65040043.drcon)
	e2:SetOperation(c65040043.drop)
	c:RegisterEffect(e2)
end
function c65040043.indcon(e)
	return e:GetHandler():IsAttackPos()
end
function c65040043.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c65040043.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and r&REASON_RULE==REASON_RULE
end
function c65040043.drop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_CARD,0,65040043)
	Duel.Draw(tp,1,REASON_EFFECT)
end