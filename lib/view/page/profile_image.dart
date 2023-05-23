import 'package:enfp/global/string.dart';
import 'package:enfp/presenter/model/user.dart';
import 'package:enfp/presenter/page/lang.dart';
import 'package:enfp/presenter/page/profile_image.dart';
import 'package:enfp/presenter/page/setting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class ProfileImagePage extends StatelessWidget {
  const ProfileImagePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userP = Get.find<UserP>();

    return GetBuilder<ProfileImageP>(
      builder: (profileImageP) {
        bool isMe = profileImageP.user.uid == userP.loggedUser!.uid;
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            leading: GestureDetector(
              onTap: isMe ? SettingP.toSetting : Get.back,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
            ),
            actions: [
              if (isMe)
              profileImageP.editMode ? IconButton(
                icon: Text(capitalizeFirstChar(LangP.find('save'))),
                onPressed: profileImageP.submit,
              ) : IconButton(
                icon: const Icon(
                  Icons.photo,
                  color: Colors.white,
                ),
                onPressed: profileImageP.pickImage,
              ),
            ],
            backgroundColor: Colors.transparent,
          ),
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: PhotoView(
                    enableRotation: false,
                    imageProvider: NetworkImage(
                      profileImageP.user.imageUrl,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      profileImageP.user.nickname,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                    ),
                  ),
                ),
                if (profileImageP.loading)
                Positioned.fill(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
