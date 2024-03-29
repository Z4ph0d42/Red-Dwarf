/*
CONTAINS:
NO MORE BANANA, NOW YOU CAN EAT IT. GO SEE OTHER FOOD STUFFS.
BANANA PEEL
SOAP
BIKE HORN

*/

/obj/item/weapon/bananapeel/HasEntered(AM as mob|obj)
	if (istype(AM, /mob/living/carbon))
		var/mob/M =	AM
		if (istype(M, /mob/living/carbon/human) && (isobj(M:shoes) && M:shoes.flags&NOSLIP))
			return

		M.pulling = null
		M << "\blue You slipped on the [name]!"
		playsound(src.loc, 'slip.ogg', 50, 1, -3)
		M.stunned = 8
		M.weakened = 5

/obj/item/weapon/reagent_containers/food/snacks/grown/bluetomato/HasEntered(AM as mob|obj)
	if (istype(AM, /mob/living/carbon))
		var/mob/M =	AM
		if (istype(M, /mob/living/carbon/human) && (isobj(M:shoes) && M:shoes.flags&NOSLIP))
			return

		M.pulling = null
		M << "\blue You slipped on the [name]!"
		playsound(src.loc, 'slip.ogg', 50, 1, -3)
		M.stunned = 10
		M.weakened = 7

/obj/item/weapon/soap/HasEntered(AM as mob|obj) //EXACTLY the same as bananapeel for now, so it makes sense to put it in the same dm -- Urist
	if (istype(AM, /mob/living/carbon))
		var/mob/M =	AM
		if (istype(M, /mob/living/carbon/human) && (isobj(M:shoes) && M:shoes.flags&NOSLIP))
			return

		M.pulling = null
		M << "\blue You slipped on the [name]!"
		playsound(src.loc, 'slip.ogg', 50, 1, -3)
		M.stunned = 8
		M.weakened = 5

/obj/item/weapon/soap/afterattack(atom/target, mob/user as mob)
	if(istype(target,/obj/decal/cleanable))
		del(target)
		user << "\blue You scrub the [name] out."
	else
		target.clean_blood()
		user << "\blue You clean the [target.name]."
	return

/obj/item/weapon/bikehorn/attack_self(mob/user as mob)
	if (spam_flag == 0)
		spam_flag = 1
		playsound(src.loc, 'bikehorn.ogg', 50, 1)
		src.add_fingerprint(user)
		spawn(20)
			spam_flag = 0
	return