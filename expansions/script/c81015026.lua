--一头六臂·北上丽花
require("expansions/script/c81000000")
function c81015026.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c81015026.matfilter,2,2)
	c:EnableReviveLimit()
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81015026,1))
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,81015026)
	e1:SetCondition(Tenka.ReikaCon)
	e1:SetTarget(c81015026.target)
	e1:SetOperation(c81015026.operation)
	c:RegisterEffect(e1)
	--lock
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81015026,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c81015026.cbtg)
	e2:SetOperation(c81015026.cbop)
	c:RegisterEffect(e2)
end
function c81015026.matfilter(c)
	return c:IsLinkSetCard(0x81a) and not c:IsLinkType(TYPE_LINK)
end
function c81015026.cfilter(c)
	return c:IsFacedown() and c:GetSequence()<5
end
function c81015026.cbtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_SZONE) and c81015026.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81015026.cfilter,tp,0,LOCATION_SZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(81015026,2))
	Duel.SelectTarget(tp,c81015026.cfilter,tp,0,LOCATION_SZONE,1,1,e:GetHandler())
end
function c81015026.cbop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFacedown() and tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
		e:SetLabelObject(tc)
		c:ResetFlagEffect(81015026)
		tc:ResetFlagEffect(81015026)
		local fid=c:GetFieldID()
		c:RegisterFlagEffect(81015026,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		tc:RegisterFlagEffect(81015026,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DRAW)
		e1:SetLabelObject(tc)
		e1:SetCondition(c81015026.rcon)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		--End of e1
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DRAW)
		e2:SetLabel(fid)
		e2:SetLabelObject(e1)
		e2:SetCondition(c81015026.rstcon)
		e2:SetOperation(c81015026.rstop)
		Duel.RegisterEffect(e2,tp)
		--return to hand
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetCountLimit(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DRAW)
		e3:SetLabel(fid)
		e3:SetLabelObject(tc)
		e3:SetCondition(c81015026.agcon)
		e3:SetOperation(c81015026.agop)
		Duel.RegisterEffect(e3,1-tp)
		--activate check
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetCode(EVENT_CHAINING)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DRAW)
		e4:SetLabel(fid)
		e4:SetLabelObject(e3)
		e4:SetOperation(c81015026.rstop2)
		Duel.RegisterEffect(e4,tp)
	end
end
function c81015026.rcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler()) and e:GetHandler():GetFlagEffect(81015026)~=0
end
function c81015026.rstcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject():GetLabelObject()
	if tc:GetFlagEffectLabel(81015026)==e:GetLabel()
		and c:GetFlagEffectLabel(81015026)==e:GetLabel() then
		return not c:IsDisabled()
	else
		e:Reset()
		return false
	end
end
function c81015026.rstop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	te:Reset()
	Duel.HintSelection(Group.FromCards(e:GetHandler()))
end
function c81015026.agcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(81015026)==e:GetLabel()
		and c:GetFlagEffectLabel(81015026)==e:GetLabel() then
		return not c:IsDisabled()
	else
		e:Reset()
		return false
	end
end
function c81015026.agop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end
function c81015026.rstop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:GetFlagEffectLabel(81015026)~=e:GetLabel() then return end
	local c=e:GetHandler()
	c:CancelCardTarget(tc)
	local te=e:GetLabelObject()
	tc:ResetFlagEffect(81015026)
	if te then te:Reset() end
end
function c81015026.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,5)
		and Duel.GetDecktopGroup(tp,5):FilterCount(Card.IsAbleToHand,nil)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c81015026.filter(c)
	return c:IsSetCard(0x81a) and c:IsAbleToHand()
end
function c81015026.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,5) then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	if g:GetCount()>0 then
		if g:IsExists(c81015026.filter,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,c81015026.filter,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			g:Sub(sg)
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
		else
			Duel.ShuffleDeck(tp)
		end
	end
end
