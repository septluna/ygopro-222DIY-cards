--索菲的工作室-普拉芙妲
function c4212344.initial_effect(c)
	--send replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c4212344.repcon)
	e1:SetOperation(c4212344.repop)
	c:RegisterEffect(e1)
	--SPECIAL_SUMMON
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4212344,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetOperation(c4212344.op2)
	c:RegisterEffect(e2)
	--SPECIAL_SUMMON
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4212344,3))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,4212344)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c4212344.tg3)
	e3:SetOperation(c4212344.op3)
	c:RegisterEffect(e3)
end
function c4212344.mfilter(c) 
	return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function c4212344.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local t=Duel.GetAttackTarget()
	if chk==0 then return (t==c) or (a==c) end
end
function c4212344.operation(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c4212344.indct)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_CHAIN)
	a:RegisterEffect(e1,tp)
	if d then
		d:RegisterEffect(e1,tp) 
		Duel.CalculateDamage(a,d)
	else
		Duel.ChainAttack()
	end
end
function c4212344.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE)~=0 then
		return 1
	else return 0 end
end
function c4212344.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return 0 end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(4212344,0)) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			local c=e:GetHandler()
			if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,4212344,0xa25,0x21,1650,1200,3,RACE_SPELLCASTER,ATTRIBUTE_DARK) then
				c:AddMonsterAttribute(TYPE_EFFECT,ATTRIBUTE_DARK,RACE_SPELLCASTER,3,1650,1200)
				Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4212344,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c4212344.target)
	e1:SetOperation(c4212344.operation)
	c:RegisterEffect(e1)
				Duel.SpecialSummonComplete()
				if Duel.GetMatchingGroupCount(c4212344.mfilter,tp,LOCATION_SZONE,0,nil)>=3 and Duel.IsExistingMatchingCard(function(c) return c:IsAbleToDeck() end,tp,LOCATION_REMOVED,0,1,nil) then
					if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(4212344,2)) then
						local tc = Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,1,1,nil)
						if tc:GetCount()>0 then
							Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
						end  
					end
				end
			end
		end
	end
end
function c4212344.repcon(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function c4212344.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
end
function c4212344.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.GetMatchingGroupCount(function(c,e) local seq=c:GetSequence() return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and seq<5 and math.abs(e:GetHandler():GetSequence()-seq)<=1 end,tp,LOCATION_SZONE,0,nil,e)>=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g = Duel.SelectTarget(tp,function(c,e) local seq=c:GetSequence() return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and seq<5 and math.abs(e:GetHandler():GetSequence()-seq)<=1 end,tp,LOCATION_SZONE,0,2,2,e:GetHandler(),e)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c4212344.copyfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0xa25) and c:CheckActivateEffect(false,true,false)~=nil
end
function c4212344.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	local sg = Group.CreateGroup()
	if tg:GetCount()>0 then
		sg:Merge(tg)
		tg:ForEach(function(c)	 
			sg:Merge(c:GetColumnGroup():Filter(function(c) return c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP) end,nil))
		end)		
	end
	if sg:GetCount()>=2 then 
		Duel.Destroy(sg:Select(tp,2,2,nil),REASON_EFFECT)
		local te,ceg,cep,cev,cre,cr,crp
		local fchain=c4212344.copyfilter(e:GetHandler())
		if fchain then
			te,ceg,cep,cev,cre,cr,crp=e:GetHandler():CheckActivateEffect(false,true,true)
		else
			te=e:GetHandler():GetActivateEffect()
		end

		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end