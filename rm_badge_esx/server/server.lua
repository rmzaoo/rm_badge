ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand("badge", function(source, args, rawCommand)
	local _source = source
	TriggerEvent('rm_badge:server:useitem', _source)
end)

ESX.RegisterUsableItem("badge", function(source)
	local _source = source
	TriggerEvent('rm_badge:server:useitem', _source)
end)

RegisterServerEvent('rm_badge:server:useitem')
AddEventHandler('rm_badge:server:useitem', function(src)
	local xPlayer = ESX.GetPlayerFromId(src)
	local badge = xPlayer.getInventoryItem('badge')
	if xPlayer.job.name == 'police' and badge.count >= 1  then
		if Config.Core_MDW then
			MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {['@identifier'] = xPlayer.identifier}, function(result)
				if result[1] then

					if result[1].mdw_image == "" then
						--img = "https://media1.tenor.com/images/3b2fccf0fd21aba020c6702ce80bb873/tenor.gif?itemid=22162817"
						return TriggerClientEvent('swt_notifications:client:SendAlert', src, { type = 'inform', text = "You don't have a picture on your mdt / mdw profile" })
					else
						img = result[1].mdw_image
					end

					local name = result[1].firstname ..' '..result[1].lastname
					local grade = xPlayer.job.grade_label

					TriggerClientEvent('rm_badge:client:showbadge', -1, src, img, grade, name)
				end
			end)
		elseif Config.PhynixMDT then
			if Config.EssentialsMode then
				MySQL.Async.fetchAll('SELECT * FROM user_mdt INNER JOIN characters ON user_mdt.char_id=characters.id where characters.identifier = @identifier', {['@identifier'] = xPlayer.identifier}, function(result)
					if result[1] then
						if result[1].mugshot_url == nil then
							--img = "https://media1.tenor.com/images/3b2fccf0fd21aba020c6702ce80bb873/tenor.gif?itemid=22162817"
							return TriggerClientEvent('swt_notifications:client:SendAlert', src, { type = 'inform', text = "You don't have a picture on your mdt / mdw profile" })
						else
							img = result[1].mugshot_url
						end
									
						local grade = xPlayer.job.grade_label
						local name = result[1].firstname ..' '..result[1].lastname
						TriggerClientEvent('rm_badge:client:showbadge', -1, src, img, grade, name)
					else
						TriggerClientEvent('swt_notifications:client:SendAlert', source, { type = 'inform', text = "You don't have a picture on your mdt/mdw profile" })
					end
				end)
			else
				MySQL.Async.fetchAll('SELECT * FROM user_mdt INNER JOIN users ON user_mdt.char_id=users.identifier where user_mdt.char_id = @identifier', {['@identifier'] = xPlayer.identifier}, function(result)
					if result[1] ~= nil then
						if result[1].mugshot_url == "" then
							--img = "https://media1.tenor.com/images/3b2fccf0fd21aba020c6702ce80bb873/tenor.gif?itemid=22162817"
							return TriggerClientEvent('swt_notifications:client:SendAlert', src, { type = 'inform', text = "You don't have a picture on your mdt / mdw profile" })
						else
							img = result[1].mugshot_url
						end


						local name = result[1].firstname ..' '..result[1].lastname
						local grade = xPlayer.job.grade_label
						TriggerClientEvent('rm_badge:client:showbadge', -1, src, img, grade, name)
					else
						TriggerClientEvent('swt_notifications:client:SendAlert', src, { type = 'inform', text = "You don't have a picture on your mdt / mdw profile" })
					end
				end)
			end
		elseif Config.StandaloneVersion then
			MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {['@identifier'] = xPlayer.identifier}, function(result)
				if result[1] then
					if result[1].badge_image == "" then
						--img = "https://media1.tenor.com/images/3b2fccf0fd21aba020c6702ce80bb873/tenor.gif?itemid=22162817"
						return TriggerClientEvent('swt_notifications:client:SendAlert', src, { type = 'inform', text = "You don't have a picture on your mdt / mdw profile" })
					else
						img = result[1].badge_image
					end

					local name = result[1].firstname ..' '..result[1].lastname
					local grade = xPlayer.job.grade_label

					TriggerClientEvent('rm_badge:client:showbadge', -1, src, img, grade, name)
				end
			end)
		end
	end
end)

RegisterServerEvent('rm_badge:server:savephoto')
AddEventHandler('rm_badge:server:savephoto', function(link)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local badge = xPlayer.getInventoryItem('badge')
	if xPlayer.job.name == 'police' and badge.count >= 1 then
		MySQL.Async.execute("UPDATE users SET `badge_image` = @badge_image WHERE `identifier` = @identifier", { ['@identifier'] = xPlayer.identifier, ['@badge_image'] = link })
	end
end)