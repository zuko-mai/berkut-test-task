import 'package:berkut/helpers/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TextFieldWidget extends StatefulWidget {
  final Function(String) onSearch;

  const TextFieldWidget({
    super.key,
    required this.onSearch,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.trim().isNotEmpty) {
      widget.onSearch(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
            child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Поиск',
            hintStyle: AppFonts.lightSubtitle,
            suffixIcon: GestureDetector(
              onTap: () {
                _onSearch(_controller.text);
                FocusScope.of(context).unfocus(); // Dismiss the keyboard
              },
              child: Container(
                  width: 23,
                  height: 23,
                  margin: const EdgeInsets.only(right: 5),
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset('assets/svgs/search.svg',
                      color: Colors.black)),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 20,
            ),
          ),
          style: AppFonts.lightSubtitle,
          onSubmitted: _onSearch,
          textInputAction: TextInputAction.search,
        )));
  }
}
