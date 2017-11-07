//WEAPON TYPE- Acts as both an identifier and a force multiplier and speed multiplier
#define MELEE_TYPE_DAGGER 0.5
#define MELEE_TYPE_SWORD 2
#define MELEE_TYPE_GREATSWORD 3.5
#define MELEE_TYPE_MACE 3
#define MELEE_TYPE_WARHAMMER 5

//STABBINESS DEFINES - //Affects the rate of reagent transfer and the type, values below 1 are considered blunt and will apply touch effects
#define TRANSFER_SHARP 1
#define TRANSFER_SHARPER 1.5
#define TRANSFER_SHARPEST 2
#define TRANSFER_PARTIALLY_BLUNT 0.5
#define TRANSFER_BLUNT 0.1
#define TRANSFER_SHARP_BONUS 0.4


//SPECIAL TRAITS
#define SPECIAL_TRAIT_METALLIC "metallic"//applies to all metallic elements, additive force buff
#define SPECIAL_TRAIT_SHARP "sharp"//often found with traditional sword materials, buff to bleeding/delimb chance
#define SPECIAL_TRAIT_RADIOACTIVE "radioactive"//the weapon will emit radiation continously
#define SPECIAL_TRAIT_ULTRADENSE "ultradense"//slow speed but immense momentum, throws people back, bullets have forcedodge
#define SPECIAL_TRAIT_MAGNETIC "magnetic"//catch all term for attractive or repulsive effects
#define SPECIAL_TRAIT_REFLECTIVE "reflective"//melee gets reflect chance
#define SPECIAL_TRAIT_BOUNCY "bouncy"//high ricochet chance for bullets