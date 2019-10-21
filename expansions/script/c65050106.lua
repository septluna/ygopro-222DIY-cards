--霓色独珠 同道挚友
function c65050106.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,65050107)
	e1:SetCost(c65050106.cost)
	e1:SetTarget(c65050106.thtg)
	e1:SetOperation(c65050106.thop)
	c:RegisterEffect(e1)
	--xyz
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCountLimit(1,65050106)
	e3:SetCondition(c65050106.con)
	e3:SetTarget(c65050106.tg)
	e3:SetOperation(c65050106.op)
	c:RegisterEffect(e3)
end
function c65050106.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c65050106.thtgfil(c,e,tp)
	local num=0
	if c:IsType(TYPE_XYZ) then num=c:GetOverlayCount() end
	if c==e:GetHandler() then num=num-1 end
	return num>0 and c:IsSetCard(0x3da8) and c:IsFaceup() and c:CheckRemoveOverlayCard(tp,num,REASON_EFFECT) and Duel.IsExistingMatchingCard(c65050106.thfil,tp,LOCATION_DECK,0,1,nil)
end
function c65050106.thtgfil2(c,e,tp)
	local num=0
	if c:IsType(TYPE_XYZ) then num=c:GetOverlayCount() end
	return num>0 and c:IsSetCard(0x3da8) and c:IsFaceup() and c:CheckRemoveOverlayCard(tp,num,REASON_EFFECT) and Duel.IsExistingMatchingCard(c65050106.thfil,tp,LOCATION_DECK,0,1,nil)
end
function c65050106.thfil(c)
	return c:IsAbleToHand() and c:IsSetCard(0x3da8) and c:IsType(TYPE_SPELL)
end
function c65050106.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c65050106.thtgfil(chkc,e,tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c65050106.thtgfil,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	local g=Duel.SelectTarget(tp,c65050106.thtgfil2,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65050106.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local g=tc:GetOverlayGroup()
		local num=Duel.SendtoGrave(g,REASON_EFFECT)
		if num>0 and Duel.IsExistingMatchingCard(c65050106.thfil,tp,LOCATION_DECK,0,1,nil) then
			local tg=Duel.GetMatchingGroup(c65050106.thfil,tp,LOCATION_DECK,0,nil)
			local thg=tg:SelectSubGroup(tp,aux.dncheck,false,1,num)
			Duel.SendtoHand(thg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,thg)
		end
	end
end


function c65050106.con(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c65050106.filter1(c)
   return c:IsSetCard(0x3da8) and c:IsType(TYPE_MONSTER) and c:IsLevel(4)
end
function c65050106.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050106.filter1,tp,LOCATION_DECK,0,1,nil) end
end
function c65050106.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local g=Duel.SelectMatchingCard(tp,c65050106.filter1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Overlay(c,g) 
		end
	end
end