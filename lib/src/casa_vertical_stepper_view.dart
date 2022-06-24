import 'package:casa_vertical_stepper/src/model/stepper_steps.dart';
import 'package:flutter/material.dart';

part "../src/utils/consts.dart";

class CasaVerticalStepperView extends StatefulWidget {
  final List<StepperStep> steps;
  final Color? completeColor;
  final Color? inProgressColor;
  final Color? upComingColor;

  /// this color will apply single color to all seperator line
  /// if this value is null then apply color according to [completeColor], [inProgressColor], [upComingColor]
  final Color? seperatorColor;
  final bool isExpandable;
  final bool showStepStatusWidget;
  const CasaVerticalStepperView({
    required this.steps,
    this.completeColor,
    this.inProgressColor,
    this.upComingColor,
    this.seperatorColor,
    this.isExpandable = false,
    this.showStepStatusWidget = true,
    Key? key,
  }) : super(key: key);

  @override
  State<CasaVerticalStepperView> createState() =>
      _CasaVerticalStepperViewState();
}

class _CasaVerticalStepperViewState extends State<CasaVerticalStepperView> {
  late final Color completeColor;
  late final Color inProgressColor;
  late final Color upComingColor;
  late List<StepperStep> steps = widget.steps;

  late List<GlobalKey> _keys;

  @override
  void initState() {
    initColors();
    _keys = List<GlobalKey>.generate(
      widget.steps.length,
      (int i) => GlobalKey(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildVertical();
  }

  initColors() {
    completeColor = widget.completeColor ?? _defaultPrimaryColor;
    inProgressColor = widget.inProgressColor ?? _defaultInProgressColor;
    upComingColor = widget.upComingColor ?? _defaultUpComingViewColor;
  }

  Widget _buildVertical() {
    return widget.isExpandable
        ? _buildPanel()
        : ListView(
            shrinkWrap: true,
            // physics: widget.physics,
            children: steps
                .map((step) => Column(
                      key: _keys[steps.indexOf(step)],
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildVerticalHeader(step),
                        _buildVerticalBody(step),
                      ],
                    ))
                .toList(),
          );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      elevation: 0.0,
      // dividerColor: Colors.black,
      expandedHeaderPadding: EdgeInsets.zero,
      expansionCallback: (int index, bool isExpanded) {
        debugPrint("isExpanded: $isExpanded");
        debugPrint("isExpanded: $index");
        setState(() {
          widget.steps[index].isExpanded = !isExpanded;
        });
      },
      children: steps.map<ExpansionPanel>((StepperStep step) {
        return ExpansionPanel(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return _buildVerticalHeader(step);
          },
          body: _buildVerticalBody(step),
          isExpanded: step.isExpanded,
        );
      }).toList(),
    );
  }

  Color _stepColor(StepStatus status) {
    if (status == StepStatus.complete) {
      return completeColor;
    } else if (status == StepStatus.inprogress) {
      return inProgressColor;
    } else if (status == StepStatus.upcoming) {
      return upComingColor;
    } else {
      return _defaultFailColor;
    }
  }

  Widget _buildVerticalHeader(StepperStep step) {
    StepStatus status = step.status;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: _kStepMargin),
      child: Row(
        children: <Widget>[
          _buildIcon(step),
          Container(
            margin: const EdgeInsetsDirectional.only(start: _kStepSpacing),
            child: Text(
              step.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: status == StepStatus.upcoming
                    ? upComingColor
                    : Colors.black,
              ),
            ),
          ),
          const Spacer(),
          status != StepStatus.upcoming && widget.showStepStatusWidget
              ? _trailingWidget(status)
              : const SizedBox(width: 0, height: 0),
        ],
      ),
    );
  }

  Widget _buildVerticalBody(StepperStep step) {
    const kTopMargin = 10.0;
    return Stack(
      children: <Widget>[
        PositionedDirectional(
          start: _kStepMargin,
          top: kTopMargin,
          bottom: _kStepMargin,
          child: SizedBox(
            width: _kStepSize,
            child: Center(
              child: SizedBox(
                width: _kLineWidth,
                child: Container(
                    color: widget.seperatorColor ?? _stepColor(step.status)),
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsetsDirectional.only(
            start: 1.5 * _kStepMargin + _kStepSize,
            end: _kStepMargin,
            bottom: _kStepMargin,
            top: kTopMargin,
          ),
          child: step.status == StepStatus.fail ? step.failedView : step.view,
        ),
      ],
    );
  }

  Widget _buildIcon(StepperStep step) {
    const double iconSize = 34.0;
    final status = step.status;
    if (step.leading != null) {
      return step.leading!;
    } else {
      switch (status) {
        case StepStatus.complete:
          return Icon(Icons.check_box, color: completeColor, size: iconSize);

        case StepStatus.inprogress:
          return Icon(Icons.check_box_outlined,
              color: inProgressColor, size: iconSize);

        case StepStatus.upcoming:
          return Icon(Icons.check_box_outlined,
              color: upComingColor, size: iconSize);

        case StepStatus.fail:
          return Icon(Icons.warning, color: _defaultFailColor, size: iconSize);
        case StepStatus.none:
          return Icon(Icons.check_box_outlined,
              color: inProgressColor, size: iconSize);
      }
    }
  }

  Widget _trailingWidget(StepStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: status == StepStatus.complete
              ? _stepColor(status).withOpacity(0.1)
              : _stepColor(status)),
      child: Text(
        stepperStepToString(status),
        style: TextStyle(
          color: status == StepStatus.complete ? completeColor : Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}
