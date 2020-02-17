local m=82224040
local cm=_G["c"..m]
cm.name="纳纳塔里"
function cm.initial_effect(c)
		--link summon  
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)  
	c:EnableReviveLimit() 
	--indes  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)  
	e1:SetCondition(cm.indcon)  
	e1:SetValue(1)  
	c:RegisterEffect(e1) 
	--recover  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetCategory(CATEGORY_RECOVER) 
	e3:SetCost(cm.cost)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e3:SetProperty(EFFECT_FLAG_DELAY)  
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCondition(cm.con)  
	e3:SetTarget(cm.rectg)  
	e3:SetOperation(cm.recop)  
	c:RegisterEffect(e3) 
	--damage
	local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetTarget(cm.damtg)
	e4:SetOperation(cm.damop)
	c:RegisterEffect(e4)
	--atk
	local e5=e3:Clone()
	e5:SetDescription(aux.Stringid(m,2))
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetTarget(cm.atktg)
	e5:SetOperation(cm.atkop)
	c:RegisterEffect(e5)
end
function cm.lcheck(g,lc)  
	return g:IsExists(Card.IsLinkRace,1,nil,RACE_PLANT)  
end
function cm.indcon(e)  
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_LINK)~=0  
end 
function cm.cfilter(c,lg)  
	return c:IsControler(tp) and lg:IsContains(c) and c:IsReleasable() 
end  
function cm.con(e,tp,eg,ep,ev,re,r,rp)  
	local lg=e:GetHandler():GetLinkedGroup()  
	return eg:GetCount()==1 and eg:IsExists(cm.cfilter,1,nil,lg)  
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk) 
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return eg:IsExists(cm.cfilter,1,nil,lg) end
	Duel.Release(eg:GetFirst(),REASON_COST)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetTargetPlayer(tp)  
	Duel.SetTargetParam(500)  
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)  
end  
function cm.recop(e,tp,eg,ep,ev,re,r,rp)  
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)  
	Duel.Recover(p,d,REASON_EFFECT)  
end  
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetTargetPlayer(1-tp)  
	Duel.SetTargetParam(500)  
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)  
end  
function cm.damop(e,tp,eg,ep,ev,re,r,rp)  
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)  
	Duel.Damage(p,d,REASON_EFFECT)  
end  
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) and c:IsFaceup() then  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)  
		e1:SetCode(EFFECT_UPDATE_ATTACK)  
		e1:SetValue(500)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)  
		c:RegisterEffect(e1)  
	end  
end  