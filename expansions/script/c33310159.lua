--临魔晶织
function c33310159.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.TRUE,5,2)
	--linmo
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetTarget(c33310159.ltg)
	e1:SetOperation(c33310159.lop)
	c:RegisterEffect(e1)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,33310159)
	e2:SetCost(c33310159.efcost)
	e2:SetTarget(c33310159.eftg)
	e2:SetOperation(c33310159.efop)
	c:RegisterEffect(e2)
	c33310159[c]=e1
end

function c33310159.ltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,0x55b) end
end
function c33310159.lop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
	local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,0x55b)
	if g then
		Duel.HintSelection(g)
		Duel.Overlay(c,g)
	end
	end
end

function c33310159.efcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c33310159.mfilter(c,e,tp,eg,ep,ev,re,r,rp)
	local te=c[c]
		if not te or c:GetOriginalCode()<33310152 or c:GetOriginalCode()>33310161 then return false end
		local tg=te:GetTarget()
		if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0,nil,c) then return false end
	return true
end
function c33310159.sffilter1(c)
	return c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function c33310159.sffilter2(c)
	return c:IsLocation(LOCATION_SZONE) and c:GetSequence()<5
end
function c33310159.remfilter(c,tp)
	return c:IsControler(1-tp) and (c:IsLocation(LOCATION_SZONE) or (c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5))
end
function c33310159.sfilter(c)
	local tp=c:GetControler()
	local g=c:GetColumnGroup(1,1)
	if g then
		g=g:Filter(Card.IsControler,nil,tp)
		if g then
			if c:IsLocation(LOCATION_MZONE) then
				g=g:Filter(c33310159.sffilter1,nil)
			elseif c:IsLocation(LOCATION_SZONE) then
				g=g:Filter(c33310159.sffilter2,nil)
			end
			g:Merge(c:GetColumnGroup())
			if g then
				g:Remove(c33310159.remfilter,nil,tp)
			end
		end
	end
	return g:GetCount()>0
end
function c33310159.filter(c,e,tp,eg,ep,ev,re,r,rp)
	return c:IsSetCard(0x55b) and ((c:IsType(TYPE_MONSTER) and c33310159.mfilter(c,e,tp,eg,ep,ev,re,r,rp)) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and Duel.IsExistingTarget(c33310159.sfilter,tp,0,LOCATION_ONFIELD,1,nil)))
end
function c33310159.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local og=e:GetHandler():GetOverlayGroup()
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return og:IsExists(c33310159.filter,tp,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
	local tc=og:FilterSelect(tp,c33310159.filter,1,1,nil,e,tp,eg,ep,ev,re,r,rp):GetFirst()
	Duel.SendtoGrave(tc,REASON_COST)
	local op=99
	if tc:IsType(TYPE_MONSTER) then
		local te=tc[tc]   
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
		local tg=te:GetTarget()
		if tg then
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		end
		te:SetLabelObject(e:GetLabelObject())
		e:SetLabelObject(te)
		op=0
	elseif tc:IsType(TYPE_SPELL+TYPE_TRAP) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c33310159.sfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
		e:SetCategory(CATEGORY_TOGRAVE)
		local gc=g:GetFirst()
		local gtp=gc:GetControler()
	local gg=gc:GetColumnGroup(1,1)
	if gg then
		gg=gg:Filter(Card.IsControler,nil,gtp)
		if gg then
			if gc:IsLocation(LOCATION_MZONE) then
				gg=gg:Filter(c33310159.sffilter1,nil)
			elseif c:IsLocation(LOCATION_SZONE) then
				gg=gg:Filter(c33310159.sffilter2,nil)
			end
			gg:Merge(gc:GetColumnGroup())
			if gg then
				gg:Remove(c33310159.remfilter,nil,gtp)
			end
		end
	end
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,gg,gg:GetCount(),0,0)
		op=1
	end
	e:SetLabel(op)
end
function c33310159.efop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
		local te=e:GetLabelObject()
		if not te then return end
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	elseif op==1 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
		local ttp=tc:GetControler()
		local g=tc:GetColumnGroup(1,1)
		if g then
			g=g:Filter(Card.IsControler,nil,ttp)
			if g then
				if tc:IsLocation(LOCATION_MZONE) then
					g=g:Filter(c33310159.sffilter1,nil)
				elseif tc:IsLocation(LOCATION_SZONE) then
					g=g:Filter(c33310159.sffilter2,nil)
				end
				g:Merge(tc:GetColumnGroup())
				if g then
					g:Remove(c33310159.remfilter,nil,ttp)
				end
			end
		end   
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
		end
	end
end