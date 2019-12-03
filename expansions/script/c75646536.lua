--同构时空 黛尔塔
function c75646536.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c75646536.lcheck)
	c:EnableReviveLimit()
	--Equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75646536,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(2,75646536)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetTarget(c75646536.tg)
	e1:SetOperation(c75646536.op)
	c:RegisterEffect(e1)
end
function c75646536.lcheck(g,lc)
	return g:IsExists(Card.IsLevel,1,nil,4)
end
function c75646536.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsLocation(LOCATION_GRAVE) and c:IsCanBeEffectTarget(e) and not c:IsForbidden()
end
function c75646536.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c75646536.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and eg:IsExists(c75646536.filter,1,nil,e,tp) end
	local g=eg:Filter(c75646536.filter,nil,e,tp)
	local tc=nil
	if g:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		tc=g:Select(tp,1,1,nil):GetFirst()
	else
		tc=g:GetFirst()
	end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tc,1,0,0)
end
function c75646536.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
		local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
		if not Duel.Equip(tp,tc,c,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c75646536.eqlimit)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(atk)
		tc:RegisterEffect(e2)
	end
end
function c75646536.eqlimit(e,c)
	return e:GetOwner()==c
end