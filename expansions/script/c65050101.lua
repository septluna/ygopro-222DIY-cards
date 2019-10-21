--霓色独珠的诱入者
function c65050101.initial_effect(c)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,65050101)
	e1:SetTarget(c65050101.tg)
	e1:SetOperation(c65050101.op)
	c:RegisterEffect(e1)
end
function c65050101.tgfil(c,tp)
	return c:IsSetCard(0x3da8) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
		and ((c:IsType(TYPE_XYZ) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and Duel.IsPlayerCanDraw(tp,c:GetOverlayCount()))
		or (c:IsType(TYPE_RITUAL) and c:IsLevelAbove(5) and Duel.IsExistingMatchingCard(c65050101.thfil,tp,LOCATION_DECK,0,1,nil))
		or (Duel.IsExistingMatchingCard(c65050101.thfil2,tp,LOCATION_DECK,0,1,nil) and not (c:IsType(TYPE_XYZ) or c:IsType(TYPE_RITUAL))))
end
function c65050101.thfil(c)
	return c:IsSetCard(0x3da8) and c:IsLevel(4) and c:IsAbleToHand()
end
function c65050101.thfil2(c)
	return c:IsSetCard(0x3da8) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c65050101.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c65050101.tgfil(chkc,tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c65050101.tgfil,tp,LOCATION_MZONE,0,1,nil,tp) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0 end
	local g=Duel.SelectTarget(tp,c65050101.tgfil,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc:IsType(TYPE_XYZ) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,tc:GetOverlayCount())
	else 
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c65050101.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if tc:IsType(TYPE_XYZ) and tc:GetOverlayCount()>0 then
			local rmg=tc:GetOverlayGroup()
			local drc=Duel.SendtoGrave(rmg,REASON_EFFECT)
			Duel.Draw(tp,drc,REASON_EFFECT)
		elseif tc:IsType(TYPE_RITUAL) and tc:IsLevelAbove(5) and Duel.IsExistingMatchingCard(c65050101.thfil,tp,LOCATION_DECK,0,1,nil) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetValue(-4)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local thg=Duel.SelectMatchingCard(tp,c65050101.thfil,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(thg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,thg)
		else
			local th2g=Duel.SelectMatchingCard(tp,c65050101.thfil2,tp,LOCATION_DECK,0,1,1,nil)
			if th2g then
				Duel.SendtoHand(th2g,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,th2g)
			end
		end
	end
end