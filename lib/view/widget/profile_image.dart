import 'package:enfp/model/class/user.dart';
import 'package:enfp/presenter/page/profile_image.dart';
import 'package:enfp/view/widget/scale_widget.dart';
import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  const ProfileImageWidget({
    Key? key,
    this.size = 40.0,
    required this.user,
  }) : super(key: key);

  final double size;
  final EUser user;

  @override
  Widget build(BuildContext context) {

    return ScaleWidget(
      onPressed: () => ProfileImageP.toProfileImage(user),
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.circular(size * .35),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size * .35),
          child: Image.network(
            user.imageUrl,
            width: size, height: size,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
