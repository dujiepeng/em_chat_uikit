import 'dart:math';

class RemoteAvatars {
  static const List<String> avatars = [
    'https://cdn4.iconfinder.com/data/icons/avatars-xmas-giveaway/128/batman_hero_avatar_comics-512.png',
    'https://cdn1.iconfinder.com/data/icons/user-pictures/100/male3-512.png',
    'https://cdn4.iconfinder.com/data/icons/avatars-xmas-giveaway/128/muslim_man_avatar-512.png',
    'https://cdn4.iconfinder.com/data/icons/avatars-xmas-giveaway/128/cactus_cacti_avatar_pirate-512.png',
    'https://cdn4.iconfinder.com/data/icons/avatars-xmas-giveaway/128/geisha_japanese_woman_avatar-512.png',
    'https://cdn4.iconfinder.com/data/icons/avatars-xmas-giveaway/128/sloth_lazybones_sluggard_avatar-128.png',
    'https://cdn4.iconfinder.com/data/icons/avatars-xmas-giveaway/128/grandma_elderly_nanny_avatar-512.png',
    'https://cdn4.iconfinder.com/data/icons/avatars-xmas-giveaway/128/punk_man_person_avatar-512.png',
    'https://cdn4.iconfinder.com/data/icons/avatars-xmas-giveaway/128/girl_avatar_child_kid-512.png',
    'https://cdn4.iconfinder.com/data/icons/avatars-xmas-giveaway/128/muslim_woman_paranja_avatar-512.png',
    'https://cdn4.iconfinder.com/data/icons/avatars-xmas-giveaway/128/zombie_avatar_monster_dead-512.png',
    'https://cdn4.iconfinder.com/data/icons/avatars-xmas-giveaway/128/afro_avatar_male_man-512.png'
  ];

  static String get getRandomAvatar {
    return avatars[Random().nextInt(avatars.length)];
  }
}
