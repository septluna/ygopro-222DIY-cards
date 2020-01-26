--渺奏迷景-为此而生
function c65072022.initial_effect(c)
	aux.AddCodeList(c,65072016)
	 --Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCost(c65072022.music)
	c:RegisterEffect(e0)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetCondition(c65072022.discon)
	e2:SetOperation(c65072022.disop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(c65072022.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--copyeffect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c65072022.con)
	e1:SetCost(c65072022.cost)
	e1:SetOperation(c65072022.op)
	c:RegisterEffect(e1)
end
function c65072022.music(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(65072022,0))
end
function c65072022.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttacker() and e:GetHandler():IsRelateToBattle()
end
function c65072022.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Release(e:GetHandler(),REASON_EFFECT)
end
function c65072022.val(e,c)
	local tp=e:GetHandlerPlayer()
	local num=Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,LOCATION_REMOVED)
	return num*100
end
function c65072022.eftgfil(c,tp)
	return c:IsCode(65071999) and c:IsControler(1-tp)
end
function c65072022.eftg(e,c)
	local g=c:GetColumnGroup()
	local tp=c:GetControler()
	return c:IsType(TYPE_EFFECT) and g:IsExists(c65072022.eftgfil,1,nil,tp)
end

function c65072022.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_FZONE,0,1,nil)
end
function c65072022.costfil1(c)
	return aux.IsCodeListed(c,65072016) and c:IsAbleToRemoveAsCost()
end

function c65072022.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c65072022.costfil1,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,c65072022.costfil1,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c65072022.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_FZONE,0,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local cid=tc:CopyEffect(65072022,RESET_EVENT+RESETS_STANDARD)
		local e1=Effect.CreateEffect(tc)
		e1:SetCategory(CATEGORY_TOGRAVE)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetRange(LOCATION_FZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCondition(c65072022.tgcon)
		e1:SetTarget(c65072022.tgtg)
		e1:SetOperation(c65072022.tgop)
		tc:RegisterEffect(e1,true)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65072022,1))
	end
end
function c65072022.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c65072022.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c65072022.tgopfil(c)
	return c:IsReleasableByEffect() and c:IsCode(65071999)
end
function c65072022.tgop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.IsExistingMatchingCard(c65072022.tgopfil,tp,LOCATION_MZONE,0,1,nil) then
		local g=Duel.SelectMatchingCard(tp,c65072022.tgopfil,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.Release(g,REASON_EFFECT)
	else
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	end
end
