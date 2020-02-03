--崩坏学园 丽塔
function c75646014.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c75646014.target)
	e1:SetOperation(c75646014.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c75646014.atkval)
	c:RegisterEffect(e3)
	--act limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c75646014.chaincon)
	e4:SetOperation(c75646014.chainop)
	c:RegisterEffect(e4)
end
function c75646014.filter(c)
	return (aux.IsCodeListed(c,75646151) or aux.IsCodeListed(c,75646165)) and c:IsSetCard(0x2c0) 
		and c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c75646014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646014.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c75646014.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c75646014.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c75646014.confilter(c)
	return c:IsFaceup() and (aux.IsCodeListed(c,75646151) or aux.IsCodeListed(c,75646165))
end
function c75646014.atkval(e,re,val,r,rp,rc)
	return Duel.GetMatchingGroupCount(c75646014.confilter,tp,LOCATION_SZONE,0,nil)*500
end
function c75646014.chaincon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c75646014.chainop(e,tp,eg,ep,ev,re,r,rp)
	local es=re:GetHandler()
	if es:IsSetCard(0x2c0) and es:IsType(TYPE_EQUIP) 
		and es:GetEquipTarget()==e:GetHandler() and re:IsActiveType(TYPE_SPELL) and ep==tp then
		if Duel.IsPlayerAffectedByEffect(e:GetHandler():GetControler(),75646210) then
			Duel.SetChainLimit(c75646014.chainlm)
		else
			Duel.SetChainLimit(aux.FALSE)
		end  
	end
end
function c75646014.chainlm(e,rp,tp)
	return tp==rp
end