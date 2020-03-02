--原罪机械 Gluttony 阿库娅
function c12004006.initial_effect(c)	
 --pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12004006,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,12004006)
	e1:SetTarget(c12004006.sptg)
	e1:SetOperation(c12004006.spop)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e4:SetCondition(c12004006.tdcon2)
	c:RegisterEffect(e4)  
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12004006,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,12004006+100)
	e2:SetTarget(c12004006.thtg)
	e2:SetOperation(c12004006.thop)
	c:RegisterEffect(e2)  
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end
function c12004006.tdcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,12008029)>0
end
function c12004006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and (Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)+2)<Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE,nil) and  Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,3,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12004006.spfilter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and  c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12004006.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)<=0 then return end
	Duel.BreakEffect()
	if Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,3,nil) then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	   local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,3,3,nil)
	   local dd=Duel.Destroy(g,REASON_EFFECT)
	   if dd<3 then 
		   if dd<3 then
		   Duel.Draw(tp,1,REASON_EFFECT)
		   end
		   if dd<2 and Duel.IsExistingMatchingCard(c12004006.spfilter1,tp,LOCATION_HAND,0,1,nil,e,tp) and  Duel.SelectYesNo(tp,aux.Stringid(12004006,2)) then
			  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			  local g=Duel.SelectMatchingCard(tp,c12004006.spfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			  if g:GetCount()>0 then
				  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			  end
		  end
		  if dd<1 then
			  local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
			  if g:GetCount()>0 then
				 local tg=g:GetMaxGroup(Card.GetAttack)
				 if tg:GetCount()>1 then
					 Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
					 local sg=tg:Select(1-tp,1,1,nil)
					 Duel.HintSelection(sg)
					 Duel.Remove(sg,POS_FACEUP,REASON_RULE)
				 end
			  end
		 end
	   end
	end
end

function c12004006.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)  and Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_DECK,0,1,nil,RACE_SEASERPENT) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c12004006.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_SET_BASE_ATTACK)
		e3:SetValue(tc:GetBaseAttack()/2)
		tc:RegisterEffect(e3)
	end
	Duel.BreakEffect()
	if Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_DECK,0,1,nil,RACE_SEASERPENT) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(12004006,4))
		local g=Duel.SelectMatchingCard(tp,Card.IsRace,tp,LOCATION_DECK,0,1,1,nil,RACE_SEASERPENT)
		local tc=g:GetFirst()
		if tc then
		   Duel.ShuffleDeck(tp)
		   Duel.MoveSequence(tc,0)
		   Duel.ConfirmDecktop(tp,1)
		end
	end
end