
//SPELL BOOK PROCS

/obj/item/weapon/spellbook/attack_self(mob/user as mob)
	user.machine = src
	var/dat
	if (src.temp)
		dat = "[src.temp]<BR><BR><A href='byond://?src=\ref[src];temp=1'>Clear</A>"
	else
		dat = "<B>The Book of Spells:</B><BR>"
		dat += "Spells left to memorize: [src.uses]<BR>"
		dat += "<HR>"
		dat += "<B>Memorize which spell:</B><BR>"
		dat += "<I>The number after the spell name is the cooldown time.</I><BR>"
		dat += "<A href='byond://?src=\ref[src];spell_choice=1'>Magic Missile</A> (10)<BR>"
		dat += "<A href='byond://?src=\ref[src];spell_choice=2'>Fireball</A> (10)<BR>"
		dat += "<A href='byond://?src=\ref[src];spell_choice=3'>Disintegrate</A> (60)<BR>"
		dat += "<A href='byond://?src=\ref[src];spell_choice=4'>Disable Technology</A> (60)<BR>"
		dat += "<A href='byond://?src=\ref[src];spell_choice=5'>Smoke</A> (10)<BR>"
		dat += "<A href='byond://?src=\ref[src];spell_choice=6'>Blind</A> (30)<BR>"
		dat += "<A href='byond://?src=\ref[src];spell_choice=7'>Mind Transfer</A> (60)<BR>"
		dat += "<A href='byond://?src=\ref[src];spell_choice=8'>Forcewall</A> (10)<BR>"
		dat += "<A href='byond://?src=\ref[src];spell_choice=9'>Blink</A> (2)<BR>"
		dat += "<A href='byond://?src=\ref[src];spell_choice=10'>Teleport</A> (60)<BR>"
		dat += "<A href='byond://?src=\ref[src];spell_choice=11'>Mutate</A> (60)<BR>"
		dat += "<A href='byond://?src=\ref[src];spell_choice=12'>Ethereal Jaunt</A> (60)<BR>"
		dat += "<A href='byond://?src=\ref[src];spell_choice=13'>Knock</A> (10)<BR>"
		dat += "<HR>"
		dat += "<A href='byond://?src=\ref[src];spell_choice=14'>Re-memorize Spells</A><BR>"
	user << browse(dat, "window=radio")
	onclose(user, "radio")
	return


