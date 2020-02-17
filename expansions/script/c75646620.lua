--窥视轮回之人 伊瑟琳
function c75646620.initial_effect(c)
	aux.AddCodeList(c,75646600)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,3,c75646620.lcheck)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--reflect battle dam
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c75646620.regop)
	c:RegisterEffect(e3)
	--cannot select battle target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e4:SetValue(c75646620.atlimit)
	c:RegisterEffect(e4)
	--recover
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c75646620.reccon)
	e5:SetOperation(c75646620.recop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	--
	local e7=e3:Clone()
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetCondition(c75646620.con)
	c:RegisterEffect(e7)
	local e8=e4:Clone()
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetCondition(c75646620.con)
	c:RegisterEffect(e8)
	local e9=e5:Clone()
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetCondition(c75646620.con)
	c:RegisterEffect(e9)
	local e10=e6:Clone()
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetCondition(c75646620.con)
	c:RegisterEffect(e10)
end
function c75646620.con(e)
	local f=Duel.GetFlagEffect(e:GetHandlerPlayer(),75646600)
	return f and f~=0
end
function c75646620.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x2c5)
end
function c75646620.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(75646620)<2 and Duel.SelectYesNo(tp,aux.Stringid(75646620,0)) then
		Duel.Hint(HINT_CARD,0,75646620)
		Duel.RegisterFlagEffect(tp,75646600,RESET_EVENT+RESET_PHASE+RESET_CHAIN,0,1)
		c:RegisterFlagEffect(75646620,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c75646620.atlimit(e,c)
	return c~=e:GetHandler() and c:IsFaceup() and c:IsSetCard(0x2c5)
end
function c75646620.cfilter(c,ec)
	if c:IsLocation(LOCATION_MZONE) then
		return c:IsSetCard(0x2c5) and c:IsFaceup() and ec:GetLinkedGroup():IsContains(c)
	else
		return c:IsPreviousSetCard(0x2c5) and c:IsPreviousPosition(POS_FACEUP)
			and bit.extract(ec:GetLinkedZone(c:GetPreviousControler()),c:GetPreviousSequence())~=0
	end
end
function c75646620.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75646620.cfilter,1,nil,e:GetHandler())
end
function c75646620.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,75646620)
	Duel.Recover(tp,200,REASON_EFFECT)
	if Duel.GetFlagEffect(tp,75646600)>0 and Duel.IsPlayerCanDraw(tp,1)	and Duel.SelectYesNo(tp,aux.Stringid(75646602,2)) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end