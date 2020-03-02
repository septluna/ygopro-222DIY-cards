--心愿所示 祈愿之星
function c33330090.initial_effect(c)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c33330090.regop)
	c:RegisterEffect(e2)
	local e1=e2:Clone()
	e1:SetCode(EVENT_FLIP)
	c:RegisterEffect(e1)
end
function c33330090.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(33330090,1))
		e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCountLimit(1)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTarget(c33330090.thtg)
		e1:SetOperation(c33330090.thop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
end
function c33330090.filter(c,tp)
	return c:IsType(TYPE_SPELL) and (c:IsAbleToHand() or (c:IsSSetable() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0))
end
function c33330090.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return true
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c33330090.thop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetDecktopGroup(p,5)
	if g:GetCount()==5 then
		Duel.ConfirmDecktop(p,5)
		if g:IsExists(c33330090.filter,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(33330090,0)) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(p,c33330090.filter,1,1,nil,tp)
		local sc=sg:GetFirst()
		local b1=sc:IsAbleToHand()
		local b2=sc:IsSSetable() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		local op=99
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(33330090,1),aux.Stringid(33330090,2))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(33330090,1))
		elseif b2 then
			op=Duel.SelectOption(tp,aux.Stringid(33330090,2))+1
		end  
		if op==0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-p,sg)
			Duel.ShuffleHand(p)
		elseif op==1 then
			Duel.SSet(p,sg)
		end
		Duel.ShuffleDeck(p)
		end
		Duel.BreakEffect()
		Duel.ChangePosition(e:GetHandler(),POS_FACEDOWN_DEFENSE)
	end
end