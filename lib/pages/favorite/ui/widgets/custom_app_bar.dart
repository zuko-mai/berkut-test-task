import 'package:auto_route/auto_route.dart';
import 'package:berkut/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomAppBar extends StatelessWidget {
  final int hideIcon;
  const CustomAppBar({super.key, this.hideIcon = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(color: Colors.black),
        height: 80,
        child: Row(
          children: [
            SvgPicture.asset('assets/svgs/logo.svg'),
            Spacer(),
            if (hideIcon != 1) ...[
              GestureDetector(
                child: SvgPicture.asset('assets/svgs/search.svg'),
                onTap: () {
                  context.router.replace(SearchRoute());
                },
              ),
              SizedBox(width: 20),
            ],
            if (hideIcon != 2)
              GestureDetector(
                child: SvgPicture.asset('assets/svgs/like.svg'),
                onTap: () {
                  context.router.replace(FavoriteRoute());
                },
              )
          ],
        ));
  }
}
