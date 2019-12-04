local m=77765004
local cm=_G["c"..m]
Duel.LoadScript("c77765000.lua")
--cm.Senya_name_with_difficulty=1
function cm.initial_effect(c)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--[[for _,code in ipairs({EFFECT_CANNOT_BE_XYZ_MATERIAL,EFFECT_CANNOT_BE_SYNCHRO_MATERIAL,EFFECT_CANNOT_BE_FUSION_MATERIAL,EFFECT_CANNOT_BE_LINK_MATERIAL,m}) do
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(code)
		e2:SetProperty(EFFECT_FLAG_IGNORE_RANGE)
		e2:SetTargetRange(0xff,0xff)
		e2:SetTarget(function(e,c)
			return c:GetSequence()>4 or not c:IsLocation(LOCATION_MZONE)
		end)
		e2:SetRange(LOCATION_SZONE)
		e2:SetValue(function(e,c)
			return c and c:IsControler(1-e:GetHandlerPlayer())
		end)
		c:RegisterEffect(e2)
	end]]
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	--e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
<<<<<<< HEAD
=======
    e1:SetRange(LOCATION_SZONE)
>>>>>>> 5a43ca2cc6bdcc10fc8c54e5e9ffbbeaafb5a6f1
	e1:SetCountLimit(1)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
		Duel.SetTargetParam(Duel.SelectOption(tp,1056,1063,1073,1076))
	end)
<<<<<<< HEAD
	e1:SetOperation(function cm.operation(e,tp,eg,ep,ev,re,r,rp)
=======
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
>>>>>>> 5a43ca2cc6bdcc10fc8c54e5e9ffbbeaafb5a6f1
		local c=e:GetHandler()
		local opt=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
		local ct=nil
		if opt==0 then ct=TYPE_FUSION end
		if opt==1 then ct=TYPE_SYNCHRO end
		if opt==2 then ct=TYPE_XYZ end
		if opt==3 then ct=TYPE_LINK end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetLabel(ct)
		e1:SetTargetRange(0,1)
		e1:SetTarget(cm.sumlimit)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetTargetRange(0,LOCATION_MZONE)
		e2:SetTarget(cm.distg)
		e2:SetLabel(ct)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e2,tp)
	end)
	c:RegisterEffect(e1)
	local function KaguyaFilter(c,e,tp,cc)
		local p=c:GetControler()
		local tc=Senya.GetDFCBackSideCard(cc)
		return c:IsFaceup() and c:IsCode(77765001) and Duel.GetLocationCount(p,LOCATION_SZONE,tp)>0 and tc:CheckEquipTarget(c)
	end
	local function DifficultyFilter(c,e,tp)
		return Kaguya.IsDifficulty(c) and Senya.IsDFCTransformable(c) and Duel.IsExistingMatchingCard(KaguyaFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp,c)
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(0x14000+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
	end)
	e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local dg=Duel.SelectMatchingCard(tp,DifficultyFilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local cc=dg:GetFirst()
		if cc then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local g=Duel.SelectMatchingCard(tp,KaguyaFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp,cc)
			local tc=g:GetFirst()
			local p=tc:GetControler()
			Duel.MoveToField(cc,tp,p,LOCATION_SZONE,POS_FACEUP,false)
			Senya.TransformDFCCard(cc)
			Duel.Equip(p,cc,tc)
			Duel.RaiseEvent(cc,EVENT_CUSTOM+77765000,re,r,rp,ep,ev)
		end
	end)
	c:RegisterEffect(e3)
end
function cm.filter(c)
	return c:IsCode(m-1) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_GRAVE)
	--destroy
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(cm.descon)
	e1:SetOperation(cm.desop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,3)
	cm[e:GetHandler()]=e1
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==3 then
		Duel.Destroy(c,REASON_RULE)
		c:ResetFlagEffect(1082946)
	end
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsType(e:GetLabel())
end
function cm.distg(e,c)
	return c:IsType(e:GetLabel())
<<<<<<< HEAD
end
=======
end
>>>>>>> 5a43ca2cc6bdcc10fc8c54e5e9ffbbeaafb5a6f1
