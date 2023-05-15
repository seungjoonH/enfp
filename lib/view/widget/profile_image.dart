import 'package:enfp/presenter/model/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileImageWidget extends StatelessWidget {
  const ProfileImageWidget({
    Key? key,
    this.size = 40.0,
    this.imageUrl
  }) : super(key: key);

  final double size;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final userP = Get.find<UserP>();
    // imageUrl = userP.loggedUser.imageUrl;

    return ClipRRect(
      borderRadius: BorderRadius.circular(size * .35),
      child: Image.network(
        imageUrl ?? userP.loggedUser.imageUrl ?? "",
        width: size, height: size,
      ),
    );
  }
}
