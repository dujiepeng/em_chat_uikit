import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ChangeAvatarPage extends StatefulWidget {
  const ChangeAvatarPage({super.key});

  @override
  State<ChangeAvatarPage> createState() => _ChangeAvatarPageState();
}

class _ChangeAvatarPageState extends State<ChangeAvatarPage> {
  int _selected = -1;
  final List<String> avatars = [
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

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: ChatUIKitAppBar(
        title: '修改头像',
        titleTextStyle: TextStyle(
          fontSize: theme.font.titleMedium.fontSize,
          fontWeight: theme.font.titleMedium.fontWeight,
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: GridView.custom(
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          childrenDelegate: SliverChildBuilderDelegate((context, position) {
            return InkWell(
              onTap: () {
                if (_selected == position) {
                  _selected = -1;
                } else {
                  _selected = position;
                  UserData? data = ChatUIKitProvider.instance.currentUserData;
                  if (data == null) {
                    data = UserData(avatarUrl: avatars[position]);
                  } else {
                    data = data.copyWith(avatarUrl: avatars[position]);
                  }
                  ChatUIKitProvider.instance.currentUserData = data;
                }
                setState(() {});
              },
              child: Stack(
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    )),
                    margin: const EdgeInsets.all(10),
                    child: ChatUIKitAvatar(
                        avatarUrl: avatars[position], size: 300),
                  ),
                  Positioned.fill(
                    child: Offstage(
                      offstage: _selected != position,
                      child: Image.asset(
                        'assets/images/avatar_selected.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  )
                ],
              ),
            );
          }, childCount: avatars.length),
        ),
      ),
    );
  }
}
