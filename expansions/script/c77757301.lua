local m=77757301
local cm=_G["c"..m]
Duel.LoadScript("c37564765.lua")
function cm.initial_effect(c)
	local e1=EFfect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	local function gf(g,lc,tp)
		return Duel.GetLocationCountFromEx(tp,tp,g,lc)>0
	end
	local function spf(c,mg,e,tp)
		return c:IsType(TYPE_LINK) and c:IsLinkBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (not mg or mg:CheckSubGroup(gf,2,2,c,tp))
	end
	local function mf(c)
		return c:GetSmmmonLocation()==LOCATION_EXTRA
	end
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return false end
		local mg=Duel.GetMatchingGroup(mf,tp,LOCATION_MZONE,LOCATION_MZONE,0,nil)
		if chk==0 then
			return Duel.IsExistingMatchingCard(spf,tp,LOCATION_EXTRA,0,1,nil,mg,e,tp)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=mg:SelectSubGroup(tp,gf,false,2,2,TYPE_LINK,tp)
		Duel.SetTargetCard(g)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g:FilterCount(Card.IsRelateToEffect,nil,e)==#g and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
			local sg=Duel.SelectMatchingCard(tp,spf,tp,LOCATION_EXTRA,0,1,1,nil,g,e,tp)
			if #sg>0 then
				local tc=sg:GetFirst()
				if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
					local tg=tc:GetColumnGroup()
					tg:RemoveCard(tc)
					if #tg>0 and Duel.SelectYesNo(tp,m*16) then
						Duel.BreakEffect()
						Duel.SendtoGrave(tg,REASON_EFFECT)
					end
				end
			end
		end
	end)
	c:RegisterEFfect(e1)
end
