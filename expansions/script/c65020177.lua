--幻世绘本-原初封页-
function c65020177.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c65020177.acon)
	e2:SetTarget(c65020177.atg)
	e2:SetValue(0)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e4)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(65020177,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c65020177.tg)
	e3:SetOperation(c65020177.op)
	c:RegisterEffect(e3)
end
function c65020177.acfil(c)
	return c:IsSetCard(0xcda8) and c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function c65020177.acon(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1 and Duel.IsExistingMatchingCard(c65020177.acfil,tp,LOCATION_MZONE,0,1,nil)
end
function c65020177.atg(e,c)
	local tp=e:GetHandlerPlayer()
	local cc=Duel.GetFieldGroup(tp,LOCATION_MZONE,0):GetFirst()
	local rk=cc:GetRank()
	return (c:GetLevel()<=rk and c:GetLevel()>0) or (c:GetRank()<=rk and c:GetRank()>0)
end



function c65020177.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanDraw(tp) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,1)
end
function c65020177.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if tc:IsRelateToEffect(e) then
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then 
			Duel.Overlay(tc,g)
			Duel.Draw(tp,1,REASON_EFFECT)	 
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DRAW)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end