/obj/item/weapon/spellbook/Topic(href, href_list)
	..()
	if (usr.stat || usr.restrained())
		return
	var/mob/living/carbon/human/H = usr
	if (!( istype(H, /mob/living/carbon/human)))
		return 1
	if ((usr.contents.Find(src) || (in_range(src,usr) && istype(src.loc, /turf))))
		usr.machine = src
		if(href_list["spell_choice"])
			if(src.uses >= 1 && href_list["spell_choice"] != 14)
				src.uses--
				if(spell_type == "verb")
					switch(href_list["spell_choice"])
						if ("1")
							usr.verbs += /client/proc/magicmissile
							usr.mind.special_verbs += /client/proc/magicmissile
							src.temp = "This spell fires several, slow moving, magic projectiles at nearby targets. If they hit a target, it is paralyzed and takes minor damage."
						if ("2")
							usr.verbs += /client/proc/fireball
							usr.mind.special_verbs += /client/proc/fireball
							src.temp = "This spell fires a fireball at a target and does not require wizard garb. Be careful not to fire it at people that are standing next to you."
						if ("3")
							usr.verbs += /mob/proc/kill
							usr.mind.special_verbs += /mob/proc/kill
							src.temp = "This spell instantly kills somebody adjacent to you with the vilest of magick. It has a long cooldown."
						if ("4")
							usr.verbs += /mob/proc/tech
							usr.mind.special_verbs += /mob/proc/tech
							src.temp = "This spell disables all weapons, cameras and most other technology in range."
						if ("5")
							usr.verbs += /client/proc/smokecloud
							usr.mind.special_verbs += /client/proc/smokecloud
							src.temp = "This spell spawns a cloud of choking smoke at your location and does not require wizard garb."
						if ("6")
							usr.verbs += /client/proc/blind
							usr.mind.special_verbs += /client/proc/blind
							src.temp = "This spell temporarly blinds a single person and does not require wizard garb."
						if ("7")
							usr.verbs += /mob/proc/swap
							src.temp = "This spell allows the user to switch bodies with a target. Careful to not lose your memory in the process."
						if ("8")
							usr.verbs += /client/proc/forcewall
							usr.mind.special_verbs += /client/proc/forcewall
							src.temp = "This spell creates an unbreakable wall that lasts for 30 seconds and does not need wizard garb."
						if ("9")
							usr.verbs += /client/proc/blink
							usr.mind.special_verbs += /client/proc/blink
							src.temp = "This spell randomly teleports you a short distance. Useful for evasion or getting into areas if you have patience."
						if ("10")
							usr.verbs += /mob/proc/teleport
							usr.mind.special_verbs += /mob/proc/teleport
							src.temp = "This spell teleports you to a type of area of your selection. Very useful if you are in danger, but has a decent cooldown, and is unpredictable."
						if ("11")
							usr.verbs += /client/proc/mutate
							usr.mind.special_verbs += /client/proc/mutate
							src.temp = "This spell causes you to turn into a hulk and gain laser vision for a short while."
						if ("12")
							usr.verbs += /client/proc/jaunt
							usr.mind.special_verbs += /client/proc/jaunt
							src.temp = "This spell creates your ethereal form, temporarily making you invisible and able to pass through walls."
						if ("13")
							usr.verbs += /client/proc/knock
							usr.mind.special_verbs += /client/proc/knock
							src.temp = "This spell opens nearby doors and does not require wizard garb."
				else if(spell_type == "object")
					var/list/available_spells = list("Magic Missile","Fireball","Disintegrate","Disable Tech","Smoke","Blind","Mind Transfer","Forcewall","Blink","Teleport","Mutate","Ethereal Jaunt","Knock")
					var/already_knows = 0
					for(var/obj/proc_holder/spell/aspell in usr.spell_list)
						if(available_spells[text2num(href_list["spell_choice"])] == aspell.name)
							already_knows = 1
							src.temp = "You already know that spell."
							src.uses++
							break
					if(!already_knows)
						switch(href_list["spell_choice"])
							if ("1")
								usr.spell_list += new /obj/proc_holder/spell/targeted/projectile/magic_missile(usr)
								src.temp = "This spell fires several, slow moving, magic projectiles at nearby targets. If they hit a target, it is paralyzed and takes minor damage."
							if ("2")
								usr.spell_list += new /obj/proc_holder/spell/targeted/projectile/fireball(usr)
								src.temp = "This spell fires a fireball at a target and does not require wizard garb. Be careful not to fire it at people that are standing next to you."
							if ("3")
								usr.spell_list += new /obj/proc_holder/spell/targeted/inflict_handler/disintegrate(usr)
								src.temp = "This spell instantly kills somebody adjacent to you with the vilest of magick. It has a long cooldown."
							if ("4")
								usr.spell_list += new /obj/proc_holder/spell/targeted/emplosion/disable_tech(usr)
								src.temp = "This spell disables all weapons, cameras and most other technology in range."
							if ("5")
								usr.spell_list += new /obj/proc_holder/spell/targeted/smoke(usr)
								src.temp = "This spell spawns a cloud of choking smoke at your location and does not require wizard garb."
							if ("6")
								usr.spell_list += new /obj/proc_holder/spell/targeted/trigger/blind(usr)
								src.temp = "This spell temporarly blinds a single person and does not require wizard garb."
							if ("7")
								usr.spell_list += new /obj/proc_holder/spell/targeted/mind_transfer(usr)
								src.temp = "This spell allows the user to switch bodies with a target. Careful to not lose your memory in the process."
							if ("8")
								usr.spell_list += new /obj/proc_holder/spell/aoe_turf/conjure/forcewall(usr)
								src.temp = "This spell creates an unbreakable wall that lasts for 30 seconds and does not need wizard garb."
							if ("9")
								usr.spell_list += new /obj/proc_holder/spell/targeted/turf_teleport/blink(usr)
								src.temp = "This spell randomly teleports you a short distance. Useful for evasion or getting into areas if you have patience."
							if ("10")
								usr.spell_list += new /obj/proc_holder/spell/targeted/area_teleport/teleport(usr)
								src.temp = "This spell teleports you to a type of area of your selection. Very useful if you are in danger, but has a decent cooldown, and is unpredictable."
							if ("11")
								usr.spell_list += new /obj/proc_holder/spell/targeted/genetic/mutate(usr)
								src.temp = "This spell causes you to turn into a hulk and gain telekinesis for a short while."
							if ("12")
								usr.spell_list += new /obj/proc_holder/spell/targeted/ethereal_jaunt(usr)
								src.temp = "This spell creates your ethereal form, temporarily making you invisible and able to pass through walls."
							if ("13")
								usr.spell_list += new /obj/proc_holder/spell/aoe_turf/knock(usr)
								src.temp = "This spell opens nearby doors and does not require wizard garb."
			if (href_list["spell_choice"] == "14")
				var/area/wizard_station/A = locate()
				if(usr in A.contents)
					src.uses = src.max_uses
					usr.spellremove(usr,spell_type)
					src.temp = "All spells have been removed. You may now memorize a new set of spells."
				else
					src.temp = "You may only re-memorize spells whilst located inside the wizard sanctuary."
		else
			if (href_list["temp"])
				src.temp = null
		if (istype(src.loc, /mob))
			attack_self(src.loc)
		else
			for(var/mob/M in viewers(1, src))
				if (M.client)
					src.attack_self(M)
	return

