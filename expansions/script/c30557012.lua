--永辉真理 类比推理
function c30557012.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(30557012,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,30557012)
	e1:SetCost(c30557012.drcost)
	e1:SetTarget(c30557012.drtg)
	e1:SetOperation(c30557012.drop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(30557012,2))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,30557011)
	e2:SetCondition(c30557012.condition)
	e2:SetOperation(c30557012.operation)
	c:RegisterEffect(e2)
end
function c30557012.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY) 
end
function c30557012.operation(e,tp,eg,ep,ev,re,r,rp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetOperation(c30557012.op)
	Duel.RegisterEffect(e3,tp)
end
function c30557012.op(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	if re:GetHandlerPlayer()~=tp and c~=e:GetHandler() and Duel.SelectYesNo(tp,aux.Stringid(30557012,0)) then
		Duel.ConfirmDecktop(tp,1)
		local g=Duel.GetDecktopGroup(tp,1)
		local gc=g:GetFirst()
		 if gc:IsSetCard(0x306) then
			Duel.DisableShuffleCheck()
			Duel.Destroy(g,REASON_EFFECT+REASON_REVEAL)
		else
			Duel.MoveSequence(tc,1)
		end
	end
end
function c30557012.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c30557012.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,TYPE_MONSTER) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,0)
end
function c30557012.filter(c)
	return c:IsSetCard(0x306) 
end
function c30557012.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,TYPE_MONSTER)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c30557012.filter,tp,LOCATION_DECK,0,1,nil)  and Duel.SelectYesNo(tp,aux.Stringid(30557012,1)) then
		 local g=Duel.SelectMatchingCard(tp,c30557012.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(tp,1)
	end
	end
end