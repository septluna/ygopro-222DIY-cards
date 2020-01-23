--渺奏迷景-馨纯繁香
function c65072009.initial_effect(c)
	aux.AddCodeList(c,65072000)
	--change field
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOGRAVE)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e0:SetCode(EVENT_PHASE+PHASE_END)
	e0:SetRange(LOCATION_FZONE)
	e0:SetCountLimit(1)
	e0:SetCondition(c65072009.ccon)
	e0:SetTarget(c65072009.ctg)
	e0:SetOperation(c65072009.cop)
	c:RegisterEffect(e0)
	--effect gain
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65072009,1))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c65072009.scon)
	e1:SetTarget(c65072009.stg)
	e1:SetOperation(c65072009.sop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c65072009.eftg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--become effect monster
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ADD_TYPE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c65072009.eftg)
	e3:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_REMOVE_TYPE)
	e4:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e4)
end
function c65072009.ccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c65072009.ctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c65072009.copfil(c)
	return aux.IsCodeListed(c,65072000) and not c:IsForbidden() and c:IsType(TYPE_FIELD)
end
function c65072009.cop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	local g=Duel.SelectMatchingCard(tp,c65072009.copfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local code=tc:GetCode()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.Hint(21,0,aux.Stringid(code,0))
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e0:SetCode(EFFECT_CANNOT_TRIGGER)
		e0:SetRange(LOCATION_FZONE)
		e0:SetReset(RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e0)
	end
end

function c65072009.eftg(e,c)
	return c:IsCode(65071999)
end

function c65072009.scon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL)
end
function c65072009.scfil(c,tp)
	return c:IsSetCard(0xcda7) and c:IsAbleToDeck() and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,2,c)
end
function c65072009.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65072009.scfil,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_GRAVE)
end
function c65072009.sop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c65072009.scfil,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,tp)
	if g:GetCount()>0 then
		local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,2,2,g)
		g:Merge(g2)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