//SWF UPLINK PROCS
/obj/item/weapon/SWF_uplink/attack_self(mob/user as mob)
	user.machine = src
	var/dat
	if (src.selfdestruct)
		dat = "Self Destructing..."
	else
		if (src.temp)
			dat = "[src.temp]<BR><BR><A href='byond://?src=\ref[src];temp=1'>Clear</A>"
		else
			dat = "<B>Syndicate Uplink Console:</B><BR>"
			dat += "Tele-Crystals left: [src.uses]<BR>"
			dat += "<HR>"
			dat += "<B>Request item:</B><BR>"
			dat += "<I>Each item costs 1 telecrystal. The number afterwards is the cooldown time.</I><BR>"
			dat += "<A href='byond://?src=\ref[src];spell_magicmissile=1'>Magic Missile</A> (10)<BR>"
			dat += "<A href='byond://?src=\ref[src];spell_fireball=1'>Fireball</A> (10)<BR>"
			dat += "<A href='byond://?src=\ref[src];spell_disintegrate=1'>Disintegrate</A> (60)<BR>"
			dat += "<A href='byond://?src=\ref[src];spell_emp=1'>Disable Technology</A> (60)<BR>"
			dat += "<A href='byond://?src=\ref[src];spell_smoke=1'>Smoke</A> (10)<BR>"
			dat += "<A href='byond://?src=\ref[src];spell_blind=1'>Blind</A> (30)<BR>"
			dat += "<A href='byond://?src=\ref[src];spell_swap=1'>Mind Transfer</A> (60)<BR>"
			dat += "<A href='byond://?src=\ref[src];spell_forcewall=1'>Forcewall</A> (10)<BR>"
			dat += "<A href='byond://?src=\ref[src];spell_blink=1'>Blink</A> (2)<BR>"
			dat += "<A href='byond://?src=\ref[src];spell_teleport=1'>Teleport</A> (60)<BR>"
			dat += "<A href='byond://?src=\ref[src];spell_mutate=1'>Mutate</A> (60)<BR>"
			dat += "<A href='byond://?src=\ref[src];spell_jaunt=1'>Ethereal Jaunt</A> (60)<BR>"
			dat += "<A href='byond://?src=\ref[src];spell_knock=1'>Knock</A> (10)<BR>"
			dat += "<HR>"
			if (src.origradio)
				dat += "<A href='byond://?src=\ref[src];lock=1'>Lock</A><BR>"
				dat += "<HR>"
			dat += "<A href='byond://?src=\ref[src];selfdestruct=1'>Self-Destruct</A>"
	user << browse(dat, "window=radio")
	onclose(user, "radio")
	return

