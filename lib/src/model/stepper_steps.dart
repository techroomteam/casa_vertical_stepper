import 'package:flutter/material.dart';

enum StepStatus { none, complete, inprogress, upcoming, fail }

String stepperStepToString(StepStatus status) {
  switch (status) {
    case StepStatus.complete:
      return 'Completed';
    case StepStatus.inprogress:
      return 'In Progress';
    case StepStatus.upcoming:
      return 'Upcoming';
    case StepStatus.fail:
      return 'Failed';
    case StepStatus.none:
      return '';
  }
}

class StepperStep {
  final String title;
  final Widget? leading;
  final Widget view;
  final Widget? failedView;
  final StepStatus status;
  bool isExpanded;

  StepperStep({
    required this.title,
    required this.view,
    this.status = StepStatus.none,
    this.failedView,
    this.leading,
    this.isExpanded = true,
  });
}
