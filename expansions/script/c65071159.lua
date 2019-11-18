--光之种
function c65071159.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE+CATEGORY_SEARCH)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c65071159.target)
	e1:SetOperation(c65071159.activate)
	c:RegisterEffect(e1)
end
function c65071159.tgfil(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsAbleToHand() or c:IsAbleToGrave() or (c:IsSSetable() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0))
end
function c65071159.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1da0)>=30 and Duel.IsExistingMatchingCard(c65071159.tgfil,tp,LOCATION_DECK,0,1,nil,tp) end
	 if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end

function c65071159.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.RemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1da0,30,REASON_EFFECT) then
	local g=Duel.SelectMatchingCard(tp,c65071159.tgfil,tp,LOCATION_DECK,0,1,99,nil,tp)
	if g then
		local tc=g:GetFirst()
		local b1,b2,b3=false
		local m=99
		while tc do
			b1=tc:IsAbleToHand() 
			b2=tc:IsAbleToGrave() 
			b3=tc:IsSSetable() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
			Duel.ConfirmCards(tp,tc)
			if b1 and b2 and b3 then
				m=Duel.SelectOption(tp,aux.Stringid(65071159,0),aux.Stringid(65071159,1),aux.Stringid(65071159,2))
			elseif b1 and b2 then
				m=Duel.SelectOption(tp,aux.Stringid(65071159,0),aux.Stringid(65071159,1))
			elseif b2 and b3 then
				m=Duel.SelectOption(tp,aux.Stringid(65071159,1),aux.Stringid(65071159,2))+1
			elseif b1 and b3 then
				m=Duel.SelectOption(tp,aux.Stringid(65071159,0),aux.Stringid(65071159,2))
				if m==1 then m=2 end
			elseif b1 then
				m=0
			elseif b2 then
				m=1
			elseif b3 then
				m=2
			end
			if m==0 then
				Duel.SendtoHand(tc,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			elseif m==1 then
				Duel.SendtoGrave(tc,REASON_EFFECT)
			elseif m==2 then
				Duel.SSet(tp,tc)
				Duel.ConfirmCards(1-tp,tc)
				if tc:IsType(TYPE_TRAP) then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
					e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				end
				if tc:IsType(TYPE_QUICKPLAY) then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
					e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				end
			end
			tc=g:GetNext()
		end
	end
	end
end