/obj/item/weapon/SWF_uplink/Topic(href, href_list)
	..()
	if (usr.stat || usr.restrained())
		return
	var/mob/living/carbon/human/H = usr
	if (!( istype(H, /mob/living/carbon/human)))
		return 1
	if ((usr.contents.Find(src) || (in_range(src,usr) && istype(src.loc, /turf))))
		usr.machine = src
		if (href_list["spell_magicmissile"])
			if (src.uses >= 1)
				src.uses -= 1
				usr.verbs += /client/proc/magicmissile
				usr.mind.special_verbs += /client/proc/magicmissile
				src.temp = "This spell fires several, slow moving, magic projectiles at nearby targets. If they hit a target, it is paralyzed and takes minor damage."
		else if (href_list["spell_fireball"])
			if (src.uses >= 1)
				src.uses -= 1
				usr.verbs += /client/proc/fireball
				usr.mind.special_verbs += /client/proc/fireball
				src.temp = "This spell fires a fireball at a target and does not require wizard garb. Be careful not to fire it at people that are standing next to you."
		else if (href_list["spell_disintegrate"])
			if (src.uses >= 1)
				src.uses -= 1
				usr.verbs += /mob/proc/kill
				usr.mind.special_verbs += /mob/proc/kill
				src.temp = "This spell instantly kills somebody adjacent to you with the vilest of magick. It has a long cooldown."
		else if (href_list["spell_emp"])
			if (src.uses >= 1)
				src.uses -= 1
				usr.verbs += /mob/proc/tech
				usr.mind.special_verbs += /mob/proc/tech
				src.temp = "This spell disables all weapons, cameras and most other technology in range."
		else if (href_list["spell_smoke"])
			if (src.uses >= 1)
				src.uses -= 1
				usr.verbs += /client/proc/smokecloud
				usr.mind.special_verbs += /client/proc/smokecloud
				src.temp = "This spell spawns a cloud of choking smoke at your location and does not require wizard garb."
		else if (href_list["spell_blind"])
			if (src.uses >= 1)
				src.uses -= 1
				usr.verbs += /client/proc/blind
				usr.mind.special_verbs += /client/proc/blind
				src.temp = "This spell temporarly blinds a single person and does not require wizard garb."
		else if (href_list["spell_swap"])
			if (src.uses >= 1)
				src.uses -= 1
				usr.verbs += /mob/proc/swap
				src.temp = "This spell allows the user to switch bodies with a target. Careful to not lose your memory in the process."
		else if (href_list["spell_forcewall"])
			if (src.uses >= 1)
				src.uses -= 1
				usr.verbs += /client/proc/forcewall
				usr.mind.special_verbs += /client/proc/forcewall
				src.temp = "This spell creates an unbreakable wall that lasts for 30 seconds and does not need wizard garb."
		else if (href_list["spell_blink"])
			if (src.uses >= 1)
				src.uses -= 1
				usr.verbs += /client/proc/blink
				usr.mind.special_verbs += /client/proc/blink
				src.temp = "This spell randomly teleports you a short distance. Useful for evasion or getting into areas if you have patience."
		else if (href_list["spell_teleport"])
			if (src.uses >= 1)
				src.uses -= 1
				usr.verbs += /mob/proc/teleport
				usr.mind.special_verbs += /mob/proc/teleport
				src.temp = "This spell teleports you to a type of area of your selection. Very useful if you are in danger, but has a decent cooldown, and is unpredictable."
		else if (href_list["spell_mutate"])
			if (src.uses >= 1)
				src.uses -= 1
				usr.verbs += /client/proc/mutate
				usr.mind.special_verbs += /client/proc/mutate
				src.temp = "This spell causes you to turn into a hulk and gain telekinesis for a short while."
		else if (href_list["spell_jaunt"])
			if (src.uses >= 1)
				src.uses -= 1
				usr.verbs += /client/proc/jaunt
				usr.mind.special_verbs += /client/proc/jaunt
				src.temp = "This spell creates your ethereal form, temporarily making you invisible and able to pass through walls."
		else if (href_list["spell_knock"])
			if (src.uses >= 1)
				src.uses -= 1
				usr.verbs += /client/proc/knock
				usr.mind.special_verbs += /client/proc/knock
				src.temp = "This spell opens nearby doors and does not require wizard garb."
		else if (href_list["lock"] && src.origradio)
			// presto chango, a regular radio again! (reset the freq too...)
			usr.machine = null
			usr << browse(null, "window=radio")
			var/obj/item/device/radio/T = src.origradio
			var/obj/item/weapon/SWF_uplink/R = src
			R.loc = T
			T.loc = usr
			// R.layer = initial(R.layer)
			R.layer = 0
			if (usr.client)
				usr.client.screen -= R
			if (usr.r_hand == R)
				usr.u_equip(R)
				usr.r_hand = T
			else
				usr.u_equip(R)
				usr.l_hand = T
			R.loc = T
			T.layer = 20
			T.set_frequency(initial(T.frequency))
			T.attack_self(usr)
			return
		else if (href_list["selfdestruct"])
			src.temp = "<A href='byond://?src=\ref[src];selfdestruct2=1'>Self-Destruct</A>"
		else if (href_list["selfdestruct2"])
			src.selfdestruct = 1
			spawn (100)
				explode()
				return
		else
			if (href_list["temp"])
				src.temp = null
		if (istype(src.loc, /mob))
			attack_self(src.loc)
		else
			for(var/mob/M in viewers(1, src))
				if (M.client)
					src.attack_self(M)
	return

/obj/item/weapon/SWF_uplink/proc/explode()
	var/turf/location = get_turf(src.loc)
	location.hotspot_expose(700, 125)

	explosion(location, 0, 0, 2, 4)

	del(src.master)
	del(src)
	return
