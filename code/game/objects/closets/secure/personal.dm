/obj/secure_closet/personal/var/registered = null
/obj/secure_closet/personal/req_access = list(access_all_personal_lockers)

/obj/secure_closet/personal/New()
	..()
	spawn(2)
		new /obj/item/device/radio/signaler( src )
		new /obj/item/weapon/pen( src )
		new /obj/item/weapon/storage/backpack( src )
		new /obj/item/device/radio/headset( src )
	return

/obj/secure_closet/personal/patient/New()
	..()
	contents = list()
	spawn(4)
		new /obj/item/clothing/under/color/white( src )
		new /obj/item/clothing/shoes/white( src )
	return

/obj/secure_closet/personal/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (src.opened)
		if (istype(W, /obj/item/weapon/grab))
			src.MouseDrop_T(W:affecting, user)      //act like they were dragged onto the closet
		user.drop_item()
		if (W) W.loc = src.loc
	else if (istype(W, /obj/item/weapon/card/id)||istype(W, /obj/item/device/pda))
		if(istype(W, /obj/item/device/pda))
			var/obj/item/device/pda/pda = W
			W = pda.id
		if(src.broken)
			user << "\red It appears to be broken."
			return
		var/obj/item/weapon/card/id/I = W
		if (src.allowed(user) || !src.registered || (istype(I) && (src.registered == I.registered)))
			//they can open all lockers, or nobody owns this, or they own this locker
			src.locked = !( src.locked )
			for(var/mob/O in viewers(user, 3))
				if ((O.client && !( O.blinded )))
					O << text("\blue The locker has been []locked by [].", (src.locked ? null : "un"), user)
			if(src.locked)
				src.icon_state = src.icon_locked
			else
				src.icon_state = src.icon_closed
			if (!src.registered)
				src.registered = I.registered
				src.desc = "Owned by [I.registered]."
		else
			user << "\red Access Denied"
	else if( (istype(W, /obj/item/weapon/card/emag)||istype(W, /obj/item/weapon/melee/energy/blade)) && !src.broken)
		broken = 1
		locked = 0
		desc = "It appears to be broken."
		icon_state = src.icon_broken
		if(istype(W, /obj/item/weapon/melee/energy/blade))
			var/datum/effects/system/spark_spread/spark_system = new /datum/effects/system/spark_spread()
			spark_system.set_up(5, 0, src.loc)
			spark_system.start()
			playsound(src.loc, 'blade1.ogg', 50, 1)
			playsound(src.loc, "sparks", 50, 1)
			for(var/mob/O in viewers(user, 3))
				O.show_message(text("\blue The locker has been sliced open by [] with an energy blade!", user), 1, text("\red You hear metal being sliced and sparks flying."), 2)
		else
			for(var/mob/O in viewers(user, 3))
				O.show_message(text("\blue The locker has been broken by [] with an electromagnetic card!", user), 1, text("You hear a faint electrical spark."), 2)
	else
		user << "\red Access Denied"
	return
