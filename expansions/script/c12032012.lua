--阿古莉不高兴
local m=12032012
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.tgtg)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct==0 then return end
	if ct>3 then ct=3 end
	local t={}
	for i=1,ct do t[i]=i end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.ConfirmDecktop(tp,ac)
	local g=Duel.GetDecktopGroup(tp,ac)
	local sg=g:Filter(Card.IsType,nil,TYPE_MONSTER)
	Duel.BreakEffect()
	local cc=0
	if #sg>0 then 
		 local tc=sg:GetFirst()
		 while tc do
--			 if tc:IsRelateToEffect(e) then 
				  local cc1=tc:GetOriginalLevel() 
				  cc=cc+cc1
--				  Debug.Message(cc)
--			 end
			 tc=sg:GetNext()
		 end
	end
--	Debug.Message(cc)
	if Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,sg,cc) then
		 Duel.BreakEffect()
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		 local tg=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,sg,cc)
		 Duel.DisableShuffleCheck()
		 if Duel.SendtoGrave(tg,nil,REASON_EFFECT)>0  then
			  Duel.SendtoGrave(g,nil,REASON_EFFECT)
			  Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		 end
	end
end
function cm.filter(c,level)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xfa1) and c:GetLevel()==level and c:IsAbleToGrave()
end
function cm.tgfilter(c)
	return c:IsSetCard(0xfa1) and c:IsType(TYPE_MONSTER)  and c:IsAbleToGrave()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,m)==0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
end