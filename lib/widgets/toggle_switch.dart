import 'package:flutter/material.dart';

import 'package:user/modules/app_theme.dart';


class ToggleSwitch extends StatefulWidget {

  final double width;
  final List<String> options;
  final int initialIndex;
  final Function(int)? onChange;

  const ToggleSwitch({
    super.key,
    required this.width,
    required this.options,
    required this.initialIndex,
    this.onChange,
  });

  @override
  State<StatefulWidget> createState() => _ToggleSwitch();
}

class _ToggleSwitch extends State<ToggleSwitch> {

  late int _switchIndex;
  final _toggleButtonAlignment = <Alignment> [
    Alignment.centerLeft,
    Alignment.center,
    Alignment.centerRight,
  ];


  @override
  void initState() {
    _switchIndex = widget.initialIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.grey,
      ),
      child: Stack(
        children: [
          Row(
            children: <Expanded> [
              for(int i = 0; i < widget.options.length; i++) ...[
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _switchIndex = i;
                      });
                      if(widget.onChange != null){
                        widget.onChange!(i);
                      }
                    },
                    child: Center(
                      child: Text(
                        widget.options[i],
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          AnimatedAlign(
            alignment: _toggleButtonAlignment[_switchIndex],
            duration: const Duration(milliseconds: 200),
            child: Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
              ),
              width: widget.width / widget.options.length - 10,
              child: Center(
                child: Text(
                  widget.options[_switchIndex],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.blue,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}