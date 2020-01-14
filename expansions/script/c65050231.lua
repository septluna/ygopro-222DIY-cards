--星月转夜的预告
function c65050231.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65050231+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c65050231.cost)
	e1:SetTarget(c65050231.target)
	e1:SetOperation(c65050231.activate)
	c:RegisterEffect(e1)
	--RaiseEvent
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEVEL_UP)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c65050231.raop)
	c:RegisterEffect(e3)
end
function c65050231.raop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsLocation(LOCATION_MZONE) then
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+65050216,e,0,tp,0,0)
	end
end
function c65050231.costfil(c)
	return Duel.IsExistingMatchingCard(c65050231.thfil,tp,LOCATION_DECK,0,1,nil,c:GetCode()) and c:IsSetCard(0x5da9) and c:IsAbleToHand()
end
function c65050231.ccostfil(c)
	return c:IsSetCard(0x5da9) and c:IsAbleToHand()
end
function c65050231.thfil(c,code)
	return c:IsSetCard(0x5da9) and c:IsAbleToHand() and not c:IsCode(code)
end
function c65050231.clvfil(c)
	return c:IsSetCard(0x5da9) and c:IsFaceup() and c:IsLevelAbove(2)
end
function c65050231.lvfil(c)
	return c:IsSetCard(0x5da9) and c:IsFaceup() and c:IsLevelAbove(3)
end
function c65050231.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c65050231.costfil,tp,LOCATION_DECK,0,1,nil)
	local b01=Duel.IsExistingMatchingCard(c65050231.ccostfil,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c65050231.lvfil,tp,LOCATION_MZONE,0,1,nil)
	local b02=Duel.IsExistingMatchingCard(c65050231.clvfil,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return b01 and b02 end
	local announce=0
	if b1 and b2 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(65050231,0))
		announce=Duel.AnnounceNumber(tp,1,2)
	else
		announce=1
	end
	local g=Group.CreateGroup()
	if announce==1 then
		g=Duel.SelectMatchingCard(tp,c65050231.clvfil,tp,LOCATION_MZONE,0,1,1,nil)
	elseif announce==2 then
		g=Duel.SelectMatchingCard(tp,c65050231.lvfil,tp,LOCATION_MZONE,0,1,1,nil)
	end
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_LEVEL)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetValue(0-announce)
	tc:RegisterEffect(e2)
	e:SetLabel(announce)
end
function c65050231.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local num=e:GetLabel()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,num,tp,LOCATION_DECK)
end
function c65050231.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local num=e:GetLabel()
	local og=Duel.GetMatchingGroup(c65050231.ccostfil,tp,LOCATION_DECK,0,nil)
	local g=og:SelectSubGroup(tp,aux.dncheck,false,num,num)
	if g:GetCount()==num then